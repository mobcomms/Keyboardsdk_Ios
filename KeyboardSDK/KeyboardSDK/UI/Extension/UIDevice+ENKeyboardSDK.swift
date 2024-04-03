//
//  UIDevice+ENKeyboardSDK.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/07/07.
//

import Foundation


// 단말기 기종 확인용...
extension UIDevice {
    func getDeviceVersions() -> String {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
            case 1334:
                print("iPhone 6/6S/7/8")
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                print("iPhone X, Xs")
                return "X"
            case 2688:
                print("iPhone Xs Max")
                return "X"
            case 1792:
                print("iPhone Xr")
                return "X"
            default:
                print("unknown")
            }
        }
        
        return ""
    }
    
}
