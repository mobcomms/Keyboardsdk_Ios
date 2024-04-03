//
//  DHApi+Custom.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/05/06.
//

import Foundation

import KeyboardSDKCore


//MARK:- 테마 탭
extension DHApi {
    
    /// 카테고리별 테마 리스트
    struct themeList: DHNetwork {
        var method: DHApiRequestType = .GET
        var path: String = "get_theme.php"
        var parameters: [String:Any] = [String: Any]()
        var isBodyData: Bool = false
        
        init(cateCode:String = "00", keyword:String = "") {
            if !cateCode.isEmpty {
                parameters["cate"] = cateCode
            }
            parameters["keyword"] = keyword
        }
    }
    
}

