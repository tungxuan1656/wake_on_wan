//
//  CellPC.swift
//  wow
//
//  Created by Tung Xuan on 2/25/21.
//

import UIKit

protocol CellPCDelegate {
	func onEditPC(index: Int)
}

class CellPC: UITableViewCell {

	@IBOutlet weak var labelName: UILabel!
	@IBOutlet weak var labelMACAddress: UILabel!
	@IBOutlet weak var labelIPAddress: UILabel!
	@IBOutlet weak var labelPortAddress: UILabel!
	
	var indexPC = -1
	var delegate: CellPCDelegate? = nil
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	@IBAction func onClickButtonEdit(_ sender: Any) {
		if let d = self.delegate, self.indexPC >= 0 {
			d.onEditPC(index: self.indexPC)
		}
	}
}
