//
//  ENKeyboardSDK.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/05/17.
//

import Foundation
import KeyboardSDKCore
//import AppLovinSDK

public class ENKeyboardSDK {
    
    public static let shared:ENKeyboardSDK = ENKeyboardSDK()
    
    /// SDK 버전 정보 (get-only)
    public private(set) var SDK_VERSION: String = "SDK Version : 1.0.13"
    
    let appLovinMediationProvider = "max"
    let appLovinIdentifier = "mobcomms.app@gmail.com"
    
    init() {

        sdkInit()
    }
    
    
    public func sdkInit() {
        setDebug(isDebug:false)
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
        case .KeyboardFullAccessSetting:
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                openUrl(parent: viewController, open: settingsURL)
            }
            break
        case .ppzone:
            let vc = ENPPZWebViewController.create()
            openViewController(parent: viewController, open: vc)
            return true
        case .keyboardSetting:
            let vc = ENMainViewController.create()
            openViewController(parent: viewController, open: vc)
            return true
        case .keyboardCashDeal:
            let vc = ENMainViewController.create()
            openViewController(parent: viewController, open: vc)
            return true
        case .keyboardInquiry:
            let vc = ENKeyboardInquiryViewController.create()
            openViewController(parent: viewController, open: vc)
            return true
        case .theme:
            let vc = ENNewThemeManagerViewController.create()
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
        ENSettingManager.shared.customerID = uuid
        ENKeyboardAPIManeger.shared.callUpdateUserInfo() { data, response, error in
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(ENUpdateUserInfoModel.self, from: jsonData)
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }

}


public class ENKeyboardSDKSchemeManager {
    public static let scheme:String = "CashwalkKeyboardSDK"
    
    public static var path:String {
        get {
            return "KeyboardUser"
        }
    }
    
    
    
    public static var fullAccessPage:String {
        get {
            return "\(scheme)\(ENKeyboardSDKCore.shared.apiKey):\(path)?page=\(ENKeyboardSDKSchemePageType.KeyboardFullAccessSetting.rawValue)"
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
    
    public static var keyboardSetting: String {
        get {
            return "\(scheme)\(ENKeyboardSDKCore.shared.apiKey):\(path)?page=\(ENKeyboardSDKSchemePageType.keyboardSetting.rawValue)"
        }
    }
    public static var keyboardCashDeal: String {
        get {
            return "\(scheme)\(ENKeyboardSDKCore.shared.apiKey):\(path)?page=\(ENKeyboardSDKSchemePageType.keyboardCashDeal.rawValue)"
        }
    }

    public static var keyboardInquiry: String {
        get {
            return "\(scheme)\(ENKeyboardSDKCore.shared.apiKey):\(path)?page=\(ENKeyboardSDKSchemePageType.keyboardInquiry.rawValue)"
        }
    }
    public static var theme: String {
        get {
            return "\(scheme)\(ENKeyboardSDKCore.shared.apiKey):\(path)?page=\(ENKeyboardSDKSchemePageType.theme.rawValue)"
        }
    }
}


enum ENKeyboardSDKSchemePageType: String {
    case unknown                    = "unknown"
    case KeyboardFullAccessSetting  = "KeyboardFullAccessSetting"
    case openUrl                    = "openUrl"
    case selfApp                    = "selfApp"
    case ppzone                     = "ppzone"
    case keyboardSetting            = "keyboardSetting"
    case keyboardCashDeal           = "keyboardCashDeal"
    case keyboardInquiry            = "keyboardInquiry"
    case theme                      = "theme"

}
