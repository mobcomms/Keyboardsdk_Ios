//
//  ENKeyboardAPIManeger.swift
//  KeyboardSDK
//
//  Created by Enliple on 2024/01/11.
//

import Foundation
import KeyboardSDKCore

public class ENKeyboardAPIManeger{
    static let shared = ENKeyboardAPIManeger()
    
    public func callSendRewardPoint(_ zone_id: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void){

        let urlString = "\(ENAPIConst.API_URL)send_reward_zone_point.php"
        let param = [
            "uuid": "\(ENAPIConst.uuid)",
            "zone_id": "\(zone_id)",
            "server_type": "\(ENAPIConst.API_SERVER_TYPE)"
        ]
        URLUtil.customCallApi(url: urlString, method: .GET, parameters: param, token: nil) {[weak self] data, response, error in
            guard let self = self else { return }
            completion(data, response, error)
        }
    }
    public func callUpdateUserInfo( completion: @escaping (Data?, URLResponse?, Error?) -> Void){

        let urlString = "\(ENAPIConst.API_URL)update_user_info.php"
        let param = ["uuid": "\(ENAPIConst.uuid)",
                     "os_type":"I",
                     "user_app_type": (ENSettingManager.shared.keyboardType == .qwerty ? "쿼티" : "천지인")]

        URLUtil.customCallApi(url: urlString, method: .GET, parameters: param, token: nil) {[weak self] data, response, error in
            guard let self = self else { return }
            completion(data, response, error)
        }
    }
    public func callBrandUtil( completion: @escaping (Data?, URLResponse?, Error?) -> Void){

        let urlString = "\(ENAPIConst.API_URL)get_brand_util.php"
        let param = ["uuid": "\(ENAPIConst.uuid)"]
        URLUtil.customCallApi(url: urlString, method: .GET, parameters: param, token: nil) {[weak self] data, response, error in
            guard let self = self else { return }
            completion(data, response, error)
        }
    }

    public func getUserTotalPoint( completion: @escaping (Data?, URLResponse?, Error?) -> Void){

        let urlString = "\(ENAPIConst.API_URL)get_user_total_point.php"
        let param = ["uuid": "\(ENAPIConst.uuid)"]

        URLUtil.customCallApi(url: urlString, method: .GET, parameters: param, token: nil) {[weak self] data, response, error in
            guard let self = self else { return }
            completion(data, response, error)
        }
    }
    public func getUserCheckPoint( completion: @escaping (Data?, URLResponse?, Error?) -> Void){

        let urlString = "\(ENAPIConst.API_URL)get_user_chk_point.php"
        let param = ["uuid": "\(ENAPIConst.uuid)"]

        URLUtil.customCallApi(url: urlString, method: .GET, parameters: param, token: nil) {[weak self] data, response, error in
            guard let self = self else { return }
            completion(data, response, error)
        }
    }
    public func getUserPoint( completion: @escaping (Data?, URLResponse?, Error?) -> Void){

        let urlString = "\(ENAPIConst.API_URL)get_user_point.php"
        let param = ["uuid": "\(ENAPIConst.uuid)", "server_type": "\(ENAPIConst.API_SERVER_TYPE)"]

        URLUtil.customCallApi(url: urlString, method: .GET, parameters: param, token: nil) {[weak self] data, response, error in
            guard let self = self else { return }
            completion(data, response, error)
        }
    }
    //신규 api
    public func callDayStats( completion: @escaping (Data?, URLResponse?, Error?) -> Void){

        let urlString = "\(ENAPIConst.API_URL)set_day_stats.php"
        let param = ["uuid": "\(ENAPIConst.uuid)"]

        URLUtil.customCallApi(url: urlString, method: .GET, parameters: param, token: nil) {[weak self] data, response, error in
            guard let self = self else { return }
            completion(data, response, error)
        }
    }

    public func callSendPoint_v2( completion: @escaping (Data?, URLResponse?, Error?) -> Void){

        let urlString = "\(ENAPIConst.API_URL)send_point_v2.php"
        let param = ["uuid": "\(ENAPIConst.uuid)",
                     "user_point": ENSettingManager.shared.readyForHanaPoint,
                     "event_id": "1",
                     "server_type": "\(ENAPIConst.API_SERVER_TYPE)"
        ] as [String : Any]

        URLUtil.customCallApi(url: urlString, method: .GET, parameters: param, token: nil) {[weak self] data, response, error in
            guard let self = self else { return }
            completion(data, response, error)
        }
    }
    public func getNews( completion: @escaping (Data?, URLResponse?, Error?) -> Void){

        let urlString = "\(ENAPIConst.API_URL)get_news.php"
        let param = ["uuid": "\(ENAPIConst.uuid)"]

        URLUtil.customCallApi(url: urlString, method: .GET, parameters: param, token: nil) {[weak self] data, response, error in
            guard let self = self else { return }
            completion(data, response, error)
        }
    }
    public func getBannerPoint(isMainBanner isMain:Bool, completion: @escaping (Data?, URLResponse?, Error?) -> Void){

        let urlString = "\(ENAPIConst.API_URL)\(isMain ? "get_reward_chk_main" : "get_reward_chk_set").php"
        let param = ["uuid": "\(ENAPIConst.uuid)",
                         "zone_id": "\(isMain ? ENAPIConst.ZONE_ID_MAIN : ENAPIConst.ZONE_ID_SUB)"]

        URLUtil.customCallApi(url: urlString, method: .GET, parameters: param, token: nil) {[weak self] data, response, error in
            guard let self = self else { return }
            completion(data, response, error)
        }
    }

    public func getTabDetail(completion: @escaping (Data?, URLResponse?, Error?) -> Void){

        let urlString = "\(ENAPIConst.API_URL)get_tab_detail.php"

        URLUtil.customCallApi(url: urlString, method: .GET, parameters: nil, token: nil) {[weak self] data, response, error in
            guard let self = self else { return }
            completion(data, response, error)
        }
    }
    public func callSetUserInfo( completion: @escaping (Data?, URLResponse?, Error?) -> Void){

        let urlString: String = "\(ENAPIConst.API_URL)set_user_info.php"
        let param = ["uuid": "\(ENAPIConst.uuid)",
                     "os_type":"I",
                     "user_app_type": (ENSettingManager.shared.keyboardType == .qwerty ? "쿼티" : "천지인")]

        URLUtil.customCallApi(url: urlString, method: .GET, parameters: param, token: nil) {[weak self] data, response, error in
            guard let self = self else { return }
            completion(data, response, error)
        }
    }

}
