//
//  ENMemoDetailCell.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/06.
//

import Foundation

/// 자주쓰는 메모에서 사용 할 셀
class ENMemoDetailCell: UITableViewCell {
    static let ID = "ENMemoDetailCell"
    
    static func create() -> ENMemoDetailCell {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENMemoDetailCell", owner: self, options: nil)
        let tempView = nibViews?.first as! ENMemoDetailCell
        
        return tempView
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewWrapper: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewWrapper.layer.cornerRadius = 10
    }
}
