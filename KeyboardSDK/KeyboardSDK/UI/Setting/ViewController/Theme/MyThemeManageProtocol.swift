//
//  MyThemeManageProtocol.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/12.
//

import Foundation
import KeyboardSDKCore

protocol MyThemeManageProtocol: AnyObject {
    func saveThemeAtMyTheme(theme: ENKeyboardThemeModel)
    func removeThemeFromMyTheme(themeList: [ENKeyboardThemeModel], complete:@escaping (_ success:Bool) -> ())
}


extension MyThemeManageProtocol {
    
    func saveThemeAtMyTheme(theme: ENKeyboardThemeModel) {
        
        guard let idx = theme.idx else { return }
        
        let request:DHNetwork = DHApi.myThemeAdd(userId: "test", themeIdx: idx)
        
        DHApiClient.shared.fetch(with: request) { (result: Result<Dictionary<String, String>, DHApiError>) in
            switch result {
            case .success(let retValue):
                DHLogger.log("\(retValue.debugDescription)")
                break
                
            case .failure(let error):
                DHLogger.log("\(error.localizedDescription)")
                break
                
            @unknown default:
                break
            }
        }
        
    }
    
    
    func removeThemeFromMyTheme(themeList: [ENKeyboardThemeModel], complete:@escaping (_ success:Bool) -> ()) {
        
        let idxList = themeList.compactMap { model in
            return model.idx ?? ""
        }
        .filter { idx in
            return !idx.isEmpty
        }
        
        let request:DHNetwork = DHApi.myThemeRemove(userId: "test", themeIdx: idxList)
        DHApiClient.shared.fetch(with: request) { (result: Result<Dictionary<String, String>, DHApiError>) in
            switch result {
            case .success(let retValue):
                DHLogger.log("\(retValue.debugDescription)")
                break
                
            case .failure(let error):
                DHLogger.log("\(error.localizedDescription)")
                break
                
            @unknown default:
                break
            }
            
            complete(true)
        }
    }
    
}




