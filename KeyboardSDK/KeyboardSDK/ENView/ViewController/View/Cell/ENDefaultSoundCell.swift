//
//  ENDefaultSoundCell.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/30.
//

import Foundation

/// 기본 설정에서 사용 할 사운드 설정 셀
class ENDefaultSoundCell: UITableViewCell {
    static let ID = "ENDefaultSoundCell"
    
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var imgSub: UIImageView!
    
    static func create() -> ENDefaultSoundCell {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENDefaultSoundCell", owner: self, options: nil)
        let tempView = nibViews?.first as! ENDefaultSoundCell
        
        return tempView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        self.selectionStyle = .none
    }
}
