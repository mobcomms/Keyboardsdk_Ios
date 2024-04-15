//
//  ViewController.swift
//  KeyboardSDKSample
//
//  Created by enlipleIOS1 on 2021/05/04.
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
//        ENTutorialViewController.showTutorialIfNeed(parent: self)
        // let main = ENMainViewController.create()
        // self.navigationController?.pushViewController(main, animated: true)
        
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
        
//        ENKeyboardSDK.shared.saveUUID("5XRNRyUoG4Eifg21Od0kQA==")

//        ENKeyboardSDK.shared.saveUUID("oNV6SI330ASUXJwGciHidw==")

        ENKeyboardSDK.shared.saveUUID("rzWKcbVLkG6cetZVt2nChg==") //재민 아이디
        

//        ENKeyboardSDK.shared.setDebug(isDebug: true)
        
//        let hanaMain = HanaMainViewController.create()
//        self.navigationController?.pushViewController(hanaMain, animated: true)
//        
//        let testMain = HanaPPZWebViewController.create()
//        self.navigationController?.pushViewController(testMain, animated: true)
        test()
    }
    func test(){
        let jsonString = "{\"Result\":\"true\",\"total_point\":0,\"result_message\":\"1P \\uc801\\ub9bd \\uc644\\ub8cc!\"}"
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                print("send_point json parse success !!!")

                let data = try JSONDecoder().decode(ENSendPointModel.self, from: jsonData)
                
                print("send_point json parse success  --  1")

                DispatchQueue.main.async {
                    if data.total_point ?? -1 >= 0 {
                        print("send_point json parse success  --  2")

                        
                    }
                    if data.Result == "false" {
                        print("send_point json parse success  --  5")

                        
                    }
                }
                
            } catch {
                print("send_point json parse error")
                
            }
        }
    }
    
    struct ENSendPointModel: Codable {
        let Result: String
        let total_point: Int?
        let errcode: Int?
        let result_message: String?
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func moveGameZone(_ sender: Any) {
                let testMain = GameZoneViewController.create()  
                self.navigationController?.pushViewController(testMain, animated: true)

    }

    @IBAction func downloadTheme(_ sender: Any) {
        
//        let vc = ENMainViewController.create()
//        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.pushViewController(vc, animated: true)
        ENKeyboardSDK.shared.saveUUID("rzWKcbVLkG6cetZVt2nChg==") //재민 아이디

        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(HanaMainViewController.create(), animated: true)

    }
    
    @IBAction func pastedFromPastedboard(_ sender: Any) {
        addedView?.removeFromSuperview()

        for dict in UIPasteboard.general.items {
            if let image = checkImage(dict: dict) {
                let imageView = UIImageView.init(image: image)
                imageView.frame = CGRect(x: 13.0, y: 50.0, width: UIScreen.main.bounds.width - 26.0, height: 290.0)
                imageView.backgroundColor = .black
                imageView.contentMode = .scaleAspectFit

                self.view.addSubview(imageView)
                addedView = imageView
            }
            else if let string = checkString(dict: dict) {
                let label = UILabel.init()
                label.frame = CGRect(x: 13.0, y: 50.0, width: UIScreen.main.bounds.width - 26.0, height: 290.0)
                label.backgroundColor = .black
                label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
                label.textColor = .white
                label.text = string

                self.view.addSubview(label)
                addedView = label
            }
            else if let url = checkURL(dict: dict) {
                let label = UILabel.init()
                label.frame = CGRect(x: 13.0, y: 50.0, width: UIScreen.main.bounds.width - 26.0, height: 290.0)
                label.backgroundColor = .blue
                label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
                label.textColor = .white
                label.text = url.absoluteString

                self.view.addSubview(label)
                addedView = label
            }
            else if let color = checkColor(dict: dict) {
                let label = UILabel.init()
                label.frame = CGRect(x: 13.0, y: 50.0, width: UIScreen.main.bounds.width - 26.0, height: 290.0)
                label.backgroundColor = color
                label.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
                label.textAlignment = .center
                label.textColor = .black
                label.text = "색상 붙여넣기!!"

                self.view.addSubview(label)
                addedView = label
            }
        }
        
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

