//
//  ENKeyboardSelectViewController.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/31.
//

import Foundation
import KeyboardSDKCore

class ENKeyboardSelectViewController: UIViewController, ENViewPrsenter {
    
    public static func create() -> ENKeyboardSelectViewController {
        let vc = ENKeyboardSelectViewController.init(nibName: "ENKeyboardSelectViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    // MARK: 헤더 버튼
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnKeyboardShowHide: UIButton!
    
    // MARK: 키보드 타입 관련 View
    @IBOutlet weak var viewQwety: UIView!
    @IBOutlet weak var viewTenkey: UIView!
    @IBOutlet weak var imgQwety: UIImageView!
    @IBOutlet weak var imgTenkey: UIImageView!
    @IBOutlet weak var lblQwety: UILabel!
    @IBOutlet weak var lblTenkey: UILabel!
    
    // MARK: 안씀
    @IBOutlet weak var textFieldTemp: UITextField!
    
    // MARK: 키보드 샘플 View
    @IBOutlet weak var keyboardSampleView: UIView!
    @IBOutlet weak var keyboardSampleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    
    // MARK: 메인 화면에 연결된 Delegate
    weak var eNMainViewControllerDelegate: ENMainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 백버튼 핸들러 연결
        btnBack.addTarget(self, action: #selector(btnBackHandler(_:)), for: .touchUpInside)
        
        // 키보드 유무 버튼 핸들러 연결
        btnKeyboardShowHide.addTarget(self, action: #selector(btnKeyboardShowHideHandler(_:)), for: .touchUpInside)
        
        // 쿼티, 천지인 view 클릭을 위한 gesture 생성
        let qwetyHandler = UITapGestureRecognizer(target: self, action: #selector(qwetyHandler(_:)))
        let tenkeyHandler = UITapGestureRecognizer(target: self, action: #selector(tenkeyHandler(_:)))
        
        // 쿼티, 천지인 view 클릭을 위한 gesture 연결
        viewQwety.addGestureRecognizer(qwetyHandler)
        viewTenkey.addGestureRecognizer(tenkeyHandler)
        
        // 기본 타입에 따라 보여질 view 의 init
        if ENSettingManager.shared.keyboardType == .qwerty {
            imgQwety.layer.borderWidth = 3
            imgQwety.layer.borderColor = CGColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            imgQwety.layer.cornerRadius = 5
            
            lblQwety.textColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
        } else if ENSettingManager.shared.keyboardType == .tenkey {
            imgTenkey.layer.borderWidth = 3
            imgTenkey.layer.borderColor = CGColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            imgTenkey.layer.cornerRadius = 5
            
            lblTenkey.textColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
        } else {
            imgQwety.layer.borderWidth = 3
            imgQwety.layer.borderColor = CGColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            imgQwety.layer.cornerRadius = 5
            
            lblQwety.textColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
        }
        
        // 키보드 샘플 뷰 로드
        initKeyboardView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func btnBackHandler(_ sender: UIButton) {
        enDismiss(completion: { [weak self] in
            guard let self else { return }
            if let delegates = self.eNMainViewControllerDelegate {
                delegates.defaultTableViewReloadDelegate()
            }
        })
    }
    
    @objc func btnKeyboardShowHideHandler(_ sender: UIButton) {
        if keyboardSampleViewHeight.constant == 0 {
            UIView.transition(with: self.btnKeyboardShowHide, duration: 0.2, options: .transitionFlipFromBottom, animations: { [weak self] in
                guard let self else { return }
                self.btnKeyboardShowHide.setImage(UIImage.init(named: "header_keyboard_down", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
            })
            
            self.keyboardSampleView.isHidden = false
            
            let needHeight = (ENSettingManager.shared.getKeyboardHeight(isLandcape: false))
            self.keyboardSampleViewHeight.constant = needHeight
            
        } else {
            UIView.transition(with: self.btnKeyboardShowHide, duration: 0.2, options: .transitionFlipFromTop, animations: { [weak self] in
                guard let self else { return }
                self.btnKeyboardShowHide.setImage(UIImage.init(named: "header_keyboard_up", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
            })
            self.keyboardSampleViewHeight.constant = 0
            
            self.keyboardSampleView.isHidden = true
        }
        
    }
    
    @objc func qwetyHandler(_ sender: UITapGestureRecognizer) {
        if UserDefaults.enKeyboardGroupStandard?.getKeyboardType() == ENKeyboardType.tenkey {
            UserDefaults.enKeyboardGroupStandard?.setKeyboardType(ENKeyboardType.qwerty)
            changeKeyboard()
            
            imgQwety.layer.borderWidth = 3
            imgQwety.layer.borderColor = CGColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            imgQwety.layer.cornerRadius = 5
            lblQwety.textColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            
            imgTenkey.layer.borderWidth = 0
            imgTenkey.layer.cornerRadius = 0
            lblTenkey.textColor = .black
        }
    }
    
    @objc func tenkeyHandler(_ sender: UITapGestureRecognizer) {
        if UserDefaults.enKeyboardGroupStandard?.getKeyboardType() == ENKeyboardType.qwerty {
            UserDefaults.enKeyboardGroupStandard?.setKeyboardType(ENKeyboardType.tenkey)
            changeKeyboard()
            
            imgTenkey.layer.borderWidth = 3
            imgTenkey.layer.borderColor = CGColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            imgTenkey.layer.cornerRadius = 5
            lblTenkey.textColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)

            imgQwety.layer.borderWidth = 0
            imgQwety.layer.cornerRadius = 0
            lblQwety.textColor = .black
            
        }
    }
}

extension ENKeyboardSelectViewController {

    func initKeyboardView() {
        let keyboardViewManager = ENKeyboardViewManager(proxy: nil, needsInputModeSwitchKey: true)
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

        ENKeyboardThemeManager.shared.loadTheme(theme: themeFileInfo) { theme in
            keyboardViewManager.keyboardTheme = theme
        }
        
        let needHeight = (ENSettingManager.shared.getKeyboardHeight(isLandcape: false))
        self.keyboardSampleViewHeight.constant = needHeight
    }

    func changeKeyboard() {
        for innerView in self.keyboardSampleView.subviews {
            innerView.removeFromSuperview()
        }
        
        initKeyboardView()
        
        if self.keyboardSampleView.isHidden == true {
            UIView.transition(with: self.btnKeyboardShowHide, duration: 0.2, options: .transitionFlipFromBottom, animations: { [weak self] in
                guard let self else { return }
                self.btnKeyboardShowHide.setImage(UIImage.init(named: "header_keyboard_down", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
            })
            self.keyboardSampleView.isHidden = false
        }
    }

}
