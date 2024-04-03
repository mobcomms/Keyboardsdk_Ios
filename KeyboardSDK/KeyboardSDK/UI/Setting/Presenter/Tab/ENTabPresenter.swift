//
//  ENTabPresenter.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/18.
//

import Foundation
import UIKit

@objc enum ENThemeSelectedTab: Int {
    case unknown    = 0
    case category   = 1001
    case photo      = 1002
    case my         = 1003
}


typealias ENTabPresenterBinderCallback = (_ selectedTab:ENThemeSelectedTab) -> ()


class ENTabPresenter: NSObject {
    
    let tabs:[ENTabItems] = [
        ENTabItems.init(title: "테마",
                        icon: UIImage.init(named: "aikbdITheme", in: Bundle.frameworkBundle, compatibleWith: nil),
                        selectedIcon: UIImage.init(named: "aikbdIFTheme", in: Bundle.frameworkBundle, compatibleWith: nil)),
        ENTabItems.init(title: "포토테마",
                        icon: UIImage.init(named: "aikbdIPhototheme", in: Bundle.frameworkBundle, compatibleWith: nil),
                        selectedIcon: UIImage.init(named: "aikbdFPhotothemeIcon", in: Bundle.frameworkBundle, compatibleWith: nil)),
        ENTabItems.init(title: "MY테마",
                        icon: UIImage.init(named: "aikbdIMytheme", in: Bundle.frameworkBundle, compatibleWith: nil),
                        selectedIcon: UIImage.init(named: "aikbdIFMytheme", in: Bundle.frameworkBundle, compatibleWith: nil))
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
    
    var photoThemeButton:ENTabButtonView? {
        willSet {
            newValue?.tab = tabs[1]
            newValue?.tag = ENThemeSelectedTab.photo.rawValue
            newValue?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapGestureExcute(tap:))))
        }
    }
    
    
    var myThemeButton:ENTabButtonView? {
        willSet {
            newValue?.tab = tabs[2]
            newValue?.tag = ENThemeSelectedTab.my.rawValue
            newValue?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapGestureExcute(tap:))))
        }
    }
    
    @objc dynamic var selectedTab:ENThemeSelectedTab = .unknown {
        didSet {
            self.callback?(selectedTab)
            updateNavigationItemButton()
        }
    }
    
    var isEditMode:Bool = false {
        didSet {
            if selectedTab == .my {
                updateNavigationItemButton()
            }
        }
    }
    
    private var callback:ENTabPresenterBinderCallback? = nil
    
    
    
    override init() {
        super.init()
    }
    
    
    func selectTab(tab:ENTabButtonView) {
        categoryThemeButton?.isSelected = (tab == categoryThemeButton)
        photoThemeButton?.isSelected = (tab == photoThemeButton)
        myThemeButton?.isSelected = (tab == myThemeButton)
        
        self.selectedTab = ENThemeSelectedTab.init(rawValue: tab.tag) ?? .unknown
    }
    
    
    func bindTabChange(_ block: ENTabPresenterBinderCallback?) {
        self.callback = block
    }
    
    
    private func updateNavigationItemButton() {
        switch selectedTab {
        case .category, .photo:
            self.navigationTitleLabel?.text = "테마설정"
            self.navigationItemButton?.setImage(UIImage.init(named: "aikbdISearch", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
            
        case .my:
            if isEditMode {
                self.navigationTitleLabel?.text = "테마를 선택하세요"
                self.navigationItemButton?.setTitle("취소", for: .normal)
                self.navigationItemButton?.setImage(nil, for: .normal)
            }
            else {
                self.navigationTitleLabel?.text = "MY테마"
                self.navigationItemButton?.setTitle("", for: .normal)
                self.navigationItemButton?.setImage(UIImage.init(named: "aikbdIDelete", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
            }
            
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
