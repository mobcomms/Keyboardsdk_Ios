//
//  ENTabButtonView.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/21.
//

import UIKit



struct ENTabItems {
    var title:String
    var icon:UIImage?
    var selectedIcon:UIImage?
}

class ENTabButtonView:UIView {
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    var isSelected:Bool = false {
        didSet {
            update()
        }
    }
    
    var tab:ENTabItems? {
        didSet {
            update()
        }
    }
    
    private func update() {
        displayLabel.text = tab?.title
        
        if isSelected {
            iconImageView.image = tab?.selectedIcon
            displayLabel.textColor = UIColor.tabTitleSelected
        }
        else {
            iconImageView.image = tab?.icon
            displayLabel.textColor = UIColor.tabTitleNormal
        }
    }
}
