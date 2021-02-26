//
//  ViewController.swift
//  wow
//
//  Created by Tung Xuan on 2/25/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
    }
    
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let home = HomeViewController()
		let nav = UINavigationController(rootViewController: home)
		nav.setNavigationBarHidden(true, animated: false)
		self.view.window?.setRootViewController(root: nav, animated: true)
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
