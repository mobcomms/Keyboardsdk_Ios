//
//  ENAPIConst.swift
//  KeyboardSDK
//
//  Created by ximAir on 12/15/23.
//

import Foundation
import KeyboardSDKCore

public enum ENAPIConst {
    static let HOST_URL: String = "https://hana-api.commsad.com"
    static let API_URL = "\(HOST_URL)/API/HANA/"

    static let API_SERVER_TYPE: String = "\(ENSettingManager.shared.setDebug ? "ALPHA" : "RELEASE")"

    static let AD_URL: String = "https://www.mobwithad.com/api/v1/banner/app/ocbKeyboard"
    static let ZONE_ID_MAIN: String = "10884594"
    static let ZONE_ID_SUB: String = "10884595"
    static let AD_Main_Banner:String = "\(AD_URL)?zone=\(ZONE_ID_MAIN)&adid=\(ENSettingManager.shared.userIdfa)"
    static let AD_Sub_Banner:String = "\(AD_URL)?zone=\(ZONE_ID_SUB)&adid=\(ENSettingManager.shared.userIdfa)"

    static let mediaID: String = "hanamembership"
    static let token: String = "eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2OTgxMDkxNDB9.99xqC-IUNylT6PYmdxzX9VEPBBNjvu-IisR8tenRy_g"
    static let uuid: String = ENSettingManager.shared.hanaCustomerID
    static let changHanaCustomerID = uuid.replacingOccurrences(of: "+", with: "%2B").replacingOccurrences(of: "/", with: "%2F").replacingOccurrences(of: "=", with: "%3D")
    
    static let InquiryURL:String = "https://hana-api.commsad.com/API/HANA/inquiry/index.php?uuid=\(changHanaCustomerID)"
    static let PlusPointZoneURL:String = "https://pomission.com/common/view/missionList?pomissionMediaId=\(mediaID)&pomissionRefreshToken=\(token)&top_yn=v1&userAdId=\(ENSettingManager.shared.userIdfa)&userUuId=\(changHanaCustomerID)&useService=\(mediaID)&server_type=\(API_SERVER_TYPE)"

}
