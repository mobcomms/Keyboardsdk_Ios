//
//  ENPointDetailCell.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/18.
//

import Foundation
import KeyboardSDKCore

class ENPointDetailCell: UITableViewCell {
    static let ID = "ENPointDetailCell"
    
    static func create() -> ENPointDetailCell {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENPointDetailCell", owner: self, options: nil)
        let tempView = nibViews?.first as! ENPointDetailCell
        
        return tempView
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPoint: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
