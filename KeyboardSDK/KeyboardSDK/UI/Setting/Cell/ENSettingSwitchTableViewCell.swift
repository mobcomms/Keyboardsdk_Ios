//
//  ENSettingSwitchTableViewCell.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/05/20.
//

import UIKit

protocol ENSettingSwitchTableViewCellDelegate {
    func switchValueChange(cell:ENSettingSwitchTableViewCell, isOn:Bool)
}


class ENSettingSwitchTableViewCell: UITableViewCell {

    
    static let ID:String = "ENSettingSwitchTableViewCell"
    
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var buttonSwitch: UISwitch!
    
    var indexPath:IndexPath?
    var delegate:ENSettingSwitchTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    @IBAction func switchValueChange(_ sender: Any) {
        delegate?.switchValueChange(cell: self, isOn: buttonSwitch.isOn)
    }
}
