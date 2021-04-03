//
//  UIView+Extensions.swift
//
//
//  Created by Tùng Xuân on 8/16/20.
//  Copyright © 2020 Tung Xuan. All rights reserved.
//

import Foundation
import UIKit

// MARK: GradientView
@IBDesignable class GradientView: UIView {
	
	private var gradientLayer: CAGradientLayer!
	
	@IBInspectable var topColor: UIColor = .red {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var bottomColor: UIColor = .yellow {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var shadowColor: UIColor = .clear {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var shadowX: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var shadowY: CGFloat = -3 {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var shadowBlur: CGFloat = 3 {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var startPointX: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var startPointY: CGFloat = 0.5 {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var endPointX: CGFloat = 1 {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var endPointY: CGFloat = 0.5 {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var borderWidth: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var borderColor: UIColor = .clear {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	
	override class var layerClass: AnyClass {
		return CAGradientLayer.self
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.gradientLayer = self.layer as? CAGradientLayer
		self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
		self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
		self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
		self.layer.cornerRadius = cornerRadius
		self.layer.shadowColor = shadowColor.cgColor
		self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
		self.layer.shadowRadius = shadowBlur
		self.layer.shadowOpacity = 1
		self.layer.borderWidth = borderWidth
		self.layer.borderColor = borderColor.cgColor
		
	}
	
	func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
		let fromColors = self.gradientLayer?.colors
		let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
		self.gradientLayer?.colors = toColors
		let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
		animation.fromValue = fromColors
		animation.toValue = toColors
		animation.duration = duration
		animation.isRemovedOnCompletion = true
		animation.fillMode = .forwards
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		self.gradientLayer?.add(animation, forKey:"animateGradient")
	}
}

// MARK: Radian Gradient View
@IBDesignable class TXRadianGradientView: UIView {
	
	var radianLayer: CAGradientLayer!
	
	@IBInspectable var topColor: UIColor = .systemPink {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var centerColor: UIColor = .systemRed {
		didSet {
			setNeedsLayout()
		}
	}
	
	@IBInspectable var location: Float = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	
	override class var layerClass: AnyClass {
		return CAGradientLayer.self
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.radianLayer = self.layer as? CAGradientLayer
		radianLayer.type = .radial
		radianLayer.colors = [self.centerColor.withAlphaComponent(0), self.centerColor.withAlphaComponent(0), self.centerColor.cgColor, self.topColor.cgColor]
		let n = NSNumber.init(value: location)
		radianLayer.locations = [0, n, n, 1]
		radianLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
		radianLayer.endPoint = CGPoint(x: 1, y: 1)
		radianLayer.cornerRadius = bounds.width / 2.0
	}
}

// MARK: Custom View
@IBDesignable class TXCustomView: UIView {
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	@IBInspectable var borderColor: UIColor = .clear {
		didSet {
			setNeedsLayout()
		}
	}
	@IBInspectable var borderWidth: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	@IBInspectable var shadowColor: UIColor = .clear {
		didSet {
			setNeedsLayout()
		}
	}
	@IBInspectable var shadowX: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	@IBInspectable var shadowY: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	@IBInspectable var shadowBlur: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = cornerRadius
		self.layer.shadowColor = shadowColor.cgColor
		self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
		self.layer.shadowRadius = shadowBlur
		self.layer.shadowOpacity = 1
		self.layer.borderWidth = borderWidth
		self.layer.borderColor = borderColor.cgColor
	}
}

// MARK: Custom Corner View
@IBDesignable class TXCornerView: UIView {
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	@IBInspectable var topLeft: Bool = false {
		didSet {
			setNeedsLayout()
		}
	}
	@IBInspectable var topRight: Bool = false {
		didSet {
			setNeedsLayout()
		}
	}
	@IBInspectable var bottomRight: Bool = false {
		didSet {
			setNeedsLayout()
		}
	}
	@IBInspectable var bottomLeft: Bool = false {
		didSet {
			setNeedsLayout()
		}
	}
	override func layoutSubviews() {
		self.layer.cornerRadius = cornerRadius
		var corner: CACornerMask = []
		if topLeft { corner.insert(.layerMinXMinYCorner) }
		if topRight { corner.insert(.layerMaxXMinYCorner) }
		if bottomRight { corner.insert(.layerMaxXMaxYCorner) }
		if bottomLeft { corner.insert(.layerMinXMaxYCorner) }
		self.layer.maskedCorners = corner
	}
}

// MARK: Custom Button
@IBDesignable class TXCustomButton: UIButton {
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	@IBInspectable var borderColor: UIColor = .white {
		didSet {
			setNeedsLayout()
		}
	}
	@IBInspectable var borderWidth: CGFloat = 0 {
		didSet {
			setNeedsLayout()
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = cornerRadius
		self.layer.borderWidth = borderWidth
		self.layer.borderColor = borderColor.cgColor
	}
}

// MARK: Custom ProgressView
@IBDesignable class TXCustomProgressView: UIProgressView {
	override func layoutSubviews() {
		super.layoutSubviews()
		let maskLayerPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.height / 2)
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.bounds
		maskLayer.path = maskLayerPath.cgPath
		layer.mask = maskLayer
	}
}


// MARK: CALayer Shadow
extension CALayer {
	func applySketchShadow(
		color: UIColor = .black,
		alpha: Float = 0.2,
		x: CGFloat = 0,
		y: CGFloat = 10,
		blur: CGFloat = 15,
		spread: CGFloat = 0)
	{
		shadowColor = color.cgColor
		shadowOpacity = alpha
		shadowOffset = CGSize(width: x, height: y)
		shadowRadius = blur / 2.0
		if spread == 0 {
			shadowPath = nil
		} else {
			let dx = -spread
			let rect = bounds.insetBy(dx: dx, dy: dx)
			shadowPath = UIBezierPath(rect: rect).cgPath
		}
	}
	
	func applyCornerRadiusAndShadow(radius: CGFloat = 10,
									color: UIColor = .black,
									alpha: Float = 0.2,
									x: CGFloat = 0,
									y: CGFloat = 10,
									blur: CGFloat = 15,
									spread: CGFloat = 0) {
		cornerRadius = radius
		applySketchShadow(color: color, alpha: alpha, x: x, y: y, blur: blur, spread: spread)
	}
}

// MARK: UIView loadNib
extension UIView {
	func loadNib() -> UIView {
		let bundle = Bundle(for: type(of: self))
		let nibName = type(of: self).description().components(separatedBy: ".").last!
		let nib = UINib(nibName: nibName, bundle: bundle)
		return nib.instantiate(withOwner: self, options: nil).first as! UIView
	}
}

// MARK: UIColor
extension UIColor {
	convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
	}
	
	convenience init(rgb: Int) {
		self.init(
			red: (rgb >> 16) & 0xFF,
			green: (rgb >> 8) & 0xFF,
			blue: rgb & 0xFF
		)
	}
	
	convenience init(rgb: Int, a: CGFloat) {
		self.init(
			red: (rgb >> 16) & 0xFF,
			green: (rgb >> 8) & 0xFF,
			blue: rgb & 0xFF,
			alpha: a
		)
	}
}

extension UITextField {
	@IBInspectable var placeHolderColor: UIColor? {
		get {
			return self.placeHolderColor
		}
		set {
			self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
		}
	}
}


extension UITextView {
	static func adjustUITextViewHeight(textView : UITextView, width: CGFloat = 0) -> CGFloat {
		textView.isScrollEnabled = true
		textView.translatesAutoresizingMaskIntoConstraints = true
		var fixedWidth: CGFloat = 0
		if width != 0 {
			fixedWidth = width
		}
		else {
			fixedWidth = UIScreen.main.bounds.width - 40
		}
		let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
		var newFrame = textView.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		textView.frame = newFrame
		textView.isScrollEnabled = false
		return newSize.height
	}
}

// MARK: - UIButton
extension UIButton {
	override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		isHighlighted = true
		super.touchesBegan(touches, with: event)
	}

	override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		isHighlighted = false
		super.touchesEnded(touches, with: event)
	}

	override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		isHighlighted = false
		super.touchesCancelled(touches, with: event)
	}
}

// MARK: - UILabel
extension UILabel {
	var optimalHeight : CGFloat {
		get {
			let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
			label.numberOfLines = 0
			label.lineBreakMode = self.lineBreakMode
			label.font = self.font
			label.text = self.text
			label.sizeToFit()
			return label.frame.height
		}
	}
}

// MARK: - View Custom Border
enum ViewBorder: String {
	case left, right, top, bottom
}

extension UIView {
	func add(border: ViewBorder, color: UIColor, width: CGFloat) {
		let borderLayer = CALayer()
		borderLayer.backgroundColor = color.cgColor
		borderLayer.name = border.rawValue
		switch border {
		case .left:
			borderLayer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
		case .right:
			borderLayer.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
		case .top:
			borderLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
		case .bottom:
			borderLayer.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
		}
		self.layer.addSublayer(borderLayer)
	}
	
	func remove(border: ViewBorder) {
		guard let sublayers = self.layer.sublayers else { return }
		var layerForRemove: CALayer?
		for layer in sublayers {
			if layer.name == border.rawValue {
				layerForRemove = layer
			}
		}
		if let layer = layerForRemove {
			layer.removeFromSuperlayer()
		}
	}
}
