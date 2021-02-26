//
//  ListPCViewController.swift
//  wow
//
//  Created by Tung Xuan on 2/25/21.
//

import UIKit

class ListPCViewController: UIViewController {

	@IBOutlet weak var tableViewListPC: UITableView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		self.setupUI()
	}

	init() {
		super.init(nibName: "ListPCViewController", bundle: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .EditedPC, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .AddNewPC, object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: .EditedPC, object: nil)
		NotificationCenter.default.removeObserver(self, name: .AddNewPC, object: nil)
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
		self.tableViewListPC.delegate = self
		self.tableViewListPC.dataSource = self
		self.tableViewListPC.register(UINib(nibName: "CellPC", bundle: nil), forCellReuseIdentifier: "CellPC")
		self.tableViewListPC.tableFooterView = UIView()
	}
	
	@objc func updateUI() {
		self.tableViewListPC.reloadData()
	}
	
	// MARK: - Button Event
	@IBAction func onClickButtonBack(_ sender: Any) {
		self.onBackViewController()
	}
	
	@IBAction func onClickButtonAddPC(_ sender: Any) {
		let register = RegisterPCViewController()
		self.navigationController?.pushViewController(register, animated: true)
	}
	
}

extension ListPCViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Global.arrPCs.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CellPC", for: indexPath) as! CellPC
		let pc = Global.arrPCs[indexPath.row]
		
		cell.labelName.text = pc.name
		cell.labelIPAddress.text = pc.ip
		cell.labelMACAddress.text = pc.MAC
		cell.labelPortAddress.text = pc.port.description
		cell.indexPC = indexPath.row
		cell.delegate = self
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		Global.selectedPC = Global.arrPCs[indexPath.row]
		NotificationCenter.default.post(name: .SelectedNewPC, object: Global.arrPCs[indexPath.row])
		self.onClickButtonBack(self)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			if Global.arrPCs[indexPath.row].name == Global.selectedPC?.name {
				Global.selectedPC = nil
				NotificationCenter.default.post(name: .RemoveSelectedPC, object: nil)
			}
			NotificationCenter.default.post(name: .RemovePC, object: Global.arrPCs[indexPath.row])
			Global.arrPCs.remove(at: indexPath.row)
			tableViewListPC.deleteRows(at: [indexPath], with: .fade)
		}

	}
}

extension ListPCViewController: CellPCDelegate {
	func onEditPC(index: Int) {
		let register = RegisterPCViewController()
		register.pc = Global.arrPCs[index]
		self.navigationController?.pushViewController(register, animated: true)
	}
}
