//
//  ENPhotoThemeEditColorViewController.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/01.
//

import UIKit
import KeyboardSDKCore



class ENPhotoThemeEditColorViewController: UIViewController {

    
    @IBOutlet weak var changeTransparentSlider: UISlider!
    @IBOutlet weak var showKeyboardButton: UIButton!
    
    @IBOutlet weak var keyboardSampleView: UIView!
    @IBOutlet weak var keyboardSampleViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var restoreButton: UIButton!
    
    @IBOutlet weak var colorPicker: DHColorPicker!
    
    
    @IBOutlet weak var allKeyButton: ENSortButtonView!
    @IBOutlet weak var normalKeyButton: ENSortButtonView!
    @IBOutlet weak var specialKeyButton: ENSortButtonView!
    
    
    var isUsePhotoThemeRestore:Bool = false
    var keyboardViewManager:ENKeyboardViewManager = ENKeyboardViewManager.init(proxy: nil, needsInputModeSwitchKey: true)
    var customAreaView: ENKeyboardCustomAreaView? = nil
    
    
    var photoImage:UIImage? = nil {
        didSet {
            updatePreview()
        }
    }
    var photoTheme:ENKeyboardTheme = ENKeyboardTheme() {
        didSet {
            photoTheme.isPhotoTheme = true
            photoTheme.loadPhotoThemeIcons()
            
            updatePreview()
        }
    }
    
    var currentSelectedColor:UIColor = UIColor.init(white: 0.0, alpha: 0.8)
    
    
    weak var picker:UIImagePickerController?
    
    var downloadProgressView: UIViewController = UIViewController.init()
    var progressViewMessageLable:UILabel = UILabel()
    var indicatorVeiw: ENActivityIndicatorView? = nil
    
    
    
