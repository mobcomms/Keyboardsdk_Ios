//
//  DHApi+Custom.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/05/06.
//

import Foundation

import KeyboardSDKCore

enum ENKeywordType: Int {
    case theme      = 0
    case photoTheme = 1
}


//MARK:- 테마 탭
extension DHApi {
    
    
    
    
    
    /// 테마 탭 배너 리스트
    struct themeBannerList: DHNetwork {
        var method: DHApiRequestType = .GET
        var path: String = "renew_theme/theme_banner.php"
        var parameters: [String:Any] = [String: Any]()
        var isBodyData: Bool = false
        
        init() {
        }
    }
    
    
    /// 테마 탭 카테고리 리스트
    struct categoryList: DHNetwork {
        var method: DHApiRequestType = .GET
        var path: String = "renew_theme/cate_list.php"
        var parameters: [String:Any] = [String: Any]()
        var isBodyData: Bool = false
        
        init() {
        }
    }
    
    
    /// 카테고리별 테마 리스트
    struct themeList: DHNetwork {
        var method: DHApiRequestType = .GET
        var path: String = "renew_theme/theme_list.php"
        var parameters: [String:Any] = [String: Any]()
        var isBodyData: Bool = false
        
        init(cateCode:String = "", userId:String, sortByFamous:Bool = false, page:Int = 1) {
            if !cateCode.isEmpty {
                parameters["cate_code"] = cateCode
            }
            parameters["uuid"] = userId
            parameters["sort"] = (sortByFamous ? "1" : "0")
            parameters["np"] = "\(page)"
        }
    }
    
    /// 테마 검색
    struct searchTheme: DHNetwork {
        var method: DHApiRequestType = .GET
        var path: String = "renew_theme/theme_list.php"
        var parameters: [String:Any] = [String: Any]()
        var isBodyData: Bool = false
        
        init(keyword:String = "", userId:String, page:Int = 1) {
            if !keyword.isEmpty {
                parameters["search"] = keyword
            }
            parameters["np"] = "\(page)"
            parameters["uuid"] = userId
        }
    }
    
    
    /// 테마 검색어 리스트
    struct themeSearchKeywordList: DHNetwork {
        var method: DHApiRequestType = .GET
        var path: String = "renew_theme/theme_list.php"
        var parameters: [String:Any] = [String: Any]()
        var isBodyData: Bool = false
        
        init(userId:String) {
            parameters["uuid"] = userId
        }
    }
    
    /// 테마 / 포토테마 최근 검색어 삭제
    struct removeSearchKeyword: DHNetwork {
        var method: DHApiRequestType = .GET
        var path: String = "renew_theme/theme_search_del.php"
        var parameters: [String:Any] = [String: Any]()
        var isBodyData: Bool = false
        
        init(word:String, userId:String, type:ENKeywordType) {
            parameters["uuid"] = userId
            parameters["type"] = "\(type.rawValue)"
            parameters["word"] = word
        }
    }
}





//MARK:- 포토 테마 탭
extension DHApi {
    
    /// 포토 테마 탭  - 추천 포토 리스트
    struct recommandPhotos: DHNetwork {
        var method: DHApiRequestType = .GET
        var path: String = "renew_theme/theme_photo.php"
        var parameters: [String:Any] = [String: Any]()
        var isBodyData: Bool = false
        
        init(userId:String, page:Int) {
            parameters["uuid"] = userId
            parameters["np"] = "\(page)"
        }
    }
    
    /// 포토 테마 탭  - 포토 검색
    struct searchPhotos: DHNetwork {
        var method: DHApiRequestType = .GET
        var path: String = "renew_theme/theme_photo.php"
        var parameters: [String:Any] = [String: Any]()
        var isBodyData: Bool = false
        
        init(keyword:String, userId:String, page:Int) {
            parameters["uuid"] = userId
            parameters["np"] = "\(page)"
            parameters["word"] = keyword
        }
    }
    
    
    /// 포토 테마 검색어 리스트
    struct photoThemeSearchKeywordList: DHNetwork {
        var method: DHApiRequestType = .GET
        var path: String = "renew_theme/theme_photo.php"
        var parameters: [String:Any] = [String: Any]()
        var isBodyData: Bool = false
        
        init(userId:String) {
            parameters["uuid"] = userId
            parameters["np"] = "1"
        }
    }
}




//MARK:- 마이 탭
extension DHApi {
    
    /// 마이 테마 리스트
    struct myThemeList: DHNetwork {
        var method: DHApiRequestType = .GET
        var path: String = "renew_theme/theme_my_list.php"
        var parameters: [String:Any] = [String: Any]()
        var isBodyData: Bool = false
        
