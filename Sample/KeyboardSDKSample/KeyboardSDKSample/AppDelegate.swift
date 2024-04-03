//
//  AppDelegate.swift
//  KeyboardSDKSample
//
//  Created by enlipleIOS1 on 2021/05/04.
//

import UIKit
import KeyboardSDK



@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let groupID: String = "group.enkeyboardsdk.sample"
    let apiKey: String = "123"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        ENKeyboardSDK.shared.sdkInit(apiKey: apiKey, groupId: groupID)
        
        // 개발 서버 or 사용 서버 구분 할 수 있는 값
        // true => 개발 서버
        // false => 상용 서버
//        ENKeyboardSDK.shared.setDebug(isDebug: false)
        
        // SDK Version 확인
        print(ENKeyboardSDK.shared.SDK_VERSION)

        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let success = ENKeyboardSDK.shared.openByUniversalLink(url: url, appDelegate: self)
        
        return success
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }

}

