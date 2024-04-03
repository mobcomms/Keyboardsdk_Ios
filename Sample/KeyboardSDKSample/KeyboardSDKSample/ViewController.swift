//
//  ViewController.swift
//  KeyboardSDKSample
//
//  Created by cashwalkKeyboard on 2021/05/04.
//

import UIKit
import KeyboardSDK
import KeyboardSDKCore
import AppTrackingTransparency
import AdSupport


class ViewController: UIViewController {

    var addedView:UIView? = nil
    var adid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .light
        self.navigationController?.isNavigationBarHidden = true
        print(ENKeyboardSDK.shared.isKeyboardExtensionEnabled() ? "keyboard extension active" : "keyboard extension deactive" )
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 14, *) {

            ATTrackingManager.requestTrackingAuthorization { (status) in
                switch status {
                case .authorized:
                    print("authorized")
                case .denied:
                    print("denied")
                case .notDetermined:
                    print("notDetermined")
                case .restricted:
                    print("restricted")
                @unknown default:
                    print("error")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        adid = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        if let idfa = adid {
            ENSettingManager.shared.userIdfa = idfa
        }
        
        ENKeyboardSDK.shared.saveUUID("rzWKcbVLkG6cetZVt2nChg==") //고객 아이디

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func downloadTheme(_ sender: Any) {
        
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(ENMainViewController.create(), animated: true)
        

    }
    
    @IBAction func pastedFromPastedboard(_ sender: Any) {
        ENSettingManager.shared.isFirstUser = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(ENMainViewController.create(), animated: true)

        
    }
    
    @IBAction func restore(_ sender: Any) {
        addedView?.removeFromSuperview()
    }
    
    func checkImage(dict:[String:Any]) -> UIImage? {
        for key in UIPasteboard.typeListImage {
            if let key = key as? String, let value = dict[key] {
                return value as? UIImage
            }
        }
        
        return nil
    }
    
    func checkString(dict:[String:Any]) -> String? {
        for key in UIPasteboard.typeListString {
            if let key = key as? String, let value = dict[key] {
                return value as? String
            }
        }
        
        return nil
    }
    
    func checkURL(dict:[String:Any]) -> URL? {
        for key in UIPasteboard.typeListURL {
            if let key = key as? String, let value = dict[key] {
                return value as? URL
            }
        }
        
        return nil
    }
    
    func checkColor(dict:[String:Any]) -> UIColor? {
        for key in UIPasteboard.typeListColor {
            if let key = key as? String, let value = dict[key] {
                return value as? UIColor
            }
        }
        
        return nil
    }
}

