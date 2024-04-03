//
//  ENNewThemeManagerViewController.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/18.
//

import UIKit
import KeyboardSDKCore


class ENNewThemeManagerViewController: UIViewController, ENViewPrsenter, ENTabContentPresenterDelegate {
    
    @IBOutlet weak var displayTitleLabel: UILabel!
    @IBOutlet weak var subActionButton: UIButton!           //검색 또는 삭제 동작
    @IBOutlet weak var subActionButtonWidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var themeTab: ENTabButtonView!
    @IBOutlet weak var photoThemeTab: ENTabButtonView!
    @IBOutlet weak var myThemeTab: ENTabButtonView!
    
    
    @IBOutlet weak var keyboardSampleView: UIView!
    @IBOutlet weak var keyboardSampleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tabViewBottomMargin: NSLayoutConstraint!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewShadowView: UIView!
    
    
    @IBOutlet weak var topButtonView: UIView!
    @IBOutlet weak var topButtonShadowView: UIView!
    
    @IBOutlet weak var tabShadowView: UIView!
    
    @IBOutlet weak var miniSayImageView: UIImageView!
    
    
    @IBOutlet weak var bottomAddedView: UIView!
    @IBOutlet weak var bottomAddViewHeight: NSLayoutConstraint!
    
    
    
    
    var downloadProgressView: UIViewController = UIViewController.init()
    var progressViewMessageLable:UILabel = UILabel()
    var indicatorVeiw: ENActivityIndicatorView? = nil
    
    var keyboardViewManager:ENKeyboardViewManager = ENKeyboardViewManager.init(proxy: nil, needsInputModeSwitchKey: true)
    
    
    var tabPresenter:ENTabPresenter?
    var contentPresneter: ENTabContentPresenter?
    
    var isUsePhotoThemeForRestore:Bool = false
    
    public static func create() -> ENNewThemeManagerViewController {
        let vc = ENNewThemeManagerViewController.init(nibName: "ENNewThemeManagerViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initKeyboardView()
        initProgressView()
        
        tabPresenter = ENTabPresenter.init()
        tabPresenter?.categoryThemeButton = themeTab
        tabPresenter?.photoThemeButton = photoThemeTab
        tabPresenter?.myThemeButton = myThemeTab
        tabPresenter?.navigationTitleLabel = displayTitleLabel
        tabPresenter?.navigationItemButton = subActionButton
        tabPresenter?.navigationItemButtonWidth = subActionButtonWidth
        
        tabPresenter?.bindTabChange({ tab in
            self.tabChanged(tab)
        })
        tabPresenter?.selectTab(tab: themeTab)
        
        
        topButtonView.layer.applyRounding(cornerRadius: 22.5, borderColor: UIColor.topButtonBorder, borderWidth: 1.7, masksToBounds: true)
        topButtonShadowView.layer.applySketchShadow(color: .black, alpha: 0.15, x: 0, y: 1, blur: 2.7, spread: 0)
        
        collectionViewShadowView.layer.applySketchShadow(color: .black, alpha: 0.15, x: 1.3, y: 0, blur: 5.0, spread: 0)
        
        topButtonShadowView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTopButtonTapped(gesture:))))
        
        isUsePhotoThemeForRestore = ENSettingManager.shared.isUsePhotoTheme
        
        bottomAddViewHeight.constant = 0.0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    func tabChanged(_ tab: ENThemeSelectedTab) {
        
        if (self.contentPresneter is ENMyThemeViewPresenter), let presenter = (contentPresneter?.contentPresenter as? ENMyThemeContentViewPresenter) {
            presenter.removeAddedItems()
        }
        
        switch tab {
        case .category:
            if self.contentPresneter is ENThemeViewPresenter {
                self.contentPresneter?.reset()
                return
            }
            else {
                self.tabPresenter?.isEditMode = false
                initColloctionView()
                showMiniSayBannerView()
                self.contentPresneter = ENThemeViewPresenter.init(collectionView: collectionView)
            }
            
            break
        
        case .photo:
            if self.contentPresneter is ENPhotoThemeViewPresenter {
                self.contentPresneter?.reset()
                return
            }
            else {
                self.tabPresenter?.isEditMode = false
                initColloctionView()
                showMiniSayBannerView()
                self.contentPresneter = ENPhotoThemeViewPresenter.init(collectionView: collectionView)
            }
            
            break
        
        case .my:
            if self.contentPresneter is ENMyThemeViewPresenter {
                self.contentPresneter?.reset()
                return
            }
            else {
                initColloctionView()
                self.tabPresenter?.isEditMode = false
                
                hideMiniSayBannerView(isNaver: false)
                self.contentPresneter = ENMyThemeViewPresenter.init(collectionView: collectionView, superView: bottomAddedView, bottomViewHeight: bottomAddViewHeight)
            }
            break
        
        default:
            return
        }
        
        self.contentPresneter?.delegate = self
        self.contentPresneter?.contentDelegate = self
        self.contentPresneter?.loadData()
        
        self.contentPresneter?.topButton = topButtonShadowView
        topButtonShadowView.isHidden = true
    }
    
    
    func initColloctionView() {
        if self.contentPresneter is ENThemeViewPresenter {
            (self.contentPresneter as? ENThemeViewPresenter)?.clearHeaderView()
        }
        
        self.contentPresneter?.contentPresenter?.dataSource.removeAll()
        self.contentPresneter?.collectionView?.reloadData()
    }
    
    
    
    func showMiniSayBannerView() {
        miniSayImageView.isHidden = !UserDefaults.standard.willShowMiniSayBannerView()
    }
    
    func hideMiniSayBannerView(isNaver:Bool = true) {
        miniSayImageView.isHidden = true
        if isNaver {
            UserDefaults.standard.updateMiniSayBannerViewShow()
        }
    }
}





