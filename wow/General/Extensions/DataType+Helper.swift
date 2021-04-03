//
//  DataType+Utils.swift
//
//
//  Created by Tung Xuan on 7/9/20.
//  Copyright © 2020 Tung Xuan. All rights reserved.
//

import Foundation

// MARK: String Random Sub String
extension String {
	static func randomString(length: Int) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,/;'\"\\:[]{}<>?~`!@#$%^&*()_+-=| "
		return String((0..<length).map{ _ in letters.randomElement()! })
	}
	
	static func randomAlphaNumbericString(length: Int) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
		return String((0..<length).map{ _ in letters.randomElement()! })
	}
	
	func index(from: Int) -> Index {
		return self.index(startIndex, offsetBy: from)
	}
	
	func substring(from: Int) -> String {
		let fromIndex = index(from: from)
		return String(self[fromIndex...])
	}
	
	func substring(to: Int) -> String {
		let toIndex = index(from: to)
		return String(self[..<toIndex])
	}
	
	func substring(with r: Range<Int>) -> String {
		let startIndex = index(from: r.lowerBound)
		let endIndex = index(from: r.upperBound)
		return String(self[startIndex..<endIndex])
	}
	func split(by length: Int) -> [String] {
		var startIndex = self.startIndex
		var results = [Substring]()

		while startIndex < self.endIndex {
			let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
			results.append(self[startIndex..<endIndex])
			startIndex = endIndex
		}

		return results.map { String($0) }
	}
}

// MARK: String is Email
extension String {
	
	func isEmail() -> Bool {
		let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
			"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
			"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
			"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
			"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
			"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
		"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
		
		let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
		return emailTest.evaluate(with: self)
	}
	
	public func isPhone()->Bool {
		if self.isAllDigits() == true {
			let phoneRegex = "^((\\+))[0-9]{10,11}|[0-9]{10,11}$"
			let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
			return  predicate.evaluate(with: self)
		}else {
			return false
		}
	}
	
	private func isAllDigits()->Bool {
		let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
		let inputString = self.components(separatedBy: charcterSet)
		let filtered = inputString.joined(separator: "")
		return  self == filtered
	}
	
	func isUsername() -> Bool {
		let regEx = "[a-zA-Z0-9]{6,18}"
		
		let usernameTest = NSPredicate(format:"SELF MATCHES[c] %@", regEx)
		return usernameTest.evaluate(with: self)
	}
	
	func isPassword() -> Bool {
		let regEx = ".{6,18}"
		
		let usernameTest = NSPredicate(format:"SELF MATCHES[c] %@", regEx)
		return usernameTest.evaluate(with: self)
	}
	
	func isBirthdayYear() -> Bool {
		guard let year = Int(self) else { return false }
		guard let currentYear = Calendar.current.dateComponents([.year], from: Date()).year else { return false }
		if year > currentYear - 15 || year < currentYear - 100 {
			return false
		}
		return true
	}
}

// MARK: - Localized
extension String {
	/// Get localized string
	/// - Returns: String
	func localized() -> String {
		NSLocalizedString(self, comment: "")
	}
	
	func enLocalized() -> String {
		let language = "en"
		let path = Bundle.main.path(forResource: language, ofType: "lproj")!
		let bundle = Bundle(path: path)!
		let localizedString = NSLocalizedString(self, bundle: bundle, comment: "")
		return localizedString
	}
}

// MARK: String base 64
extension String {
	func base64Encoded() -> String? {
		return data(using: .utf8)?.base64EncodedString()
	}

	func base64Decoded() -> String? {
		guard let data = Data(base64Encoded: self) else { return nil }
		return String(data: data, encoding: .utf8)
	}
}

// MARK: URL Parse
extension URL {
	func params() -> [String:String] {
		var dict = [String: String]()
		
		if let components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
			if let queryItems = components.queryItems {
				for item in queryItems {
					if let value = item.value {
						dict[item.name] = value
					}
				}
			}
			return dict
		} else {
			return [:]
		}
	}
}

// MARK: Dictionary Json
extension Dictionary where Key == String, Value == Any {
	func jsonString() -> String {
		do {
			let dataParams = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
			if let jsonString = String(data: dataParams, encoding: .utf8) {
				return jsonString
			}
		} catch {
			
		}
		return ""
	}
}

// MARK: Array Random
extension Array {
	/// Returns an array containing this sequence shuffled
	var shuffled: Array {
		var elements = self
		return elements.shuffle()
	}
	/// Shuffles this sequence in place
	@discardableResult
	mutating func shuffle() -> Array {
		let count = self.count
		indices.lazy.dropLast().forEach {
			swapAt($0, Int(arc4random_uniform(UInt32(count - $0))) + $0)
		}
		return self
	}
	var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
	func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}

extension Double {
	/// Rounds the double to decimal places value
	func rounded(toPlaces places:Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return (self * divisor).rounded() / divisor
	}
}

extension Data {
	func hexEncodedString() -> String {
		return map { String(format: "%02hhx", $0) }.joined()
	}
}

extension UserDefaults {
	
	public struct Key {
		fileprivate let name: String
		public init(_ name: String) {
			self.name = name
		}
	}
	
	public func getValue(for key: Key) -> Any? {
		return object(forKey: key.name)
	}
	
	public func setValue(_ value: Any?, for key: Key) {
		set(value, forKey: key.name)
	}
	
	public func removeValue(for key: Key) {
		removeObject(forKey: key.name)
	}
	
}

