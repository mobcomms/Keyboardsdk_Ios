//
//  ENTabPresenter.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/06/18.
//

import Foundation
import UIKit

@objc enum ENThemeSelectedTab: Int {
    case unknown    = 0
    case category   = 1001
}


typealias ENTabPresenterBinderCallback = (_ selectedTab:ENThemeSelectedTab) -> ()


class ENTabPresenter: NSObject {
    
    let tabs:[ENTabItems] = [
        ENTabItems.init(title: "테마",
                        icon: UIImage.init(named: "aikbdITheme", in: Bundle.frameworkBundle, compatibleWith: nil),
                        selectedIcon: UIImage.init(named: "aikbdIFTheme", in: Bundle.frameworkBundle, compatibleWith: nil)),
       
    ]
        
    var navigationTitleLabel:UILabel?
    var navigationItemButton:UIButton?
    
    var categoryThemeButton:ENTabButtonView? {
        willSet {
            newValue?.tab = tabs[0]
            newValue?.tag = ENThemeSelectedTab.category.rawValue
            newValue?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapGestureExcute(tap:))))
        }
    }
    
    
    @objc dynamic var selectedTab:ENThemeSelectedTab = .unknown {
        didSet {
            self.callback?(selectedTab)
            updateNavigationItemButton()
        }
    }
    
    var isEditMode:Bool = false 
    
    private var callback:ENTabPresenterBinderCallback? = nil    
    
    override init() {
        super.init()
    }
    
    
    func selectTab(tab:ENTabButtonView) {
        categoryThemeButton?.isSelected = (tab == categoryThemeButton)
        
        self.selectedTab = ENThemeSelectedTab.init(rawValue: tab.tag) ?? .unknown
    }
    
    
    func bindTabChange(_ block: ENTabPresenterBinderCallback?) {
        self.callback = block
    }
    
    
    private func updateNavigationItemButton() {
        switch selectedTab {
        case .category:
            self.navigationTitleLabel?.text = "테마설정"
            self.navigationItemButton?.setImage(UIImage.init(named: "aikbdISearch", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
            
      
            
        default:
            break
        }
    }
}



//MARK:- Actions
extension ENTabPresenter {
    
    @objc func tapGestureExcute(tap:UITapGestureRecognizer) {
        if let tabButton = (tap.view as? ENTabButtonView) {
            selectTab(tab: tabButton)
        }
    }
}
