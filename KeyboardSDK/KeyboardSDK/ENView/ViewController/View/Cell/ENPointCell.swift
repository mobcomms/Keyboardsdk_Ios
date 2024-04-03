//
//  ENPointCell.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/18.
//

import Foundation

class ENPointCell: UITableViewCell {
    static let ID = "ENPointCell"
    
    static func create() -> ENPointCell {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENPointCell", owner: self, options: nil)
        let tempView = nibViews?.first as! ENPointCell
        
        return tempView
    }
    
    @IBOutlet weak var lblCellTitle: UILabel!
    @IBOutlet weak var lblCellPoint: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
