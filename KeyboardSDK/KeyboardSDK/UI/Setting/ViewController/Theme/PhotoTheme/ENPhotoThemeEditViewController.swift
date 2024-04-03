//
//  ENPhotoThemeEditViewController.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/28.
//

import UIKit
import KeyboardSDKCore




class ENPhotoThemeEditViewController: UIViewController, ENViewPrsenter {

    @IBOutlet weak var imageScrollView: ENImageScrollView!
    @IBOutlet weak var changeKeyColorButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var changeTransparentSlider: UISlider!
    @IBOutlet weak var showKeyboardButton: UIButton!
    
    @IBOutlet weak var imageScrollViewRatio: NSLayoutConstraint!
    
    @IBOutlet weak var keyboardSampleView: UIView!
    @IBOutlet weak var keyboardSampleViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var cropGuideRootView: UIView!
    @IBOutlet weak var cropGuideLabelView: UIView!
    
    
    weak var picker:UIImagePickerController?
    
    var downloadProgressView: UIViewController = UIViewController.init()
    var progressViewMessageLable:UILabel = UILabel()
    var indicatorVeiw: ENActivityIndicatorView? = nil
    
    
    
    var photoImage:UIImage? = nil {
        didSet {
            photoTheme.isPhotoTheme = true
            photoTheme.loadPhotoThemeIcons()
            photoTheme.backgroundImage = photoImage
            
            setUpImage()
        }
    }
    
    var photoTheme:ENKeyboardTheme = ENKeyboardTheme() {
        didSet {
            photoTheme.isPhotoTheme = true
            photoTheme.loadPhotoThemeIcons()
            photoTheme.backgroundImage = photoImage
        }
    }
    
    var isUsePhotoThemeRestore:Bool = false
    
    var keyboardViewManager:ENKeyboardViewManager = ENKeyboardViewManager.init(proxy: nil, needsInputModeSwitchKey: true)
    var customAreaView: ENKeyboardCustomAreaView? = nil
    
    var imageScrollViewDummyEventCount:Int = 5
    
    
    
    public static func create() -> ENPhotoThemeEditViewController {
        let vc = ENPhotoThemeEditViewController.init(nibName: "ENPhotoThemeEditViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trans:CGAffineTransform  = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        changeTransparentSlider.transform = trans
        changeTransparentSlider.maximumValue = 1.0
        changeTransparentSlider.minimumValue = 0.0
        changeTransparentSlider.value = 1.0
        
        restoreButton.layer.applyRounding(cornerRadius: 22.5, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
        changeKeyColorButton.layer.applyRounding(cornerRadius: 22.5, borderColor: .aikbdPointBlue, borderWidth: 2.0, masksToBounds: true)
        
        isUsePhotoThemeRestore = ENSettingManager.shared.isUsePhotoTheme
        
        imageScrollView.setup()
        imageScrollView.imageScrollViewDelegate = self
        imageScrollView.imageContentMode = .widthFill
        imageScrollView.initialOffset = .center
        imageScrollView.bounces = false
        
        cropGuideLabelView.layer.borderWidth = 1.0
        cropGuideLabelView.layer.borderColor = UIColor.aikbdBodyLargeTitle.cgColor
        
        cropGuideRootView.isHidden = false
        
        
        let keyboardHeight = ENSettingManager.shared.getKeyboardHeight(isLandcape: false)
        let scrWidth = UIScreen.main.bounds.width
        let ratio = scrWidth / keyboardHeight
        imageScrollViewRatio.constant = ratio
        
        self.setUpImage()
        
        customAreaView = ENKeyboardCustomAreaView(frame: .zero)
        
        initKeyboardView()
        initProgressView()
        showKeyboardPreview()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeTransparentSlider.redrawSliderThumbShadow(sub: changeTransparentSlider)
    }
    
    
    private func setUpImage() {
        if let photo = photoImage {
            photoTheme.backgroundImage = photoImage
            imageScrollView?.display(image: photo)
        }
    }
    
    func updateShowKeyboardButton() {
        if keyboardSampleViewHeight.constant == 0 {
            showKeyboardButton?.setImage(UIImage(named: "aikbdKeyboardUpIcon", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
        }
        else {
            showKeyboardButton?.setImage(UIImage(named: "aikbdKeyboardDownIcon", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
        }
    }
}



//MARK:- Actions
extension ENPhotoThemeEditViewController {
    
    func closeOnlySelf() {
        enDismiss()
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
//            if let parent = self.presentingViewController as? ENNewThemeManagerViewController {
//                self.dismiss(animated: false) {
//                    parent.dismiss(animated: true, completion: nil)
//                }
//            }
//            else {
//                self.dismiss(animated: true, completion: nil)
//            }
            self.dismiss(animated: true, completion: nil)
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
    
    
    @IBAction func changeKeyColorButtonClicked(_ sender: Any) {
        let colorVC = ENPhotoThemeEditColorViewController.create()
        colorVC.isUsePhotoThemeRestore = isUsePhotoThemeRestore
        colorVC.photoTheme = photoTheme
        colorVC.photoImage = photoImage
        colorVC.picker = picker
        
        enPresent(colorVC)
    }
    
    @IBAction func restoreButtonClicked(_ sender: Any) {
        imageScrollView.refresh()
        changeTransparentSlider.value = 1.0
        
        updateCuttedImageView()
    }
    
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        photoTheme.backgroundImage = photoImage
        ENKeyboardThemeManager.shared.savePhotoTheme(with: photoTheme, originImage: self.photoImage) {[weak self] success in
            guard let self else { return }
            if success {
                self.showProgressView(with: "테마 적용중")
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
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
        photoTheme.imageAlpha = CGFloat(changeTransparentSlider.value)
        updatePreview()
    }
    
}



extension ENPhotoThemeEditViewController: ENImageScrollViewDelegate {
    
    func imageScrollViewDidChangeOrientation(imageScrollView: ENImageScrollView) {
        
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming at scale \(scale)")
        if imageScrollViewDummyEventCount > 0 {
            hideCropGuideView()
        }
        updateCuttedImageView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
        if imageScrollViewDummyEventCount > 0 {
            hideCropGuideView()
        }
        
        updateCuttedImageView()
    }
    
    func hideCropGuideView() {
        imageScrollViewDummyEventCount -= 1
        cropGuideRootView.isHidden = imageScrollViewDummyEventCount <= 0
    }
    
    func updateCuttedImageView() {
        let scale = imageScrollView.zoomScale
        let offset = imageScrollView.contentOffset
        let isvFrame = imageScrollView.frame
        
        photoTheme.imageOffsetX = offset.x / scale
        photoTheme.imageOffsetY = offset.y / scale
        photoTheme.imageUseWidth = isvFrame.width / scale
        photoTheme.imageUseHeight = isvFrame.height / scale
        photoTheme.imageAlpha = CGFloat(changeTransparentSlider.value)
        photoTheme.imageScale = scale
        
        updatePreview()
    }
}






//MARK:- Keyboard Theme Preview
extension ENPhotoThemeEditViewController {
    
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
extension ENPhotoThemeEditViewController {
    
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
