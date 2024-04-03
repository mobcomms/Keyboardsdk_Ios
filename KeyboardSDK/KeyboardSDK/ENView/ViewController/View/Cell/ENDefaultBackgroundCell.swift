//
//  ENBackgroundCell.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/29.
//

import Foundation

/// 기본 설정 테이블에서 백그라운드가 들어가 있는 셀
class ENDefaultBackgroundCell: UITableViewCell {
    static let ID = "ENDefaultBackgroundCell"
    
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var viewWrapper: UIView!
    
    static func create() -> ENDefaultBackgroundCell {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENDefaultBackgroundCell", owner: self, options: nil)
        let tempView = nibViews?.first as! ENDefaultBackgroundCell
        
        return tempView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        viewWrapper.layer.cornerRadius = 16
        self.selectionStyle = .none
    }
}
