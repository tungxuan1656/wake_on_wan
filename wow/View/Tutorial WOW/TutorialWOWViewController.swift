//
//  TutorialWOWViewController.swift
//  wow
//
//  Created by Tung Xuan on 2/25/21.
//

import UIKit
import WebKit

class TutorialWOWViewController: UIViewController {

	@IBOutlet weak var webkitView: WKWebView!
	override func viewDidLoad() {
        super.viewDidLoad()

		self.setupUI()
	}

	init() {
		super.init(nibName: "TutorialWOWViewController", bundle: nil)
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
		let url = Bundle.main.url(forResource: "tutorial", withExtension: "html")!
		// self.webkitView.loadFileURL(url, allowingReadAccessTo: url)
		let request = URLRequest(url: url)
		self.webkitView.load(request)
	}
	
	// MARK: - Button Event
	@IBAction func onClickButtonBack(_ sender: Any) {
		self.onBackViewController()
	}
	
	
}
