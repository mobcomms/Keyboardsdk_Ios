//
//  ENNewThemeManagerViewController.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/06/18.
//

import UIKit
import KeyboardSDKCore


class ENNewThemeManagerViewController: UIViewController, ENViewPrsenter, ENTabContentPresenterDelegate {
    
    @IBOutlet weak var displayTitleLabel: UILabel!
    @IBOutlet weak var keyboardSampleView: UIView!
    @IBOutlet weak var keyboardSampleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var downloadProgressView: UIViewController = UIViewController.init()
    var progressViewMessageLable:UILabel = UILabel()
    var indicatorVeiw: ENActivityIndicatorView? = nil
    var keyboardViewManager:ENKeyboardViewManager = ENKeyboardViewManager.init(proxy: nil, needsInputModeSwitchKey: true)
    var customAreaView: ENKeyboardCustomAreaView? = nil
    var contentPresenter: ENTabContentPresenter?
    
    
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
        
        customAreaView = ENKeyboardCustomAreaView(frame: .zero)
        
        initKeyboardView()
        initProgressView()
       
        initColloctionView()

        self.contentPresenter = ENThemeViewPresenter.init(collectionView: collectionView)
        self.contentPresenter?.delegate = self
        self.contentPresenter?.contentDelegate = self
        self.contentPresenter?.loadData()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    
    
    func initColloctionView() {
        if self.contentPresenter is ENThemeViewPresenter {
            (self.contentPresenter as? ENThemeViewPresenter)?.clearHeaderView()
        }
        
        self.contentPresenter?.contentPresenter?.dataSource.removeAll()
        self.contentPresenter?.collectionView?.reloadData()
    }
    
    
    
}





//MARK:- Actions
extension ENNewThemeManagerViewController {
    
    @IBAction func backButtonClicked(_ sender: Any) {
        enDismiss()
    }
    
    
    
    /// 선택된 테마 미리보기 뷰의 적용버튼 동작
    /// - Parameter sender: 버튼
    @IBAction func confirmThemeButtonClicked(_ sender: Any) {
        
        var selectedTheme: ENKeyboardThemeModel? = nil
        
        
        if let presenter = (contentPresenter?.contentPresenter as? ENThemeCategoryPresenter) {
            selectedTheme = presenter.selectedTheme
        }

        if let theme = selectedTheme {
            self.showProgressView(with: "테마 적용중")
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {[weak self] timer in
                guard let self else { return }
                timer.invalidate()
                
                ENKeyboardThemeManager.shared.saveSelectedThemeInfo(theme: theme)
                
                if let presenter = (self.contentPresenter?.contentPresenter as? ENThemeCategoryPresenter) {
                    presenter.updateSelectedThemeDataTo(isOwn: true)
                }
                
                self.hideProgressView(completion: {
                    self.hideKeyboardPreview()
                })
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
        hideKeyboardPreview()
    }
}

//MARK:- ProgressDialogView
extension ENNewThemeManagerViewController {
    
    func initProgressView() {
        
        let root = UIView()
        root.backgroundColor = .clear
        
        progressViewMessageLable.text = "테마 미리보기 적용중"
        progressViewMessageLable.textColor = .white
        progressViewMessageLable.textAlignment = .center
        progressViewMessageLable.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        
        indicatorVeiw = ENActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 70, height: 70), type: .ballClipRotate, color: UIColor(red: 1, green: 182/255, blue: 55/255, alpha: 1), padding: nil)
        
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
extension ENNewThemeManagerViewController {
    
    func initKeyboardView() {

        let keyboard = keyboardViewManager.loadKeyboardView()
        self.keyboardSampleView.addSubview(keyboard)
        
        self.keyboardViewManager.isUseNotifyView = false

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
        let currentTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        let themeFileInfo = currentTheme.themeFileInfo()

        customAreaView!.keyboardThemeModel = currentTheme

        customAreaView!.updateUI()
        ENKeyboardThemeManager.shared.loadTheme(theme: themeFileInfo) { [weak self] theme in
            guard let self else { return }
            self.keyboardViewManager.keyboardTheme = theme
            self.customAreaView!.keyboardTheme = theme

            self.customAreaView!.updateUI()
        }

        self.keyboardSampleViewHeight.constant = 0
    }
    
    func showKeyboardPreview(theme: ENKeyboardThemeModel?) {
        let currentTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        let themeFileInfo = theme?.themeFileInfo() ?? currentTheme.themeFileInfo()
        
        customAreaView?.keyboardThemeModel = theme
        
        ENKeyboardThemeManager.shared.loadTheme(theme: themeFileInfo) { theme in
            self.keyboardViewManager.keyboardTheme = theme
            self.customAreaView?.keyboardTheme = theme
            
            let needHeight =  45 + (self.keyboardViewManager.heightConstraint?.constant ?? 0.0)
            self.keyboardSampleViewHeight.constant = needHeight
        }
    }
    
    
    func hideKeyboardPreview() {
        self.keyboardSampleViewHeight.constant = 0
    }
}






//MARK:- ENCollectionViewPresenter Delegate

extension ENNewThemeManagerViewController: ENCollectionViewPresenterDelegate  {
    
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
        self.present(dialog, animated: true, completion: nil)
    }
    
    
    func showKeyboardPreview(_ presenter: ENCollectionViewPresenter) {
        var theme:ENKeyboardThemeModel? = nil
       if presenter is ENThemeCategoryPresenter {
            theme = (presenter as? ENThemeCategoryPresenter)?.selectedTheme
        }
        if let _ = theme {
            showKeyboardPreview(theme: theme!)
        }
        
    }
    
    func hideKeyboardPreview(_ presenter: ENCollectionViewPresenter) {
        hideKeyboardPreview()
    }
    
    
    
    
}

