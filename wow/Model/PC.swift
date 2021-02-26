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
	var MAC: String = "FF:FF:FF:FF:FF:FF"
	
	func toString() -> String {
		return "\(name)|\(ip)|\(port)|\(MAC)"
	}
	
	init() { }
	
	init(string: String) {
		let ls = string.split(separator: "|")
		if ls.count == 4 {
			self.name = String(ls[0])
			self.ip = String(ls[1])
			self.MAC = String(ls[3])
			self.port = Int(String(ls[2])) ?? -1
		}
	}
	
	init(name: String, MAC: String, ip: String, port: Int) {
		self.name = name
		self.MAC = MAC
		self.ip = ip
		self.port = port
	}
}

