//
//  ENDefaultNormalCell.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/30.
//

import Foundation

/// 기본 설정에서 사용하는 백그라운드가 없는 셀
class ENDefaultNormalCell: UITableViewCell {
    static let ID = "ENDefaultNormalCell"
    
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    static func create() -> ENDefaultNormalCell {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENDefaultNormalCell", owner: self, options: nil)
        let tempView = nibViews?.first as! ENDefaultNormalCell
        
        return tempView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        self.selectionStyle = .none
    }
}
