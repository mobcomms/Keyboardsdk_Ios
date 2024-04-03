//
//  Bundle+ENKeyboardSDK.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/05/20.
//

import Foundation


extension Bundle {
    
    
    /// 프레임워크의  Bundle을 가져온다. 프레임워크내 추가된 리소스 파일들에 접근하기 위함.
    static let frameworkBundle:Bundle = {
        return Bundle.init(for: ENKeyboardSDK.self)
    }()
    
    
}
