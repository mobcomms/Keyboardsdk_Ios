//
//  ENKeyboardSDKInfo.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/04/27.
//

import Foundation
import KeyboardSDKCore

public class ENKeyboardSDKInfo {
    
    public static var version:String {
        get {
            let ver = String(cString: KeyboardSDKVersionStringPtr)
            
            guard let range = ver.range(of: "-") else {
                return ""
            }
            return String(ver[range.upperBound...]).replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
        }
    }
    
    public static var coreSDKVersion:String {
        get {
            return ENKeyboardSDKCoreInfo.version
        }
    }
    
}

