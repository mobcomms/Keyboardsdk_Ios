//
//  ENSearchPhotoEmptyHeaderView.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/06.
//

import UIKit

class ENSearchPhotoEmptyHeaderView: UIView {
    
    static let needHeight:CGFloat = 100.0
    
    static func create() -> ENSearchPhotoEmptyHeaderView {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENSearchPhotoEmptyHeaderView", owner: self, options: nil)
        let tempView = nibViews?.first as! ENSearchPhotoEmptyHeaderView
        
        return tempView
    }
    
}
