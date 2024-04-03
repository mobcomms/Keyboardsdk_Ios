//
//  ENMainViewController+DefaultSettingTableView.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/30.
//

import Foundation
import KeyboardSDKCore

extension ENMainViewController {
    /// 기본 설정 테이블의 기본 세팅
    func defaultSettingTableSetting() {
        defaultSettingTable.backgroundColor = .white
        
        defaultSettingTable.translatesAutoresizingMaskIntoConstraints = false
        defaultSettingTable.removeConstraint(defaultSettingWidthConstraint)
        defaultSettingTable.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        
        defaultSettingTable.estimatedRowHeight = 76.0
        defaultSettingTable.rowHeight = UITableView.automaticDimension
        
        
        defaultSettingTable.register(UINib.init(nibName: "ENDefaultBackgroundCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENDefaultBackgroundCell.ID)
        defaultSettingTable.register(UINib.init(nibName: "ENDefaultNormalCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENDefaultNormalCell.ID)
        defaultSettingTable.register(UINib.init(nibName: "ENDefaultSwitchCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENDefaultSwitchCell.ID)
        defaultSettingTable.register(UINib.init(nibName: "ENDefaultSoundCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENDefaultSoundCell.ID)
        
        defaultSettingReloadData()
    }
    
    /// 기본 설정 테이블의 데이터 값 리로드
    func defaultSettingReloadData() {
        defaultSettingMenus = [
            [
                ENDefaultSettingModel.init(displayName: "키보드 입력방식"),
                ENDefaultSettingModel.init(displayName: "키보드 높이"),
                ENDefaultSettingModel.init(displayName: "진동 세기")
            ],
            [
                ENDefaultSettingModel.init(displayName: "자주 쓰는 메모"),
                ENDefaultSettingModel.init(displayName: "나만의 이모티콘"),
            ],
            [
                ENDefaultSettingModel.init(displayName: "입력키 크게 보기", value: ENSettingManager.shared.isKeyboardButtonValuePreviewShow),
                ENDefaultSettingModel.init(displayName: "키보드 소리"),
            ]
        ]
        defaultSettingTable.reloadData()
    }
}
