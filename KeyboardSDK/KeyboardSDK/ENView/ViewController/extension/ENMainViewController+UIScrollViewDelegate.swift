//
//  ENMainViewController+ScrollViewCallBack.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/31.
//

import Foundation

/// 메인 스크롤 뷰의 콜백 함수 모음
extension ENMainViewController {
    /// 스크롤 이벤트가 동작 할 때
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scrollViewToolbar {
            pageControlToolbar.currentPage = Int(ceil(scrollView.contentOffset.x / scrollView.frame.width))
        }
    }
    
    /// 스크롤 이벤트가 시작 될 때
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { }
    
    /// 스크롤 이벤트가 끝났을 때
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            let x = scrollView.contentOffset.x
            let w = scrollView.bounds.size.width
            let currentPage = Int(ceil(x/w))
                    
            resetTapButton()
            
            switch currentPage {
            case 0:
                isShowingThemeView = false
                selectTabButton(targetButton: btnDefaultSetting)
                showAndHideTopToolbarView(flag: false)
                break
            case 1:
                isShowingThemeView = false
                selectTabButton(targetButton: btnToolbarSetting)
                showAndHideTopToolbarView(flag: true)
                break
            case 2:
                isShowingThemeView = true
                selectTabButton(targetButton: btnThemeSetting)
                showAndHideTopToolbarView(flag: false)
                break
            case 3:
                isShowingThemeView = false
                selectTabButton(targetButton: btnMoreSetting)
                showAndHideTopToolbarView(flag: false)
                break
            default:
                break
            }
        }
    }
}
