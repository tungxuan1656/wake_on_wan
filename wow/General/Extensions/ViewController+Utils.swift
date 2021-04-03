//
//  ViewController+Extensions.swift
//
//
//  Created by Tùng Xuân on 8/16/20.
//  Copyright © 2020 Tung Xuan. All rights reserved.
//

import Foundation
import UIKit

// MARK: ViewController Dialog
extension UIViewController {
    
    /// Hien thi dialog
    func showAlertDialog(title: String?, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
	func showAlertDialog(title: String?, message: String?, completion: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: {
            (_) in
				if let c = completion {
					c()
				}
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertDialog(title: String?, message: String?, negativeButton: String, didClickNegativeButton: @escaping () -> (), positiveButton: String, didClickPositiveButton: @escaping () -> ()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: negativeButton, style: .cancel, handler: {
            (action) in
                didClickNegativeButton()
            }))
			alert.addAction(UIAlertAction(title: positiveButton, style: .default, handler: {
			(action) in
				didClickPositiveButton()
			}))
            self.present(alert, animated: true, completion: nil)
        }
    }
	
	func showAlertDialog(title: String?, message: String?, positiveButton: String, didClickPositiveButton: @escaping () -> ()) {
		DispatchQueue.main.async {
			let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: positiveButton, style: .default, handler: {
			(action) in
				didClickPositiveButton()
			}))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func showAlertDialog(title: String?, message: String?, negativeButton: String, didClickNegativeButton: @escaping () -> ()) {
		DispatchQueue.main.async {
			let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: negativeButton, style: .cancel, handler: {
			(action) in
				didClickNegativeButton()
			}))
			self.present(alert, animated: true, completion: nil)
		}
	}
    
    func getPreviousNavVC() -> UIViewController? {
        if let navVC = self.navigationController {
            let count = navVC.viewControllers.count
            if count > 1 {
                return navVC.viewControllers[count - 2]
            }
        }
        return nil
    }
}

// MARK: - View Controller Back
extension UIViewController {
	func onBackViewController(animated: Bool = true) {
		if let nav = self.navigationController {
			nav.popViewController(animated: animated)
		}
		else {
			self.dismiss(animated: animated, completion: nil)
		}
	}
}


// MARK: UIViewController Toolbar Done
extension UIViewController {
    
    func addToolBarDoneButton(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 73/255, green: 145/255, blue: 233/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneToolbarHideKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        textField.inputAccessoryView = toolBar
    }
    
    func addToolBarDoneButton(textView: UITextView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 73/255, green: 145/255, blue: 233/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneToolbarHideKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        textView.inputAccessoryView = toolBar
    }
    
    @objc func doneToolbarHideKeyboard(){
        view.endEditing(true)
    }
}

// MARK: UIWindow Top Root
extension UIWindow {
    
    func topViewController() -> UIViewController {
        return self.topViewControllerWithRootViewController(rootVC: self.rootViewController!)
    }
    
    private func topViewControllerWithRootViewController(rootVC: UIViewController) -> UIViewController {
        if rootVC is UITabBarController {
            let tabBarController = rootVC as! UITabBarController
            return self.topViewControllerWithRootViewController(rootVC: tabBarController.selectedViewController!)
        } else if rootVC is UINavigationController {
            let navigationController = rootVC as! UINavigationController
            return self.topViewControllerWithRootViewController(rootVC: navigationController.visibleViewController!)
        } else if let vc = rootVC.presentedViewController {
            return self.topViewControllerWithRootViewController(rootVC: vc)
        } else {
            return rootVC
        }
    }
    
    /// Thay doi rootVC cua UIWindow
    func setRootViewController(root: UIViewController, animated: Bool) {
        var snapShotView: UIView?
        
        if animated {
            snapShotView = self.snapshotView(afterScreenUpdates: true)
            root.view.addSubview(snapShotView!)
        }
        self.rootViewController = root
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                snapShotView?.layer.opacity = 0
                snapShotView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }) { (finished) in
                snapShotView?.removeFromSuperview()
            }
        }
    }
}

// MARK: Keyboard Delegate
extension UIViewController {
    func initObserverKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowSelector(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideSelector(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    func removeObserverKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillHideSelector(notification: NSNotification?) {
        DispatchQueue.main.async {
            self.keyboardWillHide()
        }
    }
    
    @objc private func keyboardWillShowSelector(notification: NSNotification) {
        if let dictUserInfo: NSDictionary = notification.userInfo as NSDictionary? {
            if let value: NSValue = dictUserInfo.object(forKey: UIWindow.keyboardFrameEndUserInfoKey) as? NSValue {
                let rectKeyboard = value.cgRectValue
                let keyboardHeight = rectKeyboard.size.height
                DispatchQueue.main.async {
                    self.keyboardWillShow(height: keyboardHeight)
                }
            }
        }
    }
    
    @objc func keyboardWillHide() {}
    
    @objc func keyboardWillShow(height: CGFloat) {}
}
