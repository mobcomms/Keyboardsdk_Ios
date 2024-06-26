//
//  ENThemeCategoryCollectionViewCell.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/02.
//

import UIKit
import KeyboardSDKCore

class ENThemeCategoryCollectionViewCell: UICollectionViewCell {

    static let ID:String = "ENThemeCategoryCollectionViewCell"
    
    @IBOutlet weak var labelName: DHPaddedLabel!
    @IBOutlet weak var selecteIndicatorView: UIView!
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setSelectedCategory(isSelected:Bool) {
        labelName.textColor = isSelected ? UIColor.sortButtonSelected : UIColor.sortButtonNormal
        selecteIndicatorView.isHidden = !isSelected
    }
    
}
