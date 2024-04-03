//
//  ENMyThemeEmptyView.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/15.
//

import UIKit

class ENMyThemeEmptyView: UIView {
    static let ID = "ENMyThemeEmptyView"
    
    static func create() -> ENMyThemeEmptyView {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENMyThemeEmptyView", owner: self, options: nil)
        let tempView = nibViews?.first as! ENMyThemeEmptyView
        
        return tempView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
