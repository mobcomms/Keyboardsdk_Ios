//
//  UserDefaults+KeyboardSDK.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/28.
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
    
    func updateMiniSayBannerViewShow() {
        let calender = Calendar.current
        let today = calender.startOfDay(for: Date())
        if let tomorrow = calender.date(byAdding: .day, value: 1, to: today) {
            setValue(tomorrow, forKey: ENKeyboardSDKUserDefaultsConstants.keyMiniSayBannerViewShow.rawValue)
            self.synchronize()
        }
    }
    
    
    func willShowMiniSayBannerView() -> Bool {
        guard let saved = value(forKey: ENKeyboardSDKUserDefaultsConstants.keyMiniSayBannerViewShow.rawValue) as? Date else {
            return true
        }
        
        let today = Date()
        
        return saved.timeIntervalSince1970 < today.timeIntervalSince1970
    }
    
    
}
