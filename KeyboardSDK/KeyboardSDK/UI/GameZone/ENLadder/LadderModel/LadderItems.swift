//
//  LadderItems.swift
//  KeyboardSDK
//
//  Created by Enliple on 2024/01/31.
//

import UIKit

class PlayerItem {
    
    var player: Player? 
    
    var color: UIColor = randomColor(luminosity: .dark)
}


class RewardItem {
    
    var reward: Reward?
    
    var color = Color.black
}

protocol ItemHashable {
    
    var id: UUID { get }
    
    var object: String { get }
    
    var image: String? { get }
    
    var presentedColor: Color? { get set }
}

extension ItemHashable {
    
    var displayColor: UIColor {
        return presentedColor ?? .systemOrange
    }
    
    var title: String {
        return object ?? ""
    }
}
