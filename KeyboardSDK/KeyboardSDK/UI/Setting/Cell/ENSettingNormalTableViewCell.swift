//
//  ENSettingNormalTableViewCell.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/05/20.
//

import UIKit

class ENSettingNormalTableViewCell: UITableViewCell {
    
    static let ID:String = "ENSettingNormalTableViewCell"
    
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelDescript: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
}
