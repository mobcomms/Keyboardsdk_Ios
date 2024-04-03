//
//  ENDefaultSwitchCell.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/30.
//

import Foundation
import KeyboardSDKCore

/// 기본 설정 테이블에서 사용 할 스위치가 포함 된 셀
class ENDefaultSwitchCell: UITableViewCell {
    static let ID = "ENDefaultSwitchCell"
    
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switchComp: UISwitch!
    
    var indexPath:IndexPath?
    
    static func create() -> ENDefaultSwitchCell {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENDefaultSwitchCell", owner: self, options: nil)
        let tempView = nibViews?.first as! ENDefaultSwitchCell
        
        return tempView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
        self.selectionStyle = .none
    }
    
    @IBAction func changeSwitchValue(_ sender: UISwitch) {
        print(sender.isOn)
        ENSettingManager.shared.isKeyboardButtonValuePreviewShow = sender.isOn
    }
    
}