//MARK:- Actions
extension ENNewThemeManagerViewController {
    
    @IBAction func backButtonClicked(_ sender: Any) {
        let parent = self.presentingViewController as? ENSettingViewController
        parent?.reloadData()
        
        enDismiss()
    }
    
    
    
    /// 검색 또는 삭제 동작 버튼 기능 함수
    /// - Parameter sender: 버튼
    @IBAction func subActionButtonClicked(_ sender: Any) {
        switch tabPresenter?.selectedTab {
        case .category:
            DHLogger.log("subActionButtonClicked : 테마 탭")
            hideMiniSayBannerView()
            break
            
        case .photo:
            DHLogger.log("subActionButtonClicked : 포토테마 탭")
            hideMiniSayBannerView()
            break
            
        case .my:
            DHLogger.log("subActionButtonClicked : 마이 탭")
            if let presenter = (contentPresneter?.contentPresenter as? ENMyThemeContentViewPresenter) {
                let inEditMode = presenter.toggleEditMode()
                tabPresenter?.isEditMode = inEditMode
            }
            
            break
            
        default:
            DHLogger.log("subActionButtonClicked : What???")
            break
        }
    }
    
    
    
    
    /// 선택된 테마 미리보기 뷰의 적용버튼 동작
    /// - Parameter sender: 버튼
    @IBAction func confirmThemeButtonClicked(_ sender: Any) {
        
        var selectedTheme: ENKeyboardThemeModel? = nil
        if let presenter = (contentPresneter?.contentPresenter as? ENThemeRecommandPresenter) {
            selectedTheme = presenter.selectedTheme
        }
        
        if let presenter = (contentPresneter?.contentPresenter as? ENThemeCategoryPresenter) {
            selectedTheme = presenter.selectedTheme
        }
        
        if let presenter = (contentPresneter?.contentPresenter as? ENMyThemeContentViewPresenter) {
            selectedTheme = presenter.selectedTheme
        }
        
        
        if let theme = selectedTheme {
            self.showProgressView(with: "테마 적용중입니다.")
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                timer.invalidate()
                
                ENSettingManager.shared.isUsePhotoTheme = false
                self.isUsePhotoThemeForRestore = false
                
                ENKeyboardThemeManager.shared.saveSelectedThemeInfo(theme: theme)
                self.dismiss(animated: true) {
                    self.hideKeyboardPreview()
                }
            }
        }
        else {
            hideKeyboardPreview()
        }
    }
    
    
    /// 선택된 테마 미리보기 뷰의 취소 버튼 동작
    /// - Parameter sender: 버튼
    @IBAction func cancelThemeButtonClicked(_ sender: Any) {
//        hideKeyboard()
        ENSettingManager.shared.isUsePhotoTheme = isUsePhotoThemeForRestore
        hideKeyboardPreview()
    }
    
    
    
    @objc func excuteTopButtonTapped(gesture:UITapGestureRecognizer) {
        collectionView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
}



