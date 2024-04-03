//
//  ENKeyboardSDK.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/05/17.
//

import Foundation
import KeyboardSDKCore
//import AppLovinSDK

public class ENKeyboardSDK {
    
    public static let shared:ENKeyboardSDK = ENKeyboardSDK()
    
    /// SDK 버전 정보 (get-only)
    public private(set) var SDK_VERSION: String = "SDK Version : 1.0.13" // 이거 무조건 바꿔야함... 전달 할때마다!!!!!
    
    let appLovinMediationProvider = "max"
    let appLovinIdentifier = "mobcomms.app@gmail.com"
    
    init() {

        sdkInit()
    }
    
    
    public func sdkInit() {
        setDebug(isDebug:false)
        DHApi.HOST = "https://api.cashkeyboard.co.kr/API"
    }
    
    public func setDebug(isDebug: Bool) {
        ENSettingManager.shared.setDebug = isDebug
    }
    
    public func isKeyboardExtensionEnabled() -> Bool {
        return ENKeyboardSDKCore.shared.isKeyboardExtensionEnabled()
    }
    
    
    @available(iOS 13.0, *)
    @available(iOSApplicationExtension 13.0, *)
    public func openByUniversalLink(url: URL, sceneDelegate: UIWindowSceneDelegate) -> Bool {
        let viewController = sceneDelegate.window??.rootViewController
        
        return openViewControllerByURL(url: url, viewController: viewController)
    }
    
    
    public func openByUniversalLink(url: URL, appDelegate: UIApplicationDelegate) -> Bool {
        let viewController = appDelegate.window??.rootViewController
        return openViewControllerByURL(url: url, viewController: viewController)
    }
    
    
    private func openViewControllerByURL(url: URL, viewController:UIViewController?) -> Bool {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let items = urlComponents?.queryItems
        
        guard let item = ((items?.count ?? 0) > 0 ? items?[0] : nil) else {
            return false
        }
        
        let path = urlComponents?.path ?? ""
        let name = item.name
        let value = item.value
        
        guard path == ENKeyboardSDKSchemeManager.path && name == "page" else {
            viewController?.view.showEnToast(message: "\(path), \(ENKeyboardSDKSchemeManager.path)")
            return false
        }
        
        
        let pageType = ENKeyboardSDKSchemePageType.init(rawValue: value ?? "") ?? .unknown
        
        switch pageType {
        case .setting:
            let vc = ENSettingViewController.create()
            openViewController(parent: viewController, open: vc)
            break
        case .KeyboardFullAccessSetting:
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                openUrl(parent: viewController, open: settingsURL)
            }
            break
        case .userMemoEdit:
            let vc = ENMainViewController.create()
            vc.isUserMemoEdit = true
            openViewController(parent: viewController, open: vc)
            return true
        case .enMainPage:
            let vc = ENMainViewController.create()
            vc.isUserMemoEdit = false
            openViewController(parent: viewController, open: vc)
            return true
        case .ppzone:
            let vc = HanaPPZWebViewController.create()
            openViewController(parent: viewController, open: vc)
            return true
        case .hanaSetting:
            let vc = HanaMainViewController.create()
            openViewController(parent: viewController, open: vc)
            return true
        case .hanaInquiry:
            let vc = HanaKeyboardInquiryViewController.create()
            openViewController(parent: viewController, open: vc)
            return true
        default:
            return false
        }

        return true
        
    }
    
    
    private func openViewController(parent:UIViewController?, open vc:UIViewController) {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if let parent = parent {
                if let presentedView = parent.presentedViewController {
                    presentedView.dismiss(animated: false) {
                        parent.present(vc, animated: false)
                    }
                } else {
                    parent.present(vc, animated: true)
                }
                
                timer.invalidate()
            }
        }
    }
    
    private func openUrl(parent:UIViewController?, open url:URL) {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if (parent?.presentationController ?? nil) != nil {
                DispatchQueue.main.async {
                    parent?.open(url: url)
                }
                
                timer.invalidate()
            }
        }
    }
    public func saveUUID(_ uuid :String) {
        ENSettingManager.shared.hanaCustomerID = uuid
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

}


public class ENKeyboardSDKSchemeManager {
    public static let scheme:String = "ENKeyboardSDK"
    
    public static var path:String {
        get {
            return "KeyboardUser"
        }
    }
    
    
    public static var settingPage:String {
        get {
            return "\(scheme)\(ENKeyboardSDKCore.shared.apiKey):\(path)?page=\(ENKeyboardSDKSchemePageType.setting.rawValue)"
        }
    }
    
    public static var fullAccessPage:String {
        get {
            return "\(scheme)\(ENKeyboardSDKCore.shared.apiKey):\(path)?page=\(ENKeyboardSDKSchemePageType.KeyboardFullAccessSetting.rawValue)"
        }
    }
    
    public static var enMainPage: String {
        get {
            return "\(scheme)\(ENKeyboardSDKCore.shared.apiKey):\(path)?page=\(ENKeyboardSDKSchemePageType.enMainPage.rawValue)"
        }
    }
    
    public static var userMemoEdit: String {
        get {
            return "\(scheme)\(ENKeyboardSDKCore.shared.apiKey):\(path)?page=\(ENKeyboardSDKSchemePageType.userMemoEdit.rawValue)"
        }
    }
    
    public static var selfApp: String {
        get {
            return "\(scheme)\(ENKeyboardSDKCore.shared.apiKey):\(path)"
        }
    }
    
    public static var ppzone: String {
        get {
            return "\(scheme)\(ENKeyboardSDKCore.shared.apiKey):\(path)?page=\(ENKeyboardSDKSchemePageType.ppzone.rawValue)"
        }
    }
    
    public static var hanaSetting: String {
        get {
            return "\(scheme)\(ENKeyboardSDKCore.shared.apiKey):\(path)?page=\(ENKeyboardSDKSchemePageType.hanaSetting.rawValue)"
        }
    }
    
    public static var hanaInquiry: String {
        get {
            return "\(scheme)\(ENKeyboardSDKCore.shared.apiKey):\(path)?page=\(ENKeyboardSDKSchemePageType.hanaInquiry.rawValue)"
        }
    }
    
}


enum ENKeyboardSDKSchemePageType: String {
    case unknown                    = "unknown"
    case setting                    = "setting"
    case KeyboardFullAccessSetting  = "KeyboardFullAccessSetting"
    case userMemoEdit               = "userMemoEdit"
    case enMainPage                 = "enMainPage"
    case openUrl                    = "openUrl"
    case selfApp                    = "selfApp"
    case ppzone                     = "ppzone"
    case hanaSetting                = "hanaSetting"
    case hanaInquiry                = "hanaInquiry"
}
