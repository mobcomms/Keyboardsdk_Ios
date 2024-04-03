//
//  ENSortButtonView.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/22.
//

import Foundation
import UIKit

class ENSortButtonView:UIView {
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var normalButtonImage = UIImage.init(named: "aikbdIChkB", in: Bundle.frameworkBundle, compatibleWith: nil) {
        didSet {
            update()
        }
    }
    var selectButtonImage = UIImage.init(named: "aikbdIChkG", in: Bundle.frameworkBundle, compatibleWith: nil) {
        didSet {
            update()
        }
    }
    
    var isSelected:Bool = false {
        didSet {
            update()
        }
    }
    
    
    private func update() {
        if isSelected {
            iconImageView.image = normalButtonImage
            displayLabel.textColor = UIColor.sortButtonSelected
            displayLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .bold)
        }
        else {
            iconImageView.image = selectButtonImage
            displayLabel.textColor = UIColor.sortButtonNormal
            displayLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        }
    }
}
