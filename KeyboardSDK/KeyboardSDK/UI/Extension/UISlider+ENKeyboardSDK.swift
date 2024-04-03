//
//  UISlider+ENKeyboardSDK.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/01.
//

import Foundation

extension UISlider {
    
    func redrawSliderThumbShadow(sub:UIView) {
        sub.subviews.forEach { sSub in
            if sSub is UIImageView && sSub.frame.width == sSub.frame.height {
                
                if sSub.subviews.count > 0 {
                    sSub.subviews.forEach { temp in
                        temp.isHidden = true
                    }
                }
                
                let newThumbShadow = UIView()
                newThumbShadow.frame = CGRect(x: 4, y: 4, width: sSub.frame.width - 8, height: sSub.frame.height - 8)
                newThumbShadow.clipsToBounds = false
                newThumbShadow.layer.applySketchShadow(color: .black, alpha: 0.2, x: -1, y: 0, blur: 2.0, spread: 0.0)
                
                let newThumb = UIView()
                newThumb.frame = newThumbShadow.bounds
                newThumb.isUserInteractionEnabled = false
                newThumb.backgroundColor = .aikbdPointBlue
                newThumb.layer.applyRounding(cornerRadius: newThumb.frame.width / 2.0, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
                
                newThumbShadow.addSubview(newThumb)
                
                sSub.addSubview(newThumbShadow)
                sSub.clipsToBounds = false
            }
            else if sSub.subviews.count > 0 {
                redrawSliderThumbShadow(sub: sSub)
            }
            else {
                sSub.layer.applySketchShadow(color: .black, alpha: 0.0, x: 0, y: 0, blur: 0, spread: 0)
            }
        }
    }
}
