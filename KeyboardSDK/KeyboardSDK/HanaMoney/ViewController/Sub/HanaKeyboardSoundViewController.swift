//
//  HanaKeyboardSoundViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 10/26/23.
//

import Foundation
import KeyboardSDKCore

protocol HanaKeyboardSoundViewControllerDelegate {
    func soundChange()
}

class HanaKeyboardSoundViewController: UIViewController, ENViewPrsenter {
    public static func create() -> HanaKeyboardSoundViewController {
        let vc = HanaKeyboardSoundViewController.init(nibName: "HanaKeyboardSoundViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    var delegates: HanaKeyboardSoundViewControllerDelegate?
    
    @IBOutlet weak var viewOpacity: UIView!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var viewDefaultSound: UIView!
    @IBOutlet weak var imgDefaultSoundCheck: UIImageView!
    
    @IBOutlet weak var viewSecondSound: UIView!
    @IBOutlet weak var imgSecondSoundCheck: UIImageView!
    
    @IBOutlet weak var viewThirdSound: UIView!
    @IBOutlet weak var imgThirdSoundCheck: UIImageView!
    
    @IBOutlet weak var viewFourSound: UIView!
    @IBOutlet weak var imgFourSoundCheck: UIImageView!
    
    @IBOutlet weak var viewFiveSound: UIView!
    @IBOutlet weak var imgFiveSoundCheck: UIImageView!

    var selectValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewContent.layer.cornerRadius = 12
        
        if ENSettingManager.shared.useSound == false {
            showErrorMessage(message: "전체 접근 권한을 허용해 주어야\n키보드에서 소리기능이 활성화 됩니다.")
            ENSettingManager.shared.useSound = true
        }
        
        settingViewGestureHandler()
        
        switch ENSettingManager.shared.soundID {
        case 0:
            imgDefaultSoundCheck.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case 1:
            imgSecondSoundCheck.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case 2:
            imgThirdSoundCheck.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case 3:
            imgFourSoundCheck.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case 99:
            imgFiveSoundCheck.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            break

        default:
            imgDefaultSoundCheck.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func btnConfirmHandler(_ sender: UIButton) {
        ENSettingManager.shared.soundID = selectValue
        if let delegates = delegates {
            delegates.soundChange()
        }
        self.dismiss(animated: false)
    }
    
    @IBAction func btnCancelHandler(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    func resetImage() {
        imgDefaultSoundCheck.image = UIImage.init(named: "sound_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)
        imgSecondSoundCheck.image = UIImage.init(named: "sound_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)
        imgThirdSoundCheck.image = UIImage.init(named: "sound_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)
        imgFourSoundCheck.image = UIImage.init(named: "sound_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)
        imgFiveSoundCheck.image = UIImage.init(named: "sound_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)

    }
    
    func settingViewGestureHandler() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))

        viewDefaultSound.tag = 0
        viewDefaultSound.addGestureRecognizer(tap1)
        
        viewSecondSound.tag = 1
        viewSecondSound.addGestureRecognizer(tap2)
        
        viewThirdSound.tag = 2
        viewThirdSound.addGestureRecognizer(tap3)
        
        viewFourSound.tag = 3
        viewFourSound.addGestureRecognizer(tap4)
        
        viewFiveSound.tag = 99
        viewFiveSound.addGestureRecognizer(tap5)

    }
    
    @objc func tapHandler(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            resetImage()
            switch tag {
            case 0:
                changeImg(targetView: imgDefaultSoundCheck, targetValue: tag)
            case 1:
                changeImg(targetView: imgSecondSoundCheck, targetValue: tag)
            case 2:
                changeImg(targetView: imgThirdSoundCheck, targetValue: tag)
            case 3:
                changeImg(targetView: imgFourSoundCheck, targetValue: tag)
            case 99:
                changeImg(targetView: imgFiveSoundCheck, targetValue: tag)
            default:
                changeImg(targetView: imgDefaultSoundCheck, targetValue: 0)
            }
        }
    }
    
    private func changeImg(targetView: UIImageView, targetValue: Int) {
        selectValue = targetValue
        UIView.transition(with: targetView, duration: 0.2, options: .curveEaseIn, animations: {
            targetView.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
        })
            ENKeyButtonEffectManager.shared.excuteSound(with: selectValue)
        
    }
    
}
