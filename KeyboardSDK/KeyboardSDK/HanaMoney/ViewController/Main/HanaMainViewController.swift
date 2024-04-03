//
//  HanaMainViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 10/25/23.
//

import Foundation
import KeyboardSDKCore

public class HanaMainViewController: UIViewController, ENViewPrsenter {
    
    public static func create() -> HanaMainViewController {
        let vc = HanaMainViewController.init(nibName: "HanaMainViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    var keyboardViewManager: ENKeyboardViewManager?
            
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var viewKeyboardType: UIView!
    @IBOutlet weak var lblKeyboardType: UILabel!
        
    @IBOutlet weak var viewKeyboardHeight: UIView!
    @IBOutlet weak var sliderHeight: UISlider!
    
    @IBOutlet weak var viewKeyboardSound: UIView!
    @IBOutlet weak var lblKeyboardSound: UILabel!
    
    @IBOutlet weak var viewKeyboardVibrator: UIView!
    @IBOutlet weak var switchKeyboardVibrator: UISwitch!
    @IBOutlet weak var sliderKeyboardVibrator: UISlider!
   
    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var switchPreview: UISwitch!
    
    @IBOutlet weak var viewKeyboardSetting: UIView!
    
    @IBOutlet weak var viewSample: UIView!
    @IBOutlet weak var constraintHeightViewSample: NSLayoutConstraint!
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        sliderHeight.minimumValue = 0
        sliderHeight.maximumValue = 40
        
        settingViewMoveGesture()
        
        settingKeyboardSampleViewHideForOtherViewTap()
        
        saveUUID()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardViewManager = ENKeyboardViewManager(proxy: nil, needsInputModeSwitchKey: false)
        initKeyboardView()
        hideSampleView()
        loadData()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ENSettingManager.shared.isFirstUser {
            print("firstUser")
            // 가이드 화면 이동
            let vc = HanaGuideViewController.create()
            self.enPresent(vc, animated: true)
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func btnBackHandler(_ sender: Any) {
        enDismiss()
    }
    
    @IBAction func sliderChangeHandler(_ sender: UISlider) {
        if viewSample.isHidden {
            viewSample.isHidden = false
            constraintHeightViewSample.constant = ENSettingManager.shared.getKeyboardHeight(isLandcape: false)
        }
        
        let roundedValue = round(sender.value / 1) * 1
        
        if roundedValue != sender.value {
            sender.value = roundedValue
        }
        
        ENSettingManager.shared.keyboardHeightRate = roundedValue
        
        if let keyboardViewManager = keyboardViewManager {
            keyboardViewManager.updateKeyboardHeight(isLand: false)
        }
        
        let changeHeigt = ENSettingManager.shared.getKeyboardHeight(isLandcape: false)
        self.constraintHeightViewSample.constant = changeHeigt
        
    }
    
    @IBAction func switchKeyboardVibratorHandler(_ sender: UISwitch) {
        hideSampleView()
        if sender.isOn {
            ENSettingManager.shared.hapticPower = 1
            sliderKeyboardVibrator.value = 1
        } else {
            ENSettingManager.shared.hapticPower = 0
            sliderKeyboardVibrator.value = 0
        }
    }
    
    @IBAction func sliderKeyboardVibaratorHandler(_ sender: UISlider) {        
        let roundedValue = round(sender.value / 1) * 1
        
        if Int(roundedValue) != ENSettingManager.shared.hapticPower {
            hideSampleView()
            ENSettingManager.shared.hapticPower = Int(roundedValue)
            ENKeyButtonEffectManager.shared.excuteHaptic(with: ENSettingManager.shared.hapticPower)
            
            if ENSettingManager.shared.hapticPower == 0 {
                switchKeyboardVibrator.isOn = false
            } else {
                switchKeyboardVibrator.isOn = true
            }
        }
    }
    
    @IBAction func switchPreviewChangeHandler(_ sender: UISwitch) {
        hideSampleView()
        ENSettingManager.shared.isKeyboardButtonValuePreviewShow = sender.isOn
    }
    
    func saveUUID() {
        ENKeyboardAPIManeger.shared.callUpdateUserInfo() { data, response, error in
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(ENUpdateUserInfoModel.self, from: jsonData)
                        //print("ENUpdateUserInfoModel result : \(data.Result)")
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }
    
    func loadData() {
        if ENSettingManager.shared.keyboardType == .qwerty {
            lblKeyboardType.text = "쿼티"
        } else if ENSettingManager.shared.keyboardType == .tenkey {
            lblKeyboardType.text = "천지인"
        } else {
            lblKeyboardType.text = "쿼티"
        }
        
        sliderHeight.value = ENSettingManager.shared.keyboardHeightRate
        
        sliderKeyboardVibrator.value = Float(ENSettingManager.shared.hapticPower)
        
        if ENSettingManager.shared.hapticPower == 0 {
            switchKeyboardVibrator.isOn = false
        } else {
            switchKeyboardVibrator.isOn = true
        }
        
        switchPreview.isOn = ENSettingManager.shared.isKeyboardButtonValuePreviewShow
        
        switch ENSettingManager.shared.soundID {
        case 0:
            self.lblKeyboardSound.text = "기본"
            break
        case 1:
            self.lblKeyboardSound.text = "뽀롱 (물방울 소리)"
            break
        case 2:
            self.lblKeyboardSound.text = "뺙뺙 (짹짹이 소리)"
            break
        case 3:
            self.lblKeyboardSound.text = "탁탁 (옛날 타자기 소리)"
            break
        default:
            self.lblKeyboardSound.text = "기본"
            break
        }
    }
    
    func settingViewMoveGesture() {
        let viewKeyboardTypeTap = UITapGestureRecognizer(target: self, action: #selector(viewMoveGesture(_:)))
        viewKeyboardType.tag = 0
        viewKeyboardType.addGestureRecognizer(viewKeyboardTypeTap)
        
        let viewKeyboardSoundTap = UITapGestureRecognizer(target: self, action: #selector(viewMoveGesture(_:)))
        viewKeyboardSound.tag = 2
        viewKeyboardSound.addGestureRecognizer(viewKeyboardSoundTap)
        
        let viewKeyboardSettingTap = UITapGestureRecognizer(target: self, action: #selector(viewMoveGesture(_:)))
        viewKeyboardSetting.tag = 3
        viewKeyboardSetting.addGestureRecognizer(viewKeyboardSettingTap)
    }
    
    @objc func viewMoveGesture(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            hideSampleView()
            switch tag {
            case 0:
                removeSampleView()
                let vc = HanaKeyboardTypeViewController.create()
                vc.delegate = self
                enPresent(vc, animated: true)
            case 1:
                print("tag : \(tag)")
            case 2:
                let vc = HanaKeyboardSoundViewController.create()
                vc.delegates = self
                self.present(vc, animated: false)
            case 3:
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    open(url: settingsURL)
                }
            default:
                print("not tag value")
            }
        }
    }
    
    func settingKeyboardSampleViewHideForOtherViewTap() {
        let viewHeaderTap = UITapGestureRecognizer(target: self, action: #selector(otherViewTap))
        viewHeader.addGestureRecognizer(viewHeaderTap)
        
        let viewKeyboardHeightTap = UITapGestureRecognizer(target: self, action: #selector(otherViewTap))
        viewKeyboardHeight.addGestureRecognizer(viewKeyboardHeightTap)
        
        let viewKeyboardVibratorTap = UITapGestureRecognizer(target: self, action: #selector(otherViewTap))
        viewKeyboardVibrator.addGestureRecognizer(viewKeyboardVibratorTap)
        
        let viewPreviewTap = UITapGestureRecognizer(target: self, action: #selector(otherViewTap))
        viewPreview.addGestureRecognizer(viewPreviewTap)
    }
    
    @objc func otherViewTap() {
        if !viewSample.isHidden {
            hideSampleView()
        }
    }
    
}

extension HanaMainViewController: HanaKeyboardSoundViewControllerDelegate {
    func soundChange() {
        switch ENSettingManager.shared.soundID {
        case 0:
            self.lblKeyboardSound.text = "기본"
            break
        case 1:
            self.lblKeyboardSound.text = "뽀롱 (물방울 소리)"
            break
        case 2:
            self.lblKeyboardSound.text = "뺙뺙 (짹짹이 소리)"
            break
        case 3:
            self.lblKeyboardSound.text = "탁탁 (옛날 타자기 소리)"
            break
        default:
            self.lblKeyboardSound.text = "기본"
            break
        }
    }
}

extension HanaMainViewController {
    func initKeyboardView() {
        if let keyboardViewManager = keyboardViewManager {
            let keyboard = keyboardViewManager.loadKeyboardView()
            
            viewSample.addSubview(keyboard)

            keyboardViewManager.isUseNotifyView = false
            
            keyboardViewManager.updateConstraints()
            keyboardViewManager.updateKeys()
            let customAreaView = ENKeyboardCustomAreaView(frame: .zero)
            
            customAreaView.removeAdViewAndDutchPayView()
            
            customAreaView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            customAreaView.isUserInteractionEnabled = true

            keyboardViewManager.initCustomArea(with: customAreaView)
            customAreaView.sizeToFit()

            customAreaView.setButtonHandler(item: customAreaView.btnArray)
            customAreaView.setScrollViewConstraint()
            
            ENSettingManager.shared.isUsePhotoTheme = false
            let currentTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
            let themeFileInfo = currentTheme.themeFileInfo()

            customAreaView.keyboardThemeModel = currentTheme

            ENKeyboardThemeManager.shared.loadTheme(theme: themeFileInfo) {[weak self] theme in
                guard let self else { return }
                keyboardViewManager.keyboardTheme = theme
            }
            
            let needHeight = (ENSettingManager.shared.getKeyboardHeight(isLandcape: false))
            constraintHeightViewSample.constant = 0
        }
    }
    
    func removeSampleView() {
        for innerView in self.viewSample.subviews {
            innerView.removeFromSuperview()
        }
        
        keyboardViewManager = nil
    }
    
    func hideSampleView() {
        constraintHeightViewSample.constant = 0.0
        viewSample.isHidden = true
    }
}

extension HanaMainViewController: HanaKeyboardTypeChangeDelegate {
    func changeKeyboardType() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if ENSettingManager.shared.keyboardType == .qwerty {
                self.lblKeyboardType.text = "쿼티"
            } else if ENSettingManager.shared.keyboardType == .tenkey {
                self.lblKeyboardType.text = "천지인"
            } else {
                self.lblKeyboardType.text = "쿼티"
            }
        }
    }
    
    func dismissHandler() {
        keyboardViewManager = ENKeyboardViewManager(proxy: nil, needsInputModeSwitchKey: false)
        initKeyboardView()
    }
}

struct ENUpdateUserInfoModel: Codable{
    let Result: String
}
