//
//  PPZTokenModel.swift
//  KeyboardSDK
//
//  Created by ximAir on 11/21/23.
//

import Foundation
import KeyboardSDKCore

struct PPZTokenModel: Codable{
    // 성공 코드 : 0
    let result: Int
    // 성공 시 토큰
    let token: String
}
