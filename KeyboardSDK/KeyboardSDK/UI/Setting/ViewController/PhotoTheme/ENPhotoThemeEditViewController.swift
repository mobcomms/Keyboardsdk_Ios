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
    @IBOutlet weak var changeTransparentSlider: UISlider!
    @IBOutlet weak var showKeyboardButton: UIButton!
    
    @IBOutlet weak var imageScrollViewRatio: NSLayoutConstraint!
    
    @IBOutlet weak var keyboardSampleView: UIView!
    @IBOutlet weak var keyboardSampleViewHeight: NSLayoutConstraint!
    
    
    weak var picker:UIImagePickerController?
    
    
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
        
        
        changeKeyColorButton.layer.applyRounding(cornerRadius: 8, borderColor: .aikbdPointBlue, borderWidth: 2.0, masksToBounds: true)
        
        isUsePhotoThemeRestore = ENSettingManager.shared.isUsePhotoTheme
        
        imageScrollView.setup()
        imageScrollView.imageScrollViewDelegate = self
        imageScrollView.imageContentMode = .widthFill
        imageScrollView.initialOffset = .center
        imageScrollView.bounces = false
        
        let keyboardHeight = ENSettingManager.shared.getKeyboardHeight(isLandcape: false)
        let scrWidth = UIScreen.main.bounds.width
        let ratio = scrWidth / keyboardHeight
        imageScrollViewRatio.constant = ratio
        
        self.setUpImage()
        
        initKeyboardView()
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
            if let parent = picker.presentingViewController as? ENNewThemeManagerViewController {
                picker.dismiss(animated: false) {
                    parent.dismiss(animated: true, completion: nil)
                }
            }
            else {
                picker.dismiss(animated: true, completion: nil)
            }
        }
        else {
            if let parent = self.presentingViewController as? ENNewThemeManagerViewController {
                self.dismiss(animated: false) {
                    parent.dismiss(animated: true, completion: nil)
                }
            }
            else {
                self.dismiss(animated: true, completion: nil)
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
    
    
    @IBAction func changeKeyColorButtonClicked(_ sender: Any) {
        let colorVC = ENPhotoThemeEditColorViewController.create()
        colorVC.isUsePhotoThemeRestore = isUsePhotoThemeRestore
        colorVC.photoTheme = photoTheme
        colorVC.photoImage = photoImage
        colorVC.picker = picker
        
        enPresent(colorVC)
    }
    
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        ENKeyboardThemeManager.shared.savePhotoTheme(with: photoTheme, originImage: self.photoImage) { success in
            if success {
                self.closeAll()
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
        updateCuttedImageView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
        updateCuttedImageView()
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
        
        updatePreview()
    }
}






//MARK:- Keyboard Theme Preview
extension ENPhotoThemeEditViewController {
    
    func updatePreview() {
        keyboardViewManager.keyboardTheme = photoTheme
    }
    
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
        
        self.keyboardViewManager.keyboardTheme = photoTheme
    }
    
    func showKeyboardPreview() {
        let needHeight = 45.0 + (self.keyboardViewManager.heightConstraint?.constant ?? 0.0)
        self.keyboardSampleViewHeight.constant = needHeight
    }
    
    
    func hideKeyboardPreview() {
        self.keyboardSampleViewHeight.constant = 0
    }
}
