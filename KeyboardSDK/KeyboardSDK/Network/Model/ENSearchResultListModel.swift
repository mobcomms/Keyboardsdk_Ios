//
//  ENSearchResultListModel.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/12.
//

import Foundation
import KeyboardSDKCore

public struct ENSearchResultListModel: Codable, DHCodable {
    
    //성공시 포함
    public var data: [ENKeyboardThemeModel]?
    public var recentList: [ENKeywordModel]?
    public var mostList: [ENKeywordModel]?
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
        case recentList = "recent_keyword"
        case mostList = "most_keyword"
    }
    
}
