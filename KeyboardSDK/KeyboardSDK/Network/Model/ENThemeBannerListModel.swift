//
//  ENThemeBannerListModel.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/24.
//

import Foundation
import KeyboardSDKCore

public struct ENThemeBannerListModel: Codable, DHCodable {
    
    //성공시 포함
    var seq: String?
    var title: String?
    var url: String?
    var img_path: String?
    
    private enum CodingKeys: String, CodingKey {
        case seq = "seq"
        case title = "title"
        case url = "url"
        case img_path = "img_path"
    }
    
}
