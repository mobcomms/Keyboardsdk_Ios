//
//  UserDefaults+ENKeyboardSDK.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/07/21.
//

import Foundation

import KeyboardSDKCore


extension DHUserDefaultsConstants {
    
    static let keyForClipBoard = DHUserDefaultsConstants(rawValue: "clipboard")
    static let keyForClipBoardChangeCount = DHUserDefaultsConstants(rawValue: "clipboard_change_count")
}





extension UserDefaults {
    
    func saveClipboardData(clipboard:[String]) {
        UserDefaults.enKeyboardStandard?.setValue(clipboard, forKey: DHUserDefaultsConstants.keyForClipBoard.value)
        UserDefaults.enKeyboardStandard?.synchronize()
    }
    
    
    func getSavedClipBoardData() -> [String] {
        return (UserDefaults.enKeyboardStandard?.object(forKey: DHUserDefaultsConstants.keyForClipBoard.value) as? [String]) ?? []
    }
    
    
    
    func saveLastSavedClipboardChangeCount(count:Int) {
        UserDefaults.enKeyboardStandard?.setValue(count, forKey: DHUserDefaultsConstants.keyForClipBoardChangeCount.value)
        UserDefaults.enKeyboardStandard?.synchronize()
    }
    
    
    func lastSavedClipboardChangeCount() -> Int {
        return (UserDefaults.enKeyboardStandard?.integer(forKey: DHUserDefaultsConstants.keyForClipBoardChangeCount.value)) ?? 0
    }
    
    
}
