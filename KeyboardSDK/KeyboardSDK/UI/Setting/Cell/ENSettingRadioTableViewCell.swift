//
//  ENSettingRadioTableViewCell.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/05/31.
//

import UIKit

class ENSettingRadioTableViewCell: UITableViewCell {

    static let ID:String = "ENSettingRadioTableViewCell"
    
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var imageViewRadio: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateSelected(isSelected:Bool) {
        imageViewRadio.isHighlighted = isSelected
    }
}
