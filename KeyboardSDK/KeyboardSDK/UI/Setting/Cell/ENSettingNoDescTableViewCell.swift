//
//  ENSettingNoDescTableViewCell.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/16.
//

import Foundation

class ENSettingNoDescTableViewCell: UITableViewCell {
    static let ID:String = "ENSettingNoDescTableViewCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