    public static func create() -> ENPhotoThemeEditColorViewController {
        let vc = ENPhotoThemeEditColorViewController.init(nibName: "ENPhotoThemeEditColorViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trans:CGAffineTransform  = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        changeTransparentSlider.transform = trans
        changeTransparentSlider.maximumValue = 0.9
        changeTransparentSlider.minimumValue = 0.0
        changeTransparentSlider.value = changeTransparentSlider.maximumValue * 0.7
        
        restoreButton.layer.applyRounding(cornerRadius: 22.5, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
        
        isUsePhotoThemeRestore = ENSettingManager.shared.isUsePhotoTheme
        
        allKeyButton.isSelected = true
        normalKeyButton.isSelected = false
        specialKeyButton.isSelected = false
        
        colorPicker.delegate = self
        colorPicker.updatePointViewPosition(at: photoTheme.themeColors.nor_btn_color)
        
        allKeyButton.isUserInteractionEnabled = true
        specialKeyButton.isUserInteractionEnabled = true
        normalKeyButton.isUserInteractionEnabled = true
        
        allKeyButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGestureForSortButton(gesture:))))
        normalKeyButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGestureForSortButton(gesture:))))
        specialKeyButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGestureForSortButton(gesture:))))
        
        customAreaView = ENKeyboardCustomAreaView(frame: .zero)
        
        initKeyboardView()
        initProgressView()
        showKeyboardPreview()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeTransparentSlider.redrawSliderThumbShadow(sub: changeTransparentSlider)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        changeTransparentSlider.redrawSliderThumbShadow(sub: changeTransparentSlider)
    }
    
    func updateShowKeyboardButton() {
        if keyboardSampleViewHeight.constant == 0 {
            showKeyboardButton?.setImage(UIImage(named: "aikbdKeyboardUpIcon", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
        }
        else {
            showKeyboardButton?.setImage(UIImage(named: "aikbdKeyboardDownIcon", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
        }
    }
    
    func updateKeyColor() {
        let alpha = CGFloat(changeTransparentSlider.value)
        let realColor = currentSelectedColor.withAlphaComponent(alpha)
        
        if normalKeyButton.isSelected {
            photoTheme.themeColors.nor_btn_color = realColor
        }
        else if specialKeyButton.isSelected {
            photoTheme.themeColors.sp_btn_color = realColor
        }
        else {
            photoTheme.themeColors.nor_btn_color = realColor
            photoTheme.themeColors.sp_btn_color = realColor
        }
        
        updatePreview()
    }
}





//MARK:- Actions
extension ENPhotoThemeEditColorViewController {
    
    func closeOnlySelf() {
        
        if let navi = self.navigationController {
            let vcs = navi.viewControllers
            (vcs[vcs.count-2] as? ENPhotoThemeEditViewController)?.photoTheme = photoTheme
            (vcs[vcs.count-2] as? ENPhotoThemeEditViewController)?.updatePreview()
            navi.popViewController(animated: true)
        }
        else {
            (self.presentingViewController as? ENPhotoThemeEditViewController)?.photoTheme = photoTheme
            (self.presentingViewController as? ENPhotoThemeEditViewController)?.updatePreview()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func closeAll() {
        if let picker = picker {
//            if let parent = picker.presentingViewController as? ENNewThemeManagerViewController {
//                picker.dismiss(animated: false) {
//                    parent.dismiss(animated: true, completion: nil)
//                }
//            }
//            else {
//                picker.dismiss(animated: true, completion: nil)
//            }
            picker.dismiss(animated: true, completion: nil)
        }
        else {
            if let navi = self.navigationController {
                navi.popToRootViewController(animated: true)
            }
            else {
                if let parent = self.presentingViewController as? ENPhotoThemeEditViewController {
                    self.dismiss(animated: false) {
                        parent.closeAll()
                    }
                }
                else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        closeOnlySelf()
    }
    
    @IBAction func showKeyboardButtonClicked(_ sender: Any) {
        if keyboardSampleViewHeight.constant == 0 {
            showKeyboardPreview()
        }
        else {
            hideKeyboardPreview()
        }
        
        updateShowKeyboardButton()
    }
    
    
    @IBAction func restoreButtonClicked(_ sender: Any) {
        photoTheme.themeColors = ENThemeColors.init(json: nil, with: nil)
        colorPicker.initPointView()
        changeTransparentSlider.value = changeTransparentSlider.maximumValue * 0.7
        
        updatePreview()
    }
    
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        photoTheme.backgroundImage = photoImage
        ENKeyboardThemeManager.shared.savePhotoTheme(with: photoTheme, originImage: self.photoImage) { [weak self] success in
            guard let self else { return }
            if success {
                self.showProgressView(with: "테마 적용중")
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] timer in
                    guard let self else { return }
                    timer.invalidate()
                    
                    self.hideProgressView(completion: {
                        self.closeAll()
                    })
                }
            }
        }
    }
    
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        ENSettingManager.shared.isUsePhotoTheme = isUsePhotoThemeRestore
        self.closeAll()
    }
    
    @IBAction func transparentSliderValueChanged(_ sender: Any) {
        updateKeyColor()
    }
    
    
    @objc func excuteTapGestureForSortButton(gesture:UITapGestureRecognizer) {
        allKeyButton.isSelected = (gesture.view == allKeyButton)
        normalKeyButton.isSelected = (gesture.view == normalKeyButton)
        specialKeyButton.isSelected = (gesture.view == specialKeyButton)
        
        updateKeyColor()
    }
}



//MARK:- DHColorPickerDelegate
extension ENPhotoThemeEditColorViewController: DHColorPickerDelegate {
    func DHColorColorPickerTouched(sender: DHColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        currentSelectedColor = color
        
        updateKeyColor()
    }
}


//MARK:- Keyboard Theme Preview
extension ENPhotoThemeEditColorViewController {
    
    func updatePreview() {
        photoTheme.backgroundImage = photoImage
        photoTheme.backgroundImage = ENKeyboardThemeManager.shared.croppedImageForPhotoTheme(theme: photoTheme)
        keyboardViewManager.keyboardTheme = photoTheme
        
        customAreaView?.keyboardThemeModel = nil
        customAreaView?.keyboardTheme = photoTheme
    }
    
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
        
        self.keyboardViewManager.keyboardTheme = photoTheme
        self.customAreaView?.keyboardThemeModel = nil
        self.customAreaView?.keyboardTheme = photoTheme
    }
    
    func showKeyboardPreview() {
        let needHeight = 45.0 + (self.keyboardViewManager.heightConstraint?.constant ?? 0.0)
        self.keyboardSampleViewHeight.constant = needHeight
    }
    
    
    func hideKeyboardPreview() {
        self.keyboardSampleViewHeight.constant = 0
    }
}


//MARK:- ProgressDialogView
extension ENPhotoThemeEditColorViewController {
    
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
