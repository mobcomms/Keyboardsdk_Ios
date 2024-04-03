//
//  ENCustomAdView.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/12.
//

import Foundation
import KeyboardSDKCore

public class ENCustomAdView: UIView {
    
    public lazy var labels: UILabel = {
        let lbl = UILabel()
        lbl.text = "광고가 나와요!"
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func settingUI() {
        self.addSubview(labels)
        
        labels.translatesAutoresizingMaskIntoConstraints = false
        
        labels.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        labels.heightAnchor.constraint(equalToConstant: ENSettingManager.shared.getKeyboardCustomHeight()).isActive = true
        
        labels.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        labels.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
