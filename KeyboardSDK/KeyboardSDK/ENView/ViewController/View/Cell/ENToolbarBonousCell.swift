//
//  ENToolbarBonousCell.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/30.
//

import Foundation

/// 툴바 테이블에서 사용 할 보너스 적립 셀
class ENToolbarBonousCell: UITableViewCell {
    static let ID = "ENToolbarBonousCell"

    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    static func create() -> ENToolbarBonousCell {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENToolbarBonousCell", owner: self, options: nil)
        let tempView = nibViews?.first as! ENToolbarBonousCell
        
        return tempView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        self.selectionStyle = .none
    }
}
