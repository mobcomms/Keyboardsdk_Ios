//
//  ENRecommandThemeListModel.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/21.
//

import Foundation
import KeyboardSDKCore

public struct ENRecommandThemeListModel: Codable, DHCodable {
    
    //성공시 포함
    public var data: ENRecommandThemeDataModel?
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
}
