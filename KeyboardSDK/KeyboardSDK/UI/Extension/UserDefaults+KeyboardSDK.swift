//
//  UserDefaults+KeyboardSDK.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/06/28.
//

import Foundation
import KeyboardSDKCore

enum ENKeyboardSDKUserDefaultsConstants: String {
    
    case keyMiniSayBannerViewShow                    = "keyForMiniSayBannerViewShow"
    
    
    /// 키 값을 string value로 변경하여 반환한다.
    var value: String {
        return "ENKeyboardSDK_UserDefaults_\(self.rawValue)__"
    };
}

extension UserDefaults {
    
    
    
}
