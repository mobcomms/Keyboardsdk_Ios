//
//  HorizontalStackView.swift
//  KeyboardSDK
//
//  Created by Enliple on 2024/01/31.
//

import UIKit

class HorizontalStackView: UIView {

    var positions: [CGPoint] = [] {
        didSet { self.setNeedsLayout() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for (position, subview) in zip(positions, subviews) {
            
            subview.frame = CGRect(x: position.x, y: 0, width: 40, height: 40)
        }
    }
}
