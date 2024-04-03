//
//  ENSearchBaseViewController.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/06.
//

import UIKit
import KeyboardSDKCore

class ENSearchBaseViewController: UIViewController, ENViewPrsenter, UITextFieldDelegate, MyThemeManageProtocol {
    
    @IBOutlet weak var keywordInputRootView: UIView!
    @IBOutlet weak var clearKewordButton: UIButton!
    
    @IBOutlet weak var keywordTextField: UITextField!
    

    @IBOutlet weak var contentRootView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var keyboardSampleView: UIView!
    @IBOutlet weak var keyboardSampleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var topButtonView: UIView!
    @IBOutlet weak var topButtonShadowView: UIView!
    
    
    
    var downloadProgressView: UIViewController = UIViewController.init()
    var progressViewMessageLable:UILabel = UILabel()
    var indicatorVeiw: ENActivityIndicatorView? = nil
    
    var keyboardViewManager:ENKeyboardViewManager = ENKeyboardViewManager.init(proxy: nil, needsInputModeSwitchKey: true)
    var customAreaView: ENKeyboardCustomAreaView? = nil
    
    var isUsePhotoThemeForRestore:Bool = false
    var contentPresenter: ENCollectionViewPresenter? = nil
    
    static func create() -> ENSearchBaseViewController {
        let vc = ENSearchBaseViewController.init(nibName: "ENSearchBaseViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customAreaView = ENKeyboardCustomAreaView(frame: .zero)
        
        initKeyboardView()
        initProgressView()
        
        topButtonView.layer.applyRounding(cornerRadius: 22.5, borderColor: UIColor.topButtonBorder, borderWidth: 1.7, masksToBounds: true)
        topButtonShadowView.layer.applySketchShadow(color: .black, alpha: 0.15, x: 0, y: 1, blur: 2.7, spread: 0)
        
        topButtonShadowView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTopButtonTapped(gesture:))))
        
        isUsePhotoThemeForRestore = ENSettingManager.shared.isUsePhotoTheme
        
        keywordInputRootView.layer.applyRounding(cornerRadius: 16.5, borderColor: UIColor.clear, borderWidth: 0.0, masksToBounds: true)
        
        self.contentPresenter?.delegate = self
        self.contentPresenter?.topButton = topButtonShadowView
        
        keywordTextField.delegate = self
        
        topButtonShadowView.isHidden = true
    }
    
    func initForSearchTheme() {
        self.contentPresenter = ENThemeSearchPresenter.init(collectionView: collectionView, contentView: contentRootView, keywordTextField: keywordTextField)
        self.contentPresenter?.delegate = self
        self.contentPresenter?.topButton = topButtonShadowView
        
        self.keywordTextField.placeholder = "테마를 검색해보세요."
    }
    
    func initForSearchPhotoTheme() {
        self.contentPresenter = ENThemePhotoSearchPresenter.init(collectionView: collectionView, contentView: contentRootView, keywordTextField: keywordTextField)
        self.contentPresenter?.delegate = self
        self.contentPresenter?.topButton = topButtonShadowView
        
        self.keywordTextField.placeholder = "사진을 검색해보세요."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregistKeyboardNotifications()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search(keyword: textField.text ?? "")
        return true
    }
    
    
    func search(keyword:String) {
        (contentPresenter as? ENThemeSearchProtocol)?.search(by: keyword, from: nil)
    }
}




//MARK:- Actions

extension ENSearchBaseViewController {
    
