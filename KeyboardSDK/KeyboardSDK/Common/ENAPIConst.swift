//
//  ENAPIConst.swift
//  KeyboardSDK
//
//  Created by ximAir on 12/15/23.
//

import Foundation
import KeyboardSDKCore
public enum ENAPIConst {
    static let HOST_URL: String = "https://cashwalk-api.commsad.com"
    static let API_URL = "\(HOST_URL)/API/CASHWALK/"

    static let API_SERVER_TYPE: String = "\(ENSettingManager.shared.setDebug ? "ALPHA" : "RELEASE")"

    static let AD_URL: String = "https://www.mobwithad.com/api/v1/banner/app/ocbKeyboard"
    static let ZONE_ID_MAIN: String = "10885106"
    static let ZONE_ID_SUB: String = "10885107"
    static let AD_Main_Banner:String = "\(AD_URL)?zone=\(ZONE_ID_MAIN)&adid=\(ENSettingManager.shared.userIdfa)"
    static let AD_Sub_Banner:String = "\(AD_URL)?zone=\(ZONE_ID_SUB)&adid=\(ENSettingManager.shared.userIdfa)"

    static let mediaID: String = "cashwalkkeyboard"
    static let token: String = "eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2OTgxMDkxNDB9.99xqC-IUNylT6PYmdxzX9VEPBBNjvu-IisR8tenRy_g"
    static let uuid: String = ENSettingManager.shared.customerID
    static let changCustomerID = uuid.replacingOccurrences(of: "+", with: "%2B").replacingOccurrences(of: "/", with: "%2F").replacingOccurrences(of: "=", with: "%3D")
    
    static let InquiryURL:String = "\(API_URL)inquiry/index.php?uuid=\(changCustomerID)"
    static let PlusPointZoneURL:String = "https://pomission.com/common/view/missionList?pomissionMediaId=\(mediaID)&pomissionRefreshToken=\(token)&top_yn=v1&userAdId=\(ENSettingManager.shared.userIdfa)&userUuId=\(changCustomerID)&useService=\(mediaID)&server_type=\(API_SERVER_TYPE)"

}
