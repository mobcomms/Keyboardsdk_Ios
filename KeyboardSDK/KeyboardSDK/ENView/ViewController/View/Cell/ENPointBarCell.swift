//
//  ENPointBarCell.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/18.
//

import Foundation
import KeyboardSDKCore

class ENPointBarCell: UITableViewCell {
    static let ID = "ENPointBarCell"
    
    static func create() -> ENPointBarCell {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENPointBarCell", owner: self, options: nil)
        let tempView = nibViews?.first as! ENPointBarCell
        
        return tempView
    }
    
    @IBOutlet weak var lblCellTitle: UILabel!
    @IBOutlet weak var lblCellPoint: UILabel!
    @IBOutlet weak var lblSubPoint: UILabel!
    @IBOutlet weak var pointBar: UIProgressView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
