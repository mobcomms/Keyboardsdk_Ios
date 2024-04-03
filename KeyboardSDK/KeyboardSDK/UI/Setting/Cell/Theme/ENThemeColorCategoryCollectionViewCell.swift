//
//  ENThemeColorCategoryCollectionViewCell.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/22.
//

import UIKit

class ENThemeColorCategoryCollectionViewCell: UICollectionViewCell {
    
    static let ID:String = "ENThemeColorCategoryCollectionViewCell"
    static let needSize:CGSize = CGSize.init(width: 23, height: 23)

    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var selectedView: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = 11.0
        colorView.layer.masksToBounds = true
        colorView.layer.borderColor = UIColor.init(r: 233, g: 233, b: 233).cgColor
        
        selectedView.layer.cornerRadius = 11.5
        selectedView.layer.masksToBounds = true
    }
    
    func setSelectedCategory(isSelected:Bool) {
        selectedView.isHidden = !isSelected
    }
}
