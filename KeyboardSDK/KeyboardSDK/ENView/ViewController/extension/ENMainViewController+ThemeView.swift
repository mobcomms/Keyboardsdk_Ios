//
//  ENMainViewController+ThemeView.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/11.
//

import Foundation
import KeyboardSDKCore

/// 테마 뷰 함수 모음
extension ENMainViewController {
    /// 테마 뷰 기본 세팅
    func themeViewSettingUI() {
        themeViewWidthConstraint.constant = UIScreen.main.bounds.size.width
        
        initProgressView()
        initCollectionView()
        
        self.contentPresenter = ENThemeViewPresenter.init(collectionView: themeCollectionView)
        
        self.contentPresenter?.delegate = self
        self.contentPresenter?.contentDelegate = self
        self.contentPresenter?.loadData()
    }
    
    /// 테마 뷰 콜렉션 뷰 init
    func initCollectionView() {
        self.contentPresenter?.contentPresenter?.dataSource.removeAll()
        self.contentPresenter?.collectionView?.reloadData()
    }
    
    /// 테마뷰에 사용 될 프로그레스 뷰 Show 함수
    func showProgressView(with message:String) {
        progressViewMessageLable.text = message
        self.indicatorVeiw?.startAnimating()
        self.present(downloadProgressView, animated: true, completion: nil)
    }
    
    /// 테마뷰에 사용 될 프로그레스 뷰 Hide 함수
    func hideProgressView(completion: (() -> Void)? = nil) {
        self.downloadProgressView.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.indicatorVeiw?.stopAnimating()
            completion?()
        }
    }
    
    /// 테마뷰에 사용 될 프로그레스 뷰 세팅
    func initProgressView() {
        
        let root = UIView()
        root.backgroundColor = .clear
        
        progressViewMessageLable.text = "테마 미리보기 적용중"
        progressViewMessageLable.textColor = .white
        progressViewMessageLable.textAlignment = .center
        progressViewMessageLable.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        
        indicatorVeiw = ENActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 70, height: 70), type: .ballClipRotate, color: .white, padding: nil)
        
        root.addSubview(indicatorVeiw!)
        root.addSubview(progressViewMessageLable)
        
        
        root.translatesAutoresizingMaskIntoConstraints = false
        indicatorVeiw?.translatesAutoresizingMaskIntoConstraints = false
        progressViewMessageLable.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints:[NSLayoutConstraint] = []
        let views: [String: Any] = [
            "label": progressViewMessageLable,
            "indicatorVeiw": indicatorVeiw!,
            "root": root,
            "parent": downloadProgressView.view as Any
        ]
        
        downloadProgressView.view.addSubview(root)
        downloadProgressView.view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.3)
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[indicatorVeiw]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[indicatorVeiw(70)]-5-[label]|", metrics: nil, views: views)
        layoutConstraints += [
            NSLayoutConstraint.init(item: root, attribute: .centerX, relatedBy: .equal, toItem: downloadProgressView.view, attribute: .centerX, multiplier: 1.0, constant: 1.0),
            NSLayoutConstraint.init(item: root, attribute: .centerY, relatedBy: .equal, toItem: downloadProgressView.view, attribute: .centerY, multiplier: 1.0, constant: 1.0)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
        
        downloadProgressView.modalPresentationStyle = .overFullScreen
        downloadProgressView.modalTransitionStyle = .crossDissolve
    }
}

/// 콜렉션 뷰의 화면 Delegate
extension ENMainViewController: ENCollectionViewPresenterDelegate {
    /// 콜렉션 뷰에서 로딩이 필요할 때 호출
    func collectionViewPresenter(_ presenter: ENCollectionViewPresenter, showProgress message: String) {
        showProgressView(with: message)
    }
    /// 콜렉션 뷰에서 로딩이 끝났을 때 호출
    func collectionViewPresenter(_ presenter: ENCollectionViewPresenter, hideProgress completion: (() -> Void)?) {
        hideProgressView(completion: completion)
    }
    /// 콜렉션 뷰에서 에러 메세지를 보여줄 때 호출
    func collectionViewPresenter(_ presenter:ENCollectionViewPresenter, showErrorMessage message: String) {
        showErrorMessage(message: message)
    }
    /// 콜렉션 뷰에서 dialog 를 보여줄 때 호출
    func collectionViewPresenter(_ presenter: ENCollectionViewPresenter, showDialog dialog: UIViewController) {
        self.present(dialog, animated: true, completion: nil)
    }
    
    /// 키보드 프리뷰를 보여준다.
    ///  - Parameters:
    ///   - presenter: 현재 보여지는 콜렉션 뷰의 self
    /// - 선택한 테마를 적용하여 보여줌
    func showKeyboardPreview(_ presenter: ENCollectionViewPresenter) {
        var theme:ENKeyboardThemeModel? = nil
        if presenter is ENThemeRecommandPresenter {
            theme = (presenter as? ENThemeRecommandPresenter)?.selectedTheme
        }
        else if presenter is ENThemeCategoryPresenter {
            theme = (presenter as? ENThemeCategoryPresenter)?.selectedTheme
        }
        else if presenter is ENMyThemeContentViewPresenter {
            theme = (presenter as? ENMyThemeContentViewPresenter)?.selectedTheme
        }
        
        if let _ = theme {
            UIView.transition(with: self.btnKeyboard, duration: 0.2, options: .transitionFlipFromBottom , animations: { [weak self] in
                guard let self else { return }
                self.btnKeyboard.setImage(UIImage.init(named: "header_keyboard_down", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
            })
            showKeyboardPreview(theme: theme!)
        }
        
    }
    
    /// 키보드 샘플 뷰 Hide
    func hideKeyboardPreview(_ presenter: ENCollectionViewPresenter) {
        hideKeyboardPreview()
    }
    
    /// 갤러리 열기
    func openGallery(_ presenter: ENCollectionViewPresenter) {
//        self.openPhotoGallery()
    }
    /// 사진 편집 화면으로 이동
    func editPhoto(_ presenter: ENCollectionViewPresenter, edit image: UIImage) {
//        let vc = ENPhotoThemeEditViewController.create()
//        vc.photoImage = image
//        vc.modalPresentationStyle = .overFullScreen
//
//        self.present(vc, animated: true, completion: nil)
    }
    /// 사진 편집 모드 설정
    func exitEditMode(_ presenter: ENCollectionViewPresenter, deletedCount: Int) {
//        tabPresenter?.isEditMode = false
//
//        if deletedCount > 0 {
//            self.collectionView.showEnToast(message: "\(deletedCount)개의 테마가 삭제 되었습니다", backgroundColor: UIColor.aikbdPointBlue)
//        }
    }
    
}
