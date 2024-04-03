//
//  ENKeywordListModel.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/07.
//

import Foundation
import KeyboardSDKCore


public struct ENKeywordListModel: Codable, DHCodable {
    
    //성공시 포함
    public var recentList: [ENKeywordModel]?
    public var mostList: [ENKeywordModel]?
    
    private enum CodingKeys: String, CodingKey {
        case recentList = "recent_keyword"
        case mostList = "most_keyword"
    }
}



public struct ENKeywordModel: Codable, DHCodable {
    
    //성공시 포함
    public var idx: String?
    public var word: String?
    
    private enum CodingKeys: String, CodingKey {
        case idx = "idx"
        case word = "word"
    }
    
}