    private func updateParentView(selectedTheme:ENKeyboardThemeModel) {
        let parent = self.presentingViewController as? ENNewThemeManagerViewController
        
        if let presenter = parent?.contentPresenter?.contentPresenter as? ENThemeRecommandPresenter {
            presenter.selectedTheme = selectedTheme
        }
        
        if let presenter = parent?.contentPresenter?.contentPresenter as? ENThemeCategoryPresenter {
            presenter.selectedTheme = selectedTheme
        }
        
        parent?.collectionView.reloadData()
    }
    
    
    
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        enDismiss()
    }
    
    
    @IBAction func clearKewordButtonClicked(_ sender: Any) {
        keywordTextField.text = ""
        search(keyword: "")
    }
    
    @IBAction func textFieldChagnedText(_ sender: Any) {
        if let keyword = keywordTextField.text, keyword.isEmpty {
            search(keyword: keyword)
        }
    }
    
    
    /// 선택된 테마 미리보기 뷰의 적용버튼 동작
    /// - Parameter sender: 버튼
    @IBAction func confirmThemeButtonClicked(_ sender: Any) {
        
        var selectedTheme: ENKeyboardThemeModel? = nil
        
        if let presenter = (contentPresenter as? ENThemeSearchPresenter) {
            selectedTheme = presenter.selectedTheme
        }
        
        
        if let theme = selectedTheme {
            self.showProgressView(with: "테마 적용중")
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {[weak self] timer in
                guard let self else { return }
                
                timer.invalidate()
                
                ENSettingManager.shared.isUsePhotoTheme = false
                self.isUsePhotoThemeForRestore = false
                
                ENKeyboardThemeManager.shared.saveSelectedThemeInfo(theme: theme)
                self.saveThemeAtMyTheme(theme: theme)
                
                self.updateParentView(selectedTheme: theme)
                
                self.hideProgressView {
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
        ENSettingManager.shared.isUsePhotoTheme = isUsePhotoThemeForRestore
        hideKeyboardPreview()
    }
    
    
    @objc func excuteTopButtonTapped(gesture:UITapGestureRecognizer) {
        collectionView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    
}



//MARK:- ProgressDialogView
extension ENSearchBaseViewController {
    
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
    
    
    func showProgressView(with message:String) {
        progressViewMessageLable.text = message
        self.indicatorVeiw?.startAnimating()
        self.present(downloadProgressView, animated: true, completion: nil)
    }
    
    
    func hideProgressView(completion: (() -> Void)? = nil) {
        self.downloadProgressView.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.indicatorVeiw?.stopAnimating()
            completion?()
        }
    }
}





//MARK:- Keyboard Theme Preview
extension ENSearchBaseViewController {
    
    func initKeyboardView() {
        let keyboard = keyboardViewManager.loadKeyboardView()
        self.keyboardSampleView.addSubview(keyboard)
        
        self.keyboardViewManager.updateConstraints()
        self.keyboardViewManager.updateKeys()
        
        
        if let customAreaView = customAreaView {
            customAreaView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            customAreaView.isUserInteractionEnabled = true
            
            keyboardViewManager.initCustomArea(with: customAreaView)
            customAreaView.sizeToFit()
            
            customAreaView.setButtonHandler(item: customAreaView.btnArray)
            customAreaView.setScrollViewConstraint()
        }
        
        
        self.keyboardSampleViewHeight.constant = 0
        self.contentViewBottomMargin.constant = 0
    }
    
    func showKeyboardPreview(theme: ENKeyboardThemeModel?) {
        ENSettingManager.shared.isUsePhotoTheme = false
        let currentTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        let themeFileInfo = theme?.themeFileInfo() ?? currentTheme.themeFileInfo()
        
        customAreaView?.keyboardThemeModel = theme
        
        ENKeyboardThemeManager.shared.loadTheme(theme: themeFileInfo) {[weak self] theme in
            guard let self else { return }
            self.keyboardViewManager.keyboardTheme = theme
            self.customAreaView?.keyboardTheme = theme
            
            let needHeight = 45.0 + (self.keyboardViewManager.heightConstraint?.constant ?? 0.0)
            self.keyboardSampleViewHeight.constant = needHeight
            self.contentViewBottomMargin.constant = (needHeight - 50.0)
        }
    }
    
    
    func hideKeyboardPreview() {
        self.keyboardSampleViewHeight.constant = 0
        self.contentViewBottomMargin.constant = 0
    }
}




//MARK:- ENCollectionViewPresenter Delegate

extension ENSearchBaseViewController: ENCollectionViewPresenterDelegate {
    
    func collectionViewPresenter(_ presenter: ENCollectionViewPresenter, showProgress message: String) {
        showProgressView(with: message)
    }
    
    func collectionViewPresenter(_ presenter: ENCollectionViewPresenter, hideProgress completion: (() -> Void)?) {
        hideProgressView(completion: completion)
    }
    
    func collectionViewPresenter(_ presenter:ENCollectionViewPresenter, showErrorMessage message: String) {
        showErrorMessage(message: message)
    }
    
    func collectionViewPresenter(_ presenter: ENCollectionViewPresenter, showDialog dialog: UIViewController) {
    }
    
    
    func showKeyboardPreview(_ presenter: ENCollectionViewPresenter) {
        self.hideKeyboard()
        
        var theme:ENKeyboardThemeModel? = nil
        if presenter is ENThemeSearchPresenter {
            theme = (presenter as? ENThemeSearchPresenter)?.selectedTheme
        }
        
        if let _ = theme {
            showKeyboardPreview(theme: theme!)
        }
        
    }
    
    func hideKeyboardPreview(_ presenter: ENCollectionViewPresenter) {
        hideKeyboardPreview()
    }
    
    func editPhoto(_ presenter: ENCollectionViewPresenter, edit image: UIImage) {
        let vc = ENPhotoThemeEditViewController.create()
        vc.photoImage = image
        vc.modalPresentationStyle = .overFullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func openGallery(_ presenter: ENCollectionViewPresenter) {
    }
    
    func exitEditMode(_ presenter: ENCollectionViewPresenter, deletedCount: Int) {
    }
}


//MARK:- Keyboard....

extension ENSearchBaseViewController {
    
    func registKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregistKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        
        let userInfo = notification.userInfo!
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
                
        if(show) {
            let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            var offset:CGFloat = self.view.safeAreaInsets.bottom
            if UIDevice.current.getDeviceVersions() == "X" {
                offset = 35
            }
            let changeInHeight = (keyboardFrame.height-offset) * (show ? -1 : 1)
            
            UIView.animate(withDuration: animationDurarion, delay: 0.0, options: UIView.AnimationOptions(rawValue:curve), animations: {[weak self] in
                guard let self else { return }
                self.contentViewBottomMargin.constant = changeInHeight
            },
                           completion: nil)
            
        }
        else {
            UIView.animate(withDuration: animationDurarion, delay: 0.0, options: UIView.AnimationOptions(rawValue:curve), animations: {[weak self] in
                guard let self else { return }
                self.contentViewBottomMargin.constant = 0
            },
                           completion: nil)
        }
        
    }
    
    
    func hideKeyboard() {
        keywordTextField.endEditing(true)
    }
    
    func showKeyboard() {
        keywordTextField.becomeFirstResponder()
    }
}
