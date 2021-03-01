//
//  Config.swift
//  wow
//
//  Created by Tung Xuan on 2/25/21.
//

import Foundation

class Global {
	
	static var shared = Global()
	
	static var selectedPC: PC? = nil
	static var arrPCs = [PC]()
	
	init() {
		NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .AddNewPC, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .RemovePC, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .SelectedNewPC, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .EditedPC, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .RemoveSelectedPC, object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	@objc func updateData() {
		Global.saveArrayPC()
	}
	
	static func saveArrayPC() {
		let a = Global.arrPCs.map { $0.toString() }
		let s = a.joined(separator: "!")
		
		UserDefaults.standard.setValue(s, for: .SaveArrayPC)
		
		if let name = Global.selectedPC?.name {
			UserDefaults.standard.setValue(name, for: .SaveNamePCSelected)
		}
	}
	
	static func loadArrayPC() {
		if let s = UserDefaults.standard.getValue(for: .SaveArrayPC) as? String {
			let spcs = s.split(separator: "!").map { String($0) }
			let pcs = spcs.map { PC(string: $0) }
			Global.arrPCs = pcs
		}
		
		if let name = UserDefaults.standard.getValue(for: .SaveNamePCSelected) as? String {
			for pc in Global.arrPCs {
				if pc.name == name {
					Global.selectedPC = pc
					break
				}
			}
		}
	}
}

extension UserDefaults.Key {
	
	static let SaveArrayPC = UserDefaults.Key("SaveArrayPC")
	static let SaveNamePCSelected = UserDefaults.Key("SaveNamePCSelected")
}

extension NSNotification.Name {
	static var EditedPC = NSNotification.Name.init("EditedPC")
	static var RemoveSelectedPC = NSNotification.Name.init("RemoveSelectedPC")
	static var RemovePC = NSNotification.Name.init("RemovePC")
	static var SelectedNewPC = NSNotification.Name.init("SelectedNewPC")
	static var AddNewPC = NSNotification.Name.init("AddNewPC")
}

