//
//  AboutViewController.swift
//  wow
//
//  Created by Tung Xuan on 2/25/21.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		self.setupUI()
	}

	init() {
		super.init(nibName: "AboutViewController", bundle: nil)
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
		
	}
	
	// MARK: - Button Event
	@IBAction func onClickButtonBack(_ sender: Any) {
		self.onBackViewController()
	}
	
	@IBAction func onClickButtonTutorial(_ sender: Any) {
		let tut = TutorialWOWViewController()
		self.present(tut, animated: true, completion: nil)
	}
}
