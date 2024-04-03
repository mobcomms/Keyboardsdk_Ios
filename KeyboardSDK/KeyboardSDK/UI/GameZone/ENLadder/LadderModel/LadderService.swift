//
//  LadderService.swift
//  KeyboardSDK
//
//  Created by Enliple on 2024/01/31.
//

import Foundation
class LadderService {
    
    let randomGenerator: RandomRowGenerator
    
    let players: [Player]
    
    var intersections: [IntersectionPoint] = [] 
    
    var rewards: [Reward] = []
    
    var rewardIndexReferenceFromPlayer: [Player: Int] = [:]
    var playerIndexReferenceFromReward: [Reward: Int] = [:]
    
    internal init(players: [Player],using randomGenerator: RandomRowGenerator = RandomRowGenerator()) {
        self.players = players

        self.randomGenerator = randomGenerator
    }
    
    func setReward(_ rewards: [Reward]) {
        
        assert(rewards.count <= players.count, "reward cannot be greater than players")
        
        var updates = players.map { Reward(object: "槓", presentedColor: $0.presentedColor) }
        
        rewards.enumerated().forEach { offset, element in
            let color = self.players[offset].presentedColor
            updates[offset] = Reward(object: element.object, presentedColor: color)
        }
        
        self.rewards = updates
        
        self.rewards.shuffle()
    }
    
    func prepare() {
        self.randomGenerator.prepare(by: self.players.count)
    }
}

