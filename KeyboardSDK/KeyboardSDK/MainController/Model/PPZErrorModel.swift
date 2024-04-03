//
//  PPZErrorModel.swift
//  KeyboardSDK
//
//  Created by ximAir on 11/21/23.
//

import Foundation
import KeyboardSDKCore

public struct PPZErrorModel: Codable, DHCodable {
    // 에러 코드
    var result: Int?
    // 에러 메세지
    var msg: String?
    
    private enum CodingKeys: String, CodingKey {
        case result = "result"
        case msg = "msg"
    }
}