        /// 마이 테마 삭제
        /// - Parameters:
        ///   - userId: 사용자 아이디, 비로그인 Device ID
        ///   - page: 불러올 페이지. 첫 페이지는 1
        init(userId:String = "", page:Int = 1) {
            parameters["uuid"] = userId
            parameters["np"] = "\(page)"
        }
    }
    
    
    /// 마이 테마 등록
    struct myThemeAdd: DHNetwork {
        var method: DHApiRequestType = .GET
        var path: String = "renew_theme/theme_my_action.php"
        var parameters: [String:Any] = [String: Any]()
        var isBodyData: Bool = false
        
        /// 마이 테마 등록
        /// - Parameters:
        ///   - userId: 사용자 아이디, 비로그인 Device ID
        ///   - themeIdx: 테마 idx
        init(userId:String = "", themeIdx:String = "") {
            parameters["uuid"] = userId
            parameters["theme_idx"] = themeIdx
            
            parameters["mode"] = "ins"
        }
    }
    
    /// 마이 테마 삭제
    struct myThemeRemove: DHNetwork {
        var method: DHApiRequestType = .GET
        var path: String = "renew_theme/theme_my_action.php"
        var parameters: [String:Any] = [String: Any]()
        var isBodyData: Bool = false
        
        
        /// 마이 테마 삭제
        /// - Parameters:
        ///   - userId: 사용자 아이디, 비로그인 Device ID
        ///   - themeIdx: 테마 idx
        init(userId:String = "", themeIdx:[String]) {
            parameters["uuid"] = userId
            parameters["mode"] = "del"
            
            if themeIdx.count == 1 {
                parameters["theme_idx"] = themeIdx[0]
            }
            else {
                for index in 0..<themeIdx.count {
                    parameters["theme_idx[\(index)]"] = themeIdx[index]
                }
            }
        }
    }
    
    
    
    //https://ocbapi.cashkeyboard.co.kr/API/OCB/get_brand.php
    /*
     {
     Result: "true",
     total_count: 10,
     list_info: [
     {
     seq: "564",
     title: "[쿠팡] 베네통 유니크 컬러콤비 레터링 포인트 운동화 BCSH58961",
     url: "https://coupa.ng/b3kmGT",
     more_url: "",
     icon_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/util_icon_img_564.png",
     img_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/brand_img_564.png"
     },
     {
     seq: "550",
     title: "[쿠팡] 브랜드닭 훈제 닭가슴살 5종 혼합 30팩",
     url: "https://coupa.ng/b3keHc",
     more_url: "",
     icon_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/util_icon_img_550.png",
     img_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/brand_img_550.png"
     },
     {
     seq: "449",
     title: "[쿠팡] 곰곰 채소믹스, 1kg, 1개",
     url: "https://coupa.ng/b2Hoco",
     more_url: "",
     icon_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/util_icon_img_449.png",
     img_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/brand_img_449.png"
     },
     {
     seq: "446",
     title: "[쿠팡] 곰곰 대추방울토마토, 750g, 1팩",
     url: "https://coupa.ng/b2HnKc",
     more_url: "",
     icon_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/util_icon_img_446.png",
     img_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/brand_img_446.png"
     },
     {
     seq: "552",
     title: "[쿠팡] [동아백화점 수성점] 레드페이스 (한정 초특가) 라이트 남성 바람막이 등산 재킷",
     url: "https://coupa.ng/b3kfOQ",
     more_url: "",
     icon_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/util_icon_img_552.png",
     img_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/brand_img_552.png"
     },
     {
     seq: "461",
     title: "[쿠팡] 네이쳐리빙 논슬립 코팅 1단 바지걸이, 네이비, 100개입",
     url: "https://coupa.ng/b2Hrgb",
     more_url: "",
     icon_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/util_icon_img_461.png",
     img_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/brand_img_461.png"
     },
     {
     seq: "487",
     title: "[쿠팡] 탐사수, 2L, 18개",
     url: "https://coupa.ng/b2Hwgj",
     more_url: "",
     icon_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/util_icon_img_487.png",
     img_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/brand_img_487.png"
     },
     {
     seq: "535",
     title: "[쿠팡] BRAUN 시리즈 7 전기면도기, MBS7, BLACK",
     url: "https://coupa.ng/b3kaQ4",
     more_url: "",
     icon_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/util_icon_img_535.png",
     img_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/brand_img_535.png"
     },
     {
     seq: "542",
     title: "[쿠팡] 아이윌 옥토넛 매직박스 모래놀이, 혼합 색상, 2kg",
     url: "https://coupa.ng/b3kdj8",
     more_url: "",
     icon_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/util_icon_img_542.png",
     img_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/brand_img_542.png"
     },
     {
     seq: "451",
     title: "[쿠팡] 남양유업 맛있는 우유 GT, 900ml, 2개",
     url: "https://coupa.ng/b2Hoxc",
     more_url: "",
     icon_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/util_icon_img_451.png",
     img_path: "https://okcashbag.cashkeyboard.co.kr/img/brand/2021/brand_img_451.png"
     }
     ]
     }
     */
}
