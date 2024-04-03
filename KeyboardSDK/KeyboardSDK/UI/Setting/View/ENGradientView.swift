//
//  ENGradientView.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/28.
//

import Foundation
import UIKit



@IBDesignable
class ENGradientView: UIView {
    
    @IBInspectable var colorTop: UIColor? {
        didSet {
            configure()
        }
    }
    
    @IBInspectable var colorBottom: UIColor? {
        didSet {
            configure()
        }
    }
    
    @IBInspectable var isVerticalGradient: Bool = false {
        didSet {
            configure()
        }
    }
    
    @IBInspectable var isDiagonalGradient: Bool = false {
        didSet {
            configure()
        }
    }
    
    var gradient:CAGradientLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
        
    func configure() {
        if colorTop != nil && colorBottom != nil{
            if(gradient == nil) {
                gradient = CAGradientLayer()
                layer.insertSublayer(gradient!, at: 0)
            }
            
            gradient!.frame = bounds
            gradient!.colors = [colorTop!.cgColor, colorBottom!.cgColor]
            
            if isDiagonalGradient {
                gradient!.startPoint = CGPoint(x: 1.0, y: 0.0)
                gradient!.endPoint = CGPoint(x: 0.0, y: 1.0)
            }
            else {
                if(isVerticalGradient) {
                    gradient!.startPoint = CGPoint(x: 0.0, y: 0.0)
                    gradient!.endPoint = CGPoint(x: 0.0, y: 1.0)
                }
                else {
                    gradient!.startPoint = CGPoint(x: 0.0, y: 0.0)
                    gradient!.endPoint = CGPoint(x: 1.0, y: 0.0)
                }
            }
            
        }
    }
}
