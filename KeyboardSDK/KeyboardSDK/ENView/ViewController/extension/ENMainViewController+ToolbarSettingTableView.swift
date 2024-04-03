//
//  ENMainViewController+ToolbarSettingTableView.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/30.
//

import Foundation
import KeyboardSDKCore

extension ENMainViewController {
    /// 툴바 테이블의 기본 세팅
    func toolbarSettingTableSetting() {        
        toolbarSettingTable.dragInteractionEnabled = true
        toolbarSettingTable.dragDelegate = self
        toolbarSettingTable.dropDelegate = self
        
        toolbarSettingTable.translatesAutoresizingMaskIntoConstraints = false
        toolbarSettingTable.removeConstraint(toolbarSettingWidthConstraint)
        toolbarSettingTable.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        
        toolbarSettingTable.estimatedRowHeight = 76.0
        toolbarSettingTable.rowHeight = UITableView.automaticDimension
        
        toolbarSettingTable.register(UINib.init(nibName: "ENToolbarBackgroundCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENToolbarBackgroundCell.ID)
        toolbarSettingTable.register(UINib.init(nibName: "ENToolbarBackgroundSwitchCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENToolbarBackgroundSwitchCell.ID)
        toolbarSettingTable.register(UINib.init(nibName: "ENToolbarNormalCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENToolbarNormalCell.ID)
        
        toolbarSettingReloadData()
    }
    
    /// 툴바 테이블의 데이터 값 리로드
    func toolbarSettingReloadData(isToolbarReload: Bool = false) {
        if ENSettingManager.shared.toolbarStyle == .paging {
            scrollViewToolbar.isPagingEnabled = true
        } else {
            scrollViewToolbar.isPagingEnabled = false
        }
        
        toolbarSettingMenus = [
            [
                ENToolbarSettingModel.init(displayName: "툴바 타입", value: ENSettingManager.shared.toolbarStyle == .scroll ? "스크롤" : "페이징")
            ],
            ENSettingManager.shared.toolbarItems
        ]
        
        toolbarSettingTable.reloadData()
        
        if isToolbarReload {
            toolbarReload()
        }
    }
    
    /// 툴바 아이템의 빈 공간 세팅
    func emptyToolbarItemSetting(remainCount: Int, itemWidth: CGFloat) {
        for _ in 0..<remainCount {
            let imgView = UIImageView(image: UIImage.init(named: "cell_toolbar_empty", in: Bundle.frameworkBundle, compatibleWith: nil))
            imgView.translatesAutoresizingMaskIntoConstraints = false
            imgView.backgroundColor = .clear
            
            imgView.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
            imgView.clipsToBounds = true
            
            stackViewToolbar.addArrangedSubview(imgView)
        }
    }
    
    /// 툴바 리로드
    func toolbarReload() {
        let itemArray = ENSettingManager.shared.toolbarItems
        
        for innerView in stackViewToolbar.subviews {
            innerView.removeFromSuperview()
        }
        
        let scrollWidth = UIScreen.main.bounds.width - 32 - 32
        let itemPerPage = 7
        
        let itemWidth = 26.0
        var countShowToolbarItem = 0
        for item in itemArray {
            if item.isUse {
                countShowToolbarItem += 1
            }
        }
        
        let totalItemWidth = itemWidth * CGFloat(itemPerPage)
        let totalSpacing = scrollWidth - totalItemWidth
        let spacing = totalSpacing / CGFloat(itemPerPage - 1) - 2
        
        stackViewToolbar.spacing = spacing
        
        for item in itemArray {
            if item.isUse {
                let imgView = UIImageView(image: UIImage.init(named: item.imgName, in: Bundle.frameworkBundle, compatibleWith: nil))
                imgView.translatesAutoresizingMaskIntoConstraints = false
                imgView.backgroundColor = .clear
                
                imgView.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
                imgView.clipsToBounds = true
                
                stackViewToolbar.addArrangedSubview(imgView)
            }
        }
        
        let toolbarStyle = ENSettingManager.shared.toolbarStyle
        
        if toolbarStyle == .paging {
            pageControlToolbar.isHidden = false
            if countShowToolbarItem <= 6 {
                let totalItemCount = 7
                let remainCount = totalItemCount - countShowToolbarItem
                emptyToolbarItemSetting(remainCount: remainCount, itemWidth: itemWidth)
                pageControlToolbar.numberOfPages = 1
                pageControlToolbar.currentPage = 0
                
                scrollViewToolbar.contentSize = CGSize(width: scrollWidth, height: scrollViewToolbar.frame.height)
            } else if countShowToolbarItem >= 8 {
                let totalItemCount = 14
                let remainCount = totalItemCount - countShowToolbarItem
                emptyToolbarItemSetting(remainCount: remainCount, itemWidth: itemWidth)
                pageControlToolbar.numberOfPages = 2
                pageControlToolbar.currentPage = 0
                
                scrollViewToolbar.contentSize = CGSize(width: scrollWidth * 2, height: scrollViewToolbar.frame.height)
            } else {
                pageControlToolbar.numberOfPages = 1
                pageControlToolbar.currentPage = 0
            }
        } else {
            pageControlToolbar.isHidden = true
        }
    }
}
