//
//  ENToolbarNormalCell.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/30.
//

import Foundation

/// 툴바 테이블에서 사용 할 기본 적인 셀
class ENToolbarNormalCell: UITableViewCell {
    static let ID = "ENToolbarNormalCell"

    @IBOutlet weak var btnCheck: UIImageView!
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var btnDrag: UIButton!
    
    var isCheck: Bool = false
    
    static func create() -> ENToolbarNormalCell {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENToolbarNormalCell", owner: self, options: nil)
        let tempView = nibViews?.first as! ENToolbarNormalCell
        
        return tempView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        self.selectionStyle = .none
    }
}
