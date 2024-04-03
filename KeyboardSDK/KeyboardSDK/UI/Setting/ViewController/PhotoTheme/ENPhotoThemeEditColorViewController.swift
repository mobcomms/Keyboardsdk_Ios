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
    
    var photoImage:UIImage? = nil
    var photoTheme:ENKeyboardTheme = ENKeyboardTheme() {
        didSet {
            photoTheme.isPhotoTheme = true
            photoTheme.loadPhotoThemeIcons()
            
            updatePreview()
        }
    }
    
    var currentSelectedColor:UIColor = UIColor.init(white: 0.0, alpha: 0.8)
    
    
    weak var picker:UIImagePickerController?
    
    
    
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
        
        restoreButton.layer.applyRounding(cornerRadius: 15.0, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
        
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
        
        
        initKeyboardView()
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
        
        updatePreview()
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
