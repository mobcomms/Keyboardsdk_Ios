//
//  ENKeyboardSoundViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/05.
//

import Foundation
import KeyboardSDKCore

public class ENKeyboardSoundViewController: UIViewController, ENViewPrsenter {
    
    public static func create() -> ENKeyboardSoundViewController {
        let vc = ENKeyboardSoundViewController.init(nibName: "ENKeyboardSoundViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    @IBOutlet weak var viewOpacity: UIView!
    @IBOutlet weak var viewWrapper: UIView!
    @IBOutlet weak var viewSound1: UIView!
    @IBOutlet weak var imgSound1: UIImageView!
    
    @IBOutlet weak var viewSound2: UIView!
    @IBOutlet weak var imgSound2: UIImageView!
    
    @IBOutlet weak var viewSound3: UIView!
    @IBOutlet weak var imgSound3: UIImageView!
    
    @IBOutlet weak var viewSound4: UIView!
    @IBOutlet weak var imgSound4: UIImageView!
    
    @IBOutlet weak var viewSound5: UIView!
    @IBOutlet weak var imgSound5: UIImageView!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    var selectValue: Int = 0
    
    weak var eNMainViewControllerDelegate: ENMainViewControllerDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if ENSettingManager.shared.useSound == false {
            showErrorMessage(message: "전체 접근 권한을 허용해 주어야\n키보드에서 소리기능이 활성화 됩니다.")
            ENSettingManager.shared.useSound = true
        }
        
        viewOpacity.backgroundColor = .clear
        
        settingUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for inners in self.view.subviews {
            inners.removeFromSuperview()
        }
    }
    
    private func settingUI() {
        viewWrapper.popupEffect()
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))

        viewSound1.addGestureRecognizer(tap1)
        viewSound2.addGestureRecognizer(tap2)
        viewSound3.addGestureRecognizer(tap3)
        viewSound4.addGestureRecognizer(tap4)
        viewSound5.addGestureRecognizer(tap5)

        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(opacityViewHandler(_:)))
        viewOpacity.addGestureRecognizer(dismissTap)
        
        btnConfirm.layer.cornerRadius = 12
        btnConfirm.addTarget(self, action: #selector(btnConfirmHandler(_:)), for: .touchUpInside)
        
        switch ENSettingManager.shared.soundID {
        case 0:
            imgSound1.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case 1:
            imgSound2.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case 2:
            imgSound3.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case 3:
            imgSound4.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case 4:
            imgSound4.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        default:
            imgSound1.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        }
    }
    
    private func resetImg() {
        imgSound1.image = UIImage.init(named: "sound_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)
        imgSound2.image = UIImage.init(named: "sound_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)
        imgSound3.image = UIImage.init(named: "sound_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)
        imgSound4.image = UIImage.init(named: "sound_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)
        imgSound5.image = UIImage.init(named: "sound_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)

    }
    
    private func changeImg(targetView: UIImageView, targetValue: Int) {
        selectValue = targetValue
        UIView.transition(with: targetView, duration: 0.2, options: .curveEaseIn, animations: {
            targetView.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
        })
        
        ENKeyButtonEffectManager.shared.excuteSound(with: selectValue)
    }
    
    @objc func btnConfirmHandler(_ sender: UIButton) {
        print("selectValue: \(selectValue)")
        
        ENSettingManager.shared.soundID = selectValue
        
        enDismiss(completion: { [weak self] in
            guard let self else { return }
            if let delegates = self.eNMainViewControllerDelegate {
                delegates.defaultTableViewReloadDelegate()
            }
        })
    }
    
    @objc func opacityViewHandler(_ sender: UITapGestureRecognizer) {
        enDismiss(completion: { [weak self] in
            guard let self else { return }
            if let delegates = self.eNMainViewControllerDelegate {
                delegates.defaultTableViewReloadDelegate()
            }
        })
    }
    
    @objc func tapHandler(_ sender: UITapGestureRecognizer) {
        resetImg()
        
        if let innerView = sender.view {
            switch innerView.tag {
            case 0:
                changeImg(targetView: imgSound1, targetValue: innerView.tag)
                break
            case 1:
                changeImg(targetView: imgSound2, targetValue: innerView.tag)
                break
            case 2:
                changeImg(targetView: imgSound3, targetValue: innerView.tag)
                break
            case 3:
                changeImg(targetView: imgSound4, targetValue: innerView.tag)
                break
            case 4:
                changeImg(targetView: imgSound5, targetValue: innerView.tag)
                break
            default:
                changeImg(targetView: imgSound1, targetValue: 0)
                break
            }
        }
    }
}
