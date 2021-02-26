//
//  HomeViewController.swift
//  wow
//
//  Created by Tung Xuan on 2/25/21.
//

import UIKit

class HomeViewController: UIViewController {
	
	@IBOutlet weak var buttonPower: UIButton!
	@IBOutlet weak var buttonPC: UIButton!
	@IBOutlet weak var labelMACAddress: UILabel!
	@IBOutlet weak var labelIPAddressAndPort: UILabel!
	@IBOutlet weak var indicator: UIActivityIndicatorView!
	
	var onSendingMagicPacket = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.setupUI()
	}
	
	init() {
		super.init(nibName: "HomeViewController", bundle: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .SelectedNewPC, object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: .SelectedNewPC, object: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.enableNavigationPopGesture()
	}
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
	// MARK: - Setup UI
	func setupUI() {
		self.buttonPC.layer.cornerRadius = 10
		self.buttonPower.layer.cornerRadius = self.buttonPower.frame.width / 2
		// self.setStateButtonPower(inProcessing: true)
		self.updateUI()
	}
	
	@objc func updateUI() {
		if let pc = Global.selectedPC {
			self.buttonPC.setTitle(pc.name, for: .normal)
			self.labelMACAddress.text = "MAC Address: \(pc.MAC)"
			self.labelIPAddressAndPort.text = "\(pc.ip):\(pc.port)"
		}
		else {
			self.buttonPC.setTitle("Select or Add new PC", for: .normal)
			self.labelMACAddress.text = ""
			self.labelIPAddressAndPort.text = ""
		}
	}
	
	func setStateButtonPower(inProcessing: Bool) {
		if inProcessing {
			self.buttonPower.setImage(nil, for: .normal)
		}
		else {
			let power = UIImage(systemName: "power", withConfiguration: UIImage.SymbolConfiguration(pointSize: 140, weight: .bold))
			self.buttonPower.setImage(power, for: .normal)
		}
		self.buttonPower.layer.cornerRadius = self.buttonPower.frame.width / 2
	}
	
	// MARK: - Button Event
	@IBAction func onClickButtonPower(_ sender: Any) {
		if self.onSendingMagicPacket { return }
		self.onSendingMagicPacket = true
		self.indicator.startAnimating()
		
		DispatchQueue.global().async {
			let error = self.sendMagicPacket()
			self.onSendingMagicPacket = false
			
			DispatchQueue.main.async {
				self.indicator.stopAnimating()
				if error != nil {
					self.showAlertDialog(title: "Failed", message: error.debugDescription)
				}
				else {
					self.showAlertDialog(title: "Success", message: "Send magic packet done!")
				}
			}
		}
	}
	
	@IBAction func onClickButtonPC(_ sender: Any) {
		let listPC = ListPCViewController()
		self.navigationController?.pushViewController(listPC, animated: true)
	}
	
	@IBAction func onClickButtonAbout(_ sender: Any) {
		let about = AboutViewController()
		self.present(about, animated: true, completion: nil)
	}
	
	// MARK: - Utils
	enum WakeError: Error {
		case SocketSetupFailed(reason: String)
		case SetSocketOptionsFailed(reason: String)
		case SendMagicPacketFailed(reason: String)
	}
	
	func sendMagicPacket() -> Error? {
		guard let pc = Global.selectedPC else {
			self.showAlertDialog(title: "Failed", message: "You not select any PC")
			return nil
		}
		var ip = pc.ip
		
		if ip.hasPrefix("http"), let url = URL(string: ip) {
			if let i = self.urlToIP_getHostByName(url).first {
				ip = i
			}
		}
		if ip.hasPrefix("http") {
			self.showAlertDialog(title: "Failed", message: "Cannot get ip by host name!")
		}
		let packet = self.createMagicPacket(mac: pc.MAC)
		
		print("\n MAGIC PACKET", packet)
		
		var sock: Int32
		var target = sockaddr_in()
		
		target.sin_family = sa_family_t(AF_INET)
		target.sin_addr.s_addr = inet_addr(ip)
		
		let port = UInt16(pc.port)
		
		let isLittleEndian = Int(OSHostByteOrder()) == OSLittleEndian
		target.sin_port = isLittleEndian ? _OSSwapInt16(port) : port
		
		// Setup the packet socket
		sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
		if sock < 0 {
			let err = String(utf8String: strerror(errno)) ?? ""
			return WakeError.SocketSetupFailed(reason: err)
		}
		
		let sockaddrLen = socklen_t(MemoryLayout<sockaddr>.stride)
		let intLen = socklen_t(MemoryLayout<Int>.stride)
		
		// Set socket options
		var broadcast = 1
		if setsockopt(sock, SOL_SOCKET, SO_BROADCAST, &broadcast, intLen) == -1 {
			close(sock)
			let err = String(utf8String: strerror(errno)) ?? ""
			return WakeError.SetSocketOptionsFailed(reason: err)
		}
		
		// Send magic packet
		var targetCast = unsafeBitCast(target, to: sockaddr.self)
		if sendto(sock, packet, packet.count, 0, &targetCast, sockaddrLen) != packet.count {
			close(sock)
			let err = String(utf8String: strerror(errno)) ?? ""
			return WakeError.SendMagicPacketFailed(reason: err)
		}
		
		close(sock)
		return nil
	}
	
	func createMagicPacket(mac: String) -> [CUnsignedChar] {
		var buffer = [CUnsignedChar]()
		
		// Create header
		for _ in 1...6 {
			buffer.append(0xFF)
		}
		
		let components = mac.components(separatedBy: ":")
		let numbers = components.map {
			return strtoul($0, nil, 16)
		}
		
		// Repeat MAC address 16 times
		for _ in 1...16 {
			for number in numbers {
				buffer.append(CUnsignedChar(number))
			}
		}
		
		return buffer
	}
	
	private func urlToIP_getHostByName(_ url: URL) -> [String] {
		var ipList: [String] = []
		guard let hostname = url.host else { return ipList }
		guard let host = hostname.withCString({gethostbyname($0)}) else { return ipList }
		guard host.pointee.h_length > 0 else { return ipList }

		var index = 0
		while host.pointee.h_addr_list[index] != nil {
			var addr: in_addr = in_addr()
			memcpy(&addr.s_addr, host.pointee.h_addr_list[index], Int(host.pointee.h_length))
			guard let remoteIPAsC = inet_ntoa(addr) else { return ipList }
			ipList.append(String.init(cString: remoteIPAsC))
			index += 1
		}

		return ipList
	}
}

// MARK: Navigation Pop
extension HomeViewController: UIGestureRecognizerDelegate {
	func enableNavigationPopGesture() {
		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		self.navigationController?.interactivePopGestureRecognizer?.delegate = self
	}
	
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
