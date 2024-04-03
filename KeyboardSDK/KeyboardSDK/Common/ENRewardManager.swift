//
//  ENRewardManager.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/08/02.
//

import Foundation


class ENRewardManager {
    
    static let shared:ENRewardManager = ENRewardManager()
    
    var changeCount:Int = 0
    
    
    func addChangeCount() {
        changeCount += 1
    }
    
    
    func start() {
        changeCount = 0
    }
    
    
    func stop() {
        guard changeCount > 1 else {
            changeCount = 0
            return
        }
        
        requestUpdateRewardCount()
    }
    
    
    
    func requestUpdateRewardCount() {
    }
    
    
}
