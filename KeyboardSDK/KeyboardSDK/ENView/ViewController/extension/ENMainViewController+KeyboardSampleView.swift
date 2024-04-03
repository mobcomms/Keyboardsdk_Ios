//
//  ENMainViewController+KeyboardSampleView.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/11.
//

import Foundation
import KeyboardSDKCore

/// 메인 화면의 키보드 샘플 뷰 함수 모음
extension ENMainViewController {
    /// 키보드 프리뷰의 init 부분
    func initKeyboardView() {
        keyboardViewManager = ENKeyboardViewManager(proxy: nil, needsInputModeSwitchKey: true)
        let keyboard = keyboardViewManager?.loadKeyboardView()
        
        self.keyboardSampleView.addSubview(keyboard ?? UIView())
        
        keyboardViewManager?.isUseNotifyView = false

        keyboardViewManager?.updateConstraints()
        keyboardViewManager?.updateKeys()
        customAreaView = ENKeyboardCustomAreaView(frame: .zero)
        
        customAreaView!.removeAdViewAndDutchPayView()
        
        customAreaView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customAreaView!.isUserInteractionEnabled = true

        keyboardViewManager?.initCustomArea(with: customAreaView!)
        customAreaView!.sizeToFit()

        customAreaView!.setButtonHandler(item: customAreaView!.btnArray)
        customAreaView!.setScrollViewConstraint()
        
        ENSettingManager.shared.isUsePhotoTheme = false
        let currentTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        let themeFileInfo = currentTheme.themeFileInfo()

        customAreaView!.keyboardThemeModel = currentTheme
        customAreaView!.updateUI()

        ENKeyboardThemeManager.shared.loadTheme(theme: themeFileInfo) { [weak self] theme in
            guard let self else { return }
            self.keyboardViewManager?.keyboardTheme = theme
            self.customAreaView!.keyboardTheme = theme
            self.customAreaView!.updateUI()
        }
        
        self.keyboardSampleViewHeightConstraint.constant = 0
        self.keyboardSampleView.isHidden = true
        
        self.viewThemeApply.isHidden = true
        self.viewThemeStackViewHeightConstraint.constant = 0
    }
    
    /// 테마에서 키보드 프리뷰를 보여줄 때 사용
    func showKeyboardPreview(theme: ENKeyboardThemeModel?) {
        ENSettingManager.shared.isUsePhotoTheme = false
        let currentTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        let themeFileInfo = theme?.themeFileInfo() ?? currentTheme.themeFileInfo()
        
        ENKeyboardThemeManager.shared.loadTheme(theme: themeFileInfo) { [weak self] theme in
            guard let self = self else { return }
            self.keyboardViewManager?.keyboardTheme = theme
            self.customAreaView!.keyboardTheme = theme
            self.customAreaView!.updateUI()
            
            let needHeight = (self.keyboardViewManager?.heightConstraint?.constant ?? 0.0)
            self.keyboardSampleViewHeightConstraint.constant = needHeight
        }
        
        self.keyboardSampleView.isHidden = false
        
        self.viewThemeStackViewHeightConstraint.constant = 52
        self.viewThemeApply.isHidden = false
    }
    
    /// 키보드 높이 또는 키보드 타입 등의 프리뷰를 보여줄 때 사용
    func showDefaultKeyboardPreview() {
        ENSettingManager.shared.isUsePhotoTheme = false
        let currentTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        let themeFileInfo = currentTheme.themeFileInfo()

//        customAreaView?.keyboardThemeModel = currentTheme

        ENKeyboardThemeManager.shared.loadTheme(theme: themeFileInfo) { [weak self] theme in
            guard let self = self else { return }
            self.keyboardViewManager?.keyboardTheme = theme
            self.customAreaView!.keyboardTheme = theme
            self.customAreaView!.updateUI()
        }
        
        let needHeight = (self.keyboardViewManager?.heightConstraint?.constant ?? 0.0)
        self.keyboardSampleViewHeightConstraint.constant = needHeight
        
        self.keyboardSampleView.isHidden = false
        
        self.viewThemeStackViewHeightConstraint.constant = 0
        self.viewThemeApply.isHidden = true
    }
    
    /// 테마 등 키보드 !!프리뷰!! 에서 숨길 때 사용
    func hideKeyboardPreview() {
        self.keyboardSampleView.isHidden = true
        self.keyboardSampleViewHeightConstraint.constant = 0
        
        self.viewThemeStackViewHeightConstraint.constant = 0
        self.viewThemeApply.isHidden = true
    }
}