//MARK:- ProgressDialogView
extension ENNewThemeManagerViewController {
    
    func initProgressView() {
        
        let root = UIView()
        root.backgroundColor = .clear
        
        progressViewMessageLable.text = "Download..."
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
    
    
    func showProgressView(with message:String) {
        progressViewMessageLable.text = message
        self.indicatorVeiw?.startAnimating()
        self.present(downloadProgressView, animated: true, completion: nil)
    }
    
    
    func hideProgressView(completion: (() -> Void)? = nil) {
        self.downloadProgressView.dismiss(animated: true) {
            self.indicatorVeiw?.stopAnimating()
            completion?()
        }
    }
}





//MARK:- Keyboard Theme Preview
extension ENNewThemeManagerViewController {
    
    func initKeyboardView() {
        let keyboard = keyboardViewManager.loadKeyboardView()
        self.keyboardSampleView.addSubview(keyboard)
        
        self.keyboardViewManager.updateConstraints()
        self.keyboardViewManager.updateKeys()
        
        let label = UILabel()
        label.text = "Keyboard Sample"
        label.textAlignment = .center
        label.frame = keyboardViewManager.customView.bounds
        label.frame.size.height = 50.0
        label.frame.size.width = UIScreen.main.bounds.width
        keyboardViewManager.customView.backgroundColor = UIColor.init(white: 0.8, alpha: 0.5)
        
        keyboardViewManager.initCustomArea(with: label)
        
        self.keyboardSampleViewHeight.constant = 0
        self.tabViewBottomMargin.constant = 0
    }
    
    func showKeyboardPreview(theme: ENKeyboardThemeModel?) {
        ENSettingManager.shared.isUsePhotoTheme = false
        let currentTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        let themeFileInfo = theme?.themeFileInfo() ?? currentTheme.themeFileInfo()
        
        ENKeyboardThemeManager.shared.loadTheme(theme: themeFileInfo) { theme in
            self.keyboardViewManager.keyboardTheme = theme
            
            let needHeight = 45.0 + (self.keyboardViewManager.heightConstraint?.constant ?? 0.0)
            self.keyboardSampleViewHeight.constant = needHeight
            self.tabViewBottomMargin.constant = (needHeight - 50.0)
        }
    }
    
    
    func hideKeyboardPreview() {
        self.keyboardSampleViewHeight.constant = 0
        self.tabViewBottomMargin.constant = 0
    }
}






//MARK:- ENCollectionViewPresenter Delegate

extension ENNewThemeManagerViewController: ENCollectionViewPresenterDelegate {
    
    func collectionViewPresenter(_ presenter: ENCollectionViewPresenter, showProgress message: String) {
        showProgressView(with: message)
    }
    
    func collectionViewPresenter(_ presenter: ENCollectionViewPresenter, hideProgress completion: (() -> Void)?) {
        hideProgressView(completion: completion)
    }
    
    func collectionViewPresenter(_ presenter:ENCollectionViewPresenter, showErrorMessage message: String) {
        showErrorMessage(message: message)
    }
    
    
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
            showKeyboardPreview(theme: theme!)
        }
        
    }
    
    func hideKeyboardPreview(_ presenter: ENCollectionViewPresenter) {
        hideKeyboardPreview()
    }
    
    func openGallery(_ presenter: ENCollectionViewPresenter) {
        self.openPhotoGallery()
    }
    
    func editPhoto(_ presenter: ENCollectionViewPresenter, edit image: UIImage) {
        let vc = ENPhotoThemeEditViewController.create()
        vc.photoImage = image
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func exitEditMode(_ presenter: ENCollectionViewPresenter) {
        tabPresenter?.isEditMode = false
    }
}

extension ENNewThemeManagerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openPhotoGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        imagePicker.modalPresentationStyle = .overFullScreen
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let vc = ENPhotoThemeEditViewController.create()
        vc.photoImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        vc.picker = picker
        
        picker.pushViewController(vc, animated: true)
    }
}
