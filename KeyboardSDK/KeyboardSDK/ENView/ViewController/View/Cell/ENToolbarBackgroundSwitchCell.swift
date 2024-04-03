//
//  ENToolbarBackgroundSwitchCell.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/30.
//

import Foundation

/// 툴바 테이블에서 사용 할 스위치가 포함 된 셀
class ENToolbarBackgroundSwitchCell: UITableViewCell {
    static let ID = "ENToolbarBackgroundSwitchCell"

    @IBOutlet weak var viewWrapper: UIView!
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switchComp: UISwitch!
    
    static func create() -> ENToolbarBackgroundSwitchCell {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENToolbarBackgroundSwitchCell", owner: self, options: nil)
        let tempView = nibViews?.first as! ENToolbarBackgroundSwitchCell
        
        return tempView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        viewWrapper.layer.cornerRadius = 16
        self.selectionStyle = .none
    }
}
