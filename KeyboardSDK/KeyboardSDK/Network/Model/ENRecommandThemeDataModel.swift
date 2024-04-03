//
//  ENRecommandThemeDataModel.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/21.
//

import Foundation
import KeyboardSDKCore

public struct ENRecommandThemeDataModel: Codable, DHCodable {
    
    //성공시 포함
    public var theme_recommend: [ENKeyboardThemeModel]?          //오늘의 추천테마
    public var theme_favor: [ENKeyboardThemeModel]?         //오늘의 인기테마
    
    
    private enum CodingKeys: String, CodingKey {
        case theme_recommend = "theme_recommend"
        case theme_favor = "theme_favor"
    }
    
}
