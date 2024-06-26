//
//  HanaKeyboardTypeViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 10/26/23.
//

import Foundation
import KeyboardSDKCore

protocol HanaKeyboardTypeChangeDelegate: AnyObject {
    func changeKeyboardType()
    func dismissHandler()
}

class HanaKeyboardTypeViewController: UIViewController, ENViewPrsenter {
    public static func create() -> HanaKeyboardTypeViewController {
        let vc = HanaKeyboardTypeViewController.init(nibName: "HanaKeyboardTypeViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    var delegate: HanaKeyboardTypeChangeDelegate?
        
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var viewSelect: UIView!
    
    @IBOutlet weak var viewQwerty: UIView!
    @IBOutlet weak var imgQwerty: UIImageView!
    @IBOutlet weak var lblQwerty: UILabel!
    @IBOutlet weak var imgQwertyCheck: UIImageView!
    
    @IBOutlet weak var viewTenKey: UIView!
    @IBOutlet weak var imgTenKey: UIImageView!
    @IBOutlet weak var lblTenKey: UILabel!
    @IBOutlet weak var imgTenKeyCheck: UIImageView!
    
    @IBOutlet weak var viewSample: UIView!
    @IBOutlet weak var constraintHeightViewSample: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initKeyboardView()
        
        settingSelectHandler()
        
        updateSelectUI()
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
    
    @IBAction func btnBackHandler(_ sender: UIButton) {
        if let del = delegate {
            del.dismissHandler()
        }
        enDismiss()
    }
    
    func settingSelectHandler() {
        let viewQwertyTap = UITapGestureRecognizer(target: self, action: #selector(viewSelectGestureHandler(_:)))
        viewQwerty.tag = 0
        viewQwerty.addGestureRecognizer(viewQwertyTap)
        
        let viewTenKeyTap = UITapGestureRecognizer(target: self, action: #selector(viewSelectGestureHandler(_:)))
        viewTenKey.tag = 1
        viewTenKey.addGestureRecognizer(viewTenKeyTap)
    }
    
    @objc func viewSelectGestureHandler(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            switch tag {
            case 0:
                ENSettingManager.shared.keyboardType = .qwerty
            case 1:
                ENSettingManager.shared.keyboardType = .tenkey
            default:
                ENSettingManager.shared.keyboardType = .qwerty
            }
            
            if let del = self.delegate {
                del.changeKeyboardType()
            }
            
            updateSelectUI()
            changeKeyboard()
            saveKeyboardTypeAPI()
        }
    }
    
    func saveKeyboardTypeAPI() {
        ENKeyboardAPIManeger.shared.callSetUserInfo() { data, response, error in
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(ENSaveKeyboardTypeModel.self, from: jsonData)
                        //print("saveKeyboardTypeAPI result : \(data.result)")
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }
    
    func updateSelectUI() {
        if ENSettingManager.shared.keyboardType == .qwerty {
            imgQwerty.layer.borderWidth = 3
            imgQwerty.layer.borderColor = CGColor(red: 19/255, green: 201/255, blue: 190/255, alpha: 1)
            imgQwerty.layer.cornerRadius = 5
            lblQwerty.textColor = UIColor(red: 19/255, green: 201/255, blue: 190/255, alpha: 1)
            imgQwertyCheck.isHidden = false
            
            imgTenKey.layer.borderWidth = 0
            imgTenKey.layer.cornerRadius = 0
            lblTenKey.textColor = .black
            imgTenKeyCheck.isHidden = true
        } else if ENSettingManager.shared.keyboardType == .tenkey {
            imgTenKey.layer.borderWidth = 3
            imgTenKey.layer.borderColor = CGColor(red: 19/255, green: 201/255, blue: 190/255, alpha: 1)
            imgTenKey.layer.cornerRadius = 5
            lblTenKey.textColor = UIColor(red: 19/255, green: 201/255, blue: 190/255, alpha: 1)
            imgTenKeyCheck.isHidden = false

            imgQwerty.layer.borderWidth = 0
            imgQwerty.layer.cornerRadius = 0
            lblQwerty.textColor = .black
            imgQwertyCheck.isHidden = true
        } else {
            imgQwerty.layer.borderWidth = 3
            imgQwerty.layer.borderColor = CGColor(red: 19/255, green: 201/255, blue: 190/255, alpha: 1)
            imgQwerty.layer.cornerRadius = 5
            lblQwerty.textColor = UIColor(red: 19/255, green: 201/255, blue: 190/255, alpha: 1)
            imgQwertyCheck.isHidden = false
            
            imgTenKey.layer.borderWidth = 0
            imgTenKey.layer.cornerRadius = 0
            lblTenKey.textColor = .black
            imgTenKeyCheck.isHidden = true
        }
    }
    
}

extension HanaKeyboardTypeViewController {
    func initKeyboardView() {
        let keyboardViewManager = ENKeyboardViewManager(proxy: nil, needsInputModeSwitchKey: true)
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
        constraintHeightViewSample.constant = needHeight
    }
    
    func changeKeyboard() {
        for innerView in self.viewSample.subviews {
            innerView.removeFromSuperview()
        }
        
        initKeyboardView()
    }
}

struct ENSaveKeyboardTypeModel: Codable{
    let result: String
}
