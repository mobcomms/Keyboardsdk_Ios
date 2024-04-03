//
//  ENKeyboardVibrateViewController.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/31.
//

import Foundation
import KeyboardSDKCore

class ENKeyboardVibrateViewController: UIViewController, ENViewPrsenter {
    
    public static func create() -> ENKeyboardVibrateViewController {
        let vc = ENKeyboardVibrateViewController.init(nibName: "ENKeyboardVibrateViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    @IBOutlet weak var viewWrapper: UIView!
    @IBOutlet weak var viewOpacity: UIView!
    @IBOutlet weak var btnVeryWeak: UIButton!
    @IBOutlet weak var btnWeak: UIButton!
    @IBOutlet weak var btnStrong: UIButton!
    @IBOutlet weak var btnVeryStrong: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var wrapperViewHeightConstraint: NSLayoutConstraint!
    
    var selectValue: Int = -1
    
    weak var eNMainViewControllerDelegate: ENMainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        viewOpacity.addGestureRecognizer(tap)

        if ENSettingManager.shared.useHaptic == false {
            showErrorMessage(message: "전체 접근 권한을 허용해 주어야\n키보드에서 진동기능이 활성화 됩니다.")
            ENSettingManager.shared.useHaptic = true
        }
        
        viewOpacity.backgroundColor = .clear
        
        settingUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func settingUI() {
        btnVeryWeak.layer.cornerRadius = btnVeryWeak.frame.width / 2
        btnWeak.layer.cornerRadius = btnWeak.frame.width / 2
        btnStrong.layer.cornerRadius = btnStrong.frame.width / 2
        btnVeryStrong.layer.cornerRadius = btnVeryStrong.frame.width / 2
        
        btnVeryWeak.addTarget(self, action: #selector(vibrateButtonHandler(_:)), for: .touchUpInside)
        btnWeak.addTarget(self, action: #selector(vibrateButtonHandler(_:)), for: .touchUpInside)
        btnStrong.addTarget(self, action: #selector(vibrateButtonHandler(_:)), for: .touchUpInside)
        btnVeryStrong.addTarget(self, action: #selector(vibrateButtonHandler(_:)), for: .touchUpInside)
        
        btnConfirm.addTarget(self, action: #selector(btnConfirmHandler(_:)), for: .touchUpInside)
        
        btnConfirm.layer.cornerRadius = 12
        
        viewWrapper.popupEffect()
        
        switch ENSettingManager.shared.hapticPower {
        case 0:
            btnVeryWeak.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            btnVeryWeak.setTitleColor(.white, for: .normal)
            selectValue = ENSettingManager.shared.hapticPower
            break
        case 1:
            btnWeak.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            btnWeak.setTitleColor(.white, for: .normal)
            selectValue = ENSettingManager.shared.hapticPower
            break
        case 2:
            btnStrong.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            btnStrong.setTitleColor(.white, for: .normal)
            selectValue = ENSettingManager.shared.hapticPower
            break
        case 3:
            btnVeryStrong.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            btnVeryStrong.setTitleColor(.white, for: .normal)
            selectValue = ENSettingManager.shared.hapticPower
            break
        default:
            btnVeryWeak.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            btnVeryWeak.setTitleColor(.white, for: .normal)
            ENSettingManager.shared.hapticPower = 0
            selectValue = ENSettingManager.shared.hapticPower
            break
        }
    }
    
    private func resetButton() {
        btnVeryWeak.backgroundColor = UIColor(red: 241/255, green: 244/255, blue: 245/255, alpha: 1)
        btnVeryWeak.setTitleColor(.black, for: .normal)
        
        btnWeak.backgroundColor = UIColor(red: 241/255, green: 244/255, blue: 245/255, alpha: 1)
        btnWeak.setTitleColor(.black, for: .normal)
        
        btnStrong.backgroundColor = UIColor(red: 241/255, green: 244/255, blue: 245/255, alpha: 1)
        btnStrong.setTitleColor(.black, for: .normal)
        
        btnVeryStrong.backgroundColor = UIColor(red: 241/255, green: 244/255, blue: 245/255, alpha: 1)
        btnVeryStrong.setTitleColor(.black, for: .normal)
    }
    
    @objc func btnConfirmHandler(_ sender: UIButton) {
        ENSettingManager.shared.hapticPower = selectValue
        enDismiss(completion: { [weak self] in
            guard let self else { return }
            if let delegates = self.eNMainViewControllerDelegate {
                delegates.defaultTableViewReloadDelegate()
            }
        })
    }
    
    @objc func tapHandler(_ sender: UITapGestureRecognizer) {
        enDismiss(completion: { [weak self] in
            guard let self else { return }
            if let delegates = self.eNMainViewControllerDelegate {
                delegates.defaultTableViewReloadDelegate()
            }
        })
    }
    
    @objc func vibrateButtonHandler(_ sender: UIButton) {
        resetButton()
        
        switch sender.tag {
        case 0:
            btnVeryWeak.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            btnVeryWeak.setTitleColor(.white, for: .normal)
            selectValue = sender.tag
            break
        case 1:
            btnWeak.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            btnWeak.setTitleColor(.white, for: .normal)
            selectValue = sender.tag
            break
        case 2:
            btnStrong.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            btnStrong.setTitleColor(.white, for: .normal)
            selectValue = sender.tag
            break
        case 3:
            btnVeryStrong.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            btnVeryStrong.setTitleColor(.white, for: .normal)
            selectValue = sender.tag
            break
        default:
            selectValue = 0
            break
        }
        
        ENKeyButtonEffectManager.shared.excuteHaptic(with: selectValue)
    }
}

extension UIView {
    func popupEffect() {
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 10, height: 0)
        self.layer.shadowRadius = 200
        self.layer.masksToBounds = false
    }
}
