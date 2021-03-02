//
//  PC.swift
//  wow
//
//  Created by Tung Xuan on 2/25/21.
//

import Foundation

struct PC: Decodable {
	var name: String = "Your PC"
	var ip: String = "192.168.1.255"
	var port: Int = 9
	var ipRD: String = ""
	var portRD: Int = 3389
	var MAC: String = "FF:FF:FF:FF:FF:FF"
	
	func toString() -> String {
		return "\(name)|\(ip)|\(port)|\(ipRD)|\(portRD)|\(MAC)"
	}
	
	init() { }
	
	init(string: String) {
		let ls = string.split(separator: "|")
		if ls.count == 6 {
			self.name = String(ls[0])
			self.ip = String(ls[1])
			self.port = Int(String(ls[2])) ?? -1
			self.ipRD = String(ls[3])
			self.portRD = Int(String(ls[4])) ?? -1
			self.MAC = String(ls[5])
		}
	}
	
	init(name: String, MAC: String, ip: String, port: Int, ipRD: String, portRD: Int) {
		self.name = name
		self.MAC = MAC
		self.ip = ip
		self.port = port
		self.ipRD = ipRD
		self.portRD = portRD
	}
	
	func createMagicPacket() -> [CUnsignedChar] {
		let mac = self.MAC
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
	
	static func urlToIP_getHostByName(_ url: URL) -> [String] {
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
	
	static func isPortOpen(host: String, port: Int) -> Bool {
		var ip = host
		if !ip.hasPrefix("http://") || !ip.hasPrefix("https://") {
			ip = "http://\(ip)"
		}
		
		if let url = URL(string: ip) {
			if let i = PC.urlToIP_getHostByName(url).first {
				ip = i
			}
		}
		
		let port = UInt16(port)

		let sizeOfSockkAddr = MemoryLayout<sockaddr_in>.size
		var addr = sockaddr_in()
		addr.sin_len = __uint8_t(sizeOfSockkAddr)
		addr.sin_family = sa_family_t(AF_INET)
		addr.sin_port = Int(OSHostByteOrder()) == OSLittleEndian ? _OSSwapInt16(port) : port
		addr.sin_addr = in_addr(s_addr: inet_addr(ip))
		addr.sin_zero = (0, 0, 0, 0, 0, 0, 0, 0)
		
		var bind_addr = sockaddr()
		memcpy(&bind_addr, &addr, Int(sizeOfSockkAddr))
		
		// Setup the packet socket
		let sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
		if sock < 0 {
			return false
		}
		
		let intLen = socklen_t(MemoryLayout<Int>.stride)
		
		var timer = timeval()
		// Set socket options
		if setsockopt(sock, SOL_SOCKET, SO_BROADCAST, &timer, intLen) == -1 {
			close(sock)
		}
		
		let i = connect(sock, &bind_addr, socklen_t(sizeOfSockkAddr))
		close(sock)
		return i == 0
	}
}

