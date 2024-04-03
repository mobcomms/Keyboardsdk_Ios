//
//  ENToolbarBackgroundCell.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/30.
//

import Foundation

/// 툴바 테이블에서 사용하는 백그라운드가 있는 셀
class ENToolbarBackgroundCell: UITableViewCell {
    static let ID = "ENToolbarBackgroundCell"

    @IBOutlet weak var viewWrapper: UIView!
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    static func create() -> ENToolbarBackgroundCell {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENToolbarBackgroundCell", owner: self, options: nil)
        let tempView = nibViews?.first as! ENToolbarBackgroundCell
        
        return tempView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        viewWrapper.layer.cornerRadius = 16
        self.selectionStyle = .none
    }
}
