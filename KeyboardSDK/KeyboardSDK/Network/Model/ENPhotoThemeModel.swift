//
//  ENPhotoThemeModel.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/28.
//

import Foundation
import KeyboardSDKCore


public struct ENPhotoThemeListModel: Codable, DHCodable {
    
    //성공시 포함
    var result: String?
    var errmsg: String?
    var data:[ENPhotoThemeModel]?
    
    private enum CodingKeys: String, CodingKey {
        case result = "result"
        case errmsg = "errmsg"
        case data = "data"
    }
}




public struct ENPhotoThemeModel: Codable, DHCodable {
    
    //성공시 포함
    var link: String?
    var thumbnail: String?
    
    private enum CodingKeys: String, CodingKey {
        case link = "link"
        case thumbnail = "thumbnail"
    }
    
}
