//
//  ENKeyboardHeightViewController.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/31.
//

import Foundation
import KeyboardSDKCore

class ENKeyboardHeightViewController: UIViewController, ENViewPrsenter {
    
    public static func create() -> ENKeyboardHeightViewController {
        let vc = ENKeyboardHeightViewController.init(nibName: "ENKeyboardHeightViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    // MARK: 키보드 샘플 뷰 관련 변수
    let keyboardViewManager = ENKeyboardViewManager(proxy: nil, needsInputModeSwitchKey: true)
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnKeyboardShowHide: UIButton!
    @IBOutlet weak var lblHeightValue: UILabel!
    @IBOutlet weak var sliderHeight: UISlider!
    @IBOutlet weak var keyboardSampleView: UIView!
    @IBOutlet weak var keyboardSampleViewHeight: NSLayoutConstraint!
    
    weak var eNMainViewControllerDelegate: ENMainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.addTarget(self, action: #selector(btnBackHandler(_:)), for: .touchUpInside)
        
        btnKeyboardShowHide.isHidden = true
        
        initKeyboardView()
        
        var height = 100 + ENSettingManager.shared.keyboardHeightRate - 20
        
        lblHeightValue.text = "\(Int(height))%"
        
        sliderHeight.minimumValue = 0
        sliderHeight.maximumValue = 40

        sliderHeight.value = ENSettingManager.shared.keyboardHeightRate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func sliderChangeHandler(_ sender: UISlider) {
        print(sender.value)
        let roundedValue = round(sender.value / 1) * 1
        
        if roundedValue != sender.value {
            sender.value = roundedValue
        }
        
        ENSettingManager.shared.keyboardHeightRate = roundedValue
        lblHeightValue.text = "\(100 + Int(roundedValue - 20))%"
        
        keyboardViewManager.updateKeyboardHeight(isLand: false)
        
        let changeHeigt = ENSettingManager.shared.getKeyboardHeight(isLandcape: false)
        self.keyboardSampleViewHeight.constant = changeHeigt
    }
    
    @objc func btnBackHandler(_ sender: UIButton) {
        enDismiss(completion: { [weak self] in
            guard let self else { return }
            if let delegates = self.eNMainViewControllerDelegate {
                delegates.defaultTableViewReloadDelegate()
            }
        })
    }
}

extension ENKeyboardHeightViewController {

    func initKeyboardView() {
        let keyboard = keyboardViewManager.loadKeyboardView()
        
        self.keyboardSampleView.addSubview(keyboard)

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
            self.keyboardViewManager.keyboardTheme = theme
        }
        
        let needHeight = (ENSettingManager.shared.getKeyboardHeight(isLandcape: false))
        self.keyboardSampleViewHeight.constant = needHeight
    }
}
