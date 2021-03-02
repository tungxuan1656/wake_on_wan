//
//  RegisterPCViewController.swift
//  wow
//
//  Created by Tung Xuan on 2/25/21.
//

import UIKit

class RegisterPCViewController: UIViewController {
	
	@IBOutlet weak var labelTitle: UILabel!
	@IBOutlet weak var textfieldName: UITextField!
	@IBOutlet weak var textfieldMAC: UITextField!
	@IBOutlet weak var textfieldAddressBroadcast: UITextField!
	@IBOutlet weak var textfieldAddressRD: UITextField!
	@IBOutlet weak var constraintBottomScrollView: NSLayoutConstraint!
	
	var pc: PC? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		self.setupUI()
	}
	
	init() {
		super.init(nibName: "RegisterPCViewController", bundle: nil)
		self.initObserverKeyboard()
	}
	
	deinit {
		self.removeObserverKeyboard()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
		self.labelTitle.text = self.pc != nil ? "Edit Your PC" : "Add Your PC"
		if let pc = self.pc {
			self.textfieldName.text = pc.name
			self.textfieldMAC.text = pc.MAC
			self.textfieldAddressBroadcast.text = "\(pc.ip):\(pc.port)"
			if pc.ipRD != "" {
				self.textfieldAddressRD.text = "\(pc.ipRD):\(pc.portRD)"
			}
		}
	}
	
	// MARK: - Button Event
	@IBAction func onClickButtonBack(_ sender: Any) {
		self.onBackViewController()
	}
	
	@IBAction func onClickButtonDone(_ sender: Any) {
		let name = self.textfieldName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
		let mac = self.textfieldMAC.text?.trimmingCharacters(in: .whitespacesAndNewlines)
		let addressBroadcast = self.textfieldAddressBroadcast.text?.trimmingCharacters(in: .whitespacesAndNewlines)
		let addressRD = self.textfieldAddressRD.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		
		if name == nil || mac == nil || addressBroadcast == nil {
			self.showAlertDialog(title: "Failed", message: "Lack of information")
			return
		}
		
		// check name
		let n = Global.arrPCs.map { $0.name }
		if n.contains(name!) && name != self.pc?.name {
			self.showAlertDialog(title: "Failed", message: "Name already exists")
			return
		}
		
		// check MAC
		if !mac!.isValidMACAddress() {
			self.showAlertDialog(title: "Failed", message: "MAC address is incorrectly formatted")
			return
		}
		
		// broadcast address
		let a = addressBroadcast?.split(separator: ":").map { String($0) }
		if a?.count != 2 {
			self.showAlertDialog(title: "Failed", message: "Broadcast address is incorrectly formatted or missing port")
			return
		}
		let broadcastHost = a![0]
		let broadcastPort = Int(a![1])
		
		// check ip or domain
		if !broadcastHost.isIpAddress() {
			var a = broadcastHost
			if !broadcastHost.hasPrefix("http") && !broadcastHost.hasPrefix("https") {
				a = "http://\(broadcastHost)"
			}
			if !a.isHost() {
				self.showAlertDialog(title: "Failed", message: "Broadcast address is incorrectly formatted or missing port")
				return
			}
		}

		// check port
		if broadcastPort == nil || broadcastPort! <= 0 {
			self.showAlertDialog(title: "Failed", message: "Broadcast port is incorrectly formatted")
			return
		}
		
		var rdHost = ""
		var rdPort: Int? = 0
		
		if addressRD != "" {
			// RD address
			let a = addressRD.split(separator: ":").map { String($0) }
			if a.count != 2 {
				self.showAlertDialog(title: "Failed", message: "Remote desktop address is incorrectly formatted or missing port")
				return
			}
			rdHost = a[0]
			rdPort = Int(a[1])
			
			// check ip or domain
			if !rdHost.isIpAddress() {
				var a = rdHost
				if !rdHost.hasPrefix("http") && !rdHost.hasPrefix("https") {
					a = "http://\(broadcastHost)"
				}
				if !a.isHost() {
					self.showAlertDialog(title: "Failed", message: "Remote desktop address is incorrectly formatted or missing port")
					return
				}
			}

			// check port
			if rdPort == nil || rdPort! <= 0 {
				self.showAlertDialog(title: "Failed", message: "Remote desktop port is incorrectly formatted")
				return
			}
		}
		
		let newPC = PC(name: name!, MAC: mac!, ip: broadcastHost, port: broadcastPort!, ipRD: rdHost, portRD: rdPort!)
		if let pc = self.pc {
			if pc.name == Global.selectedPC?.name {
				Global.selectedPC = newPC
				NotificationCenter.default.post(name: .SelectedNewPC, object: nil)
			}
			
			for (i, p) in Global.arrPCs.enumerated() {
				if p.name == pc.name {
					Global.arrPCs.remove(at: i)
					Global.arrPCs.insert(newPC, at: i)
					NotificationCenter.default.post(name: .EditedPC, object: nil)
					break
				}
			}
		}
		else {
			Global.arrPCs.append(newPC)
			NotificationCenter.default.post(name: .AddNewPC, object: nil)
		}
		
		self.onClickButtonBack(self)
	}
}

extension String {
	func isValidMACAddress() -> Bool {
		var returnValue = true
		let macRegEx = "^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$" // Format Only: XX:XX:XX:XX:XX:XX
		//let macRegEx = "^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$" // Format: XX:XX:XX:XX:XX:XX and XX-XX-XX-XX-XX-XX
		do {
			let regex = try NSRegularExpression(pattern: macRegEx)
			let nsString = self as NSString
			let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
			
			if results.count == 0
			{
				returnValue = false
			}
		} catch let error as NSError {
			print("invalid regex: \(error.localizedDescription)")
			returnValue = false
		}
		return  returnValue
	}
	
	func isIPv4() -> Bool {
		var sin = sockaddr_in()
		return self.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1
	}
	
	func isIPv6() -> Bool {
		var sin6 = sockaddr_in6()
		return self.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1
	}
	
	func isIpAddress() -> Bool { return self.isIPv6() || self.isIPv4() }
	
	func isHost() -> Bool { return URL(string: self) != nil }
}

extension RegisterPCViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case textfieldName:
			self.textfieldMAC.becomeFirstResponder()
		case textfieldMAC:
			self.textfieldAddressBroadcast.becomeFirstResponder()
		case textfieldAddressBroadcast:
			self.textfieldAddressRD.becomeFirstResponder()
		default:
			self.view.endEditing(true)
		}
		
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.add(border: .bottom, color: .systemGreen, width: 2)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		textField.remove(border: .bottom)
	}
}

extension RegisterPCViewController {
	override func keyboardWillHide() {
		self.constraintBottomScrollView.constant = 0
	}
	
	override func keyboardWillShow(height: CGFloat) {
		self.constraintBottomScrollView.constant = height
	}
}
