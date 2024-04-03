//
//  ENPhotoThemeHeaderView.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/06/28.
//

import UIKit

protocol ENPhotoThemeHeaderViewDelegate: AnyObject {
    func openPhotoGallery(from:ENPhotoThemeHeaderView)
}

class ENPhotoThemeHeaderView: UIView {
    static let ID = "ENPhotoThemeHeaderView"
    static let needHeight:CGFloat = 118.0
    
    static func create() -> ENPhotoThemeHeaderView {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENPhotoThemeHeaderView", owner: self, options: nil)
        let tempView = nibViews?.first as! ENPhotoThemeHeaderView
        
        return tempView
    }
    
    
    
    @IBOutlet weak var selectGalleryButton: ENGradientView!
    @IBOutlet weak var buttonShadowView: UIView!
    
    weak var delegate: ENPhotoThemeHeaderViewDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutInit()
    }
    
    func layoutInit() {
        selectGalleryButton.layer.applyRounding(cornerRadius: 8, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
        selectGalleryButton.isUserInteractionEnabled = true
        selectGalleryButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGestureForGalleryButton(gesture:))))
        
        buttonShadowView.backgroundColor = .clear
        buttonShadowView.clipsToBounds = false
        buttonShadowView.layer.applySketchShadow(color: .black, alpha: 0.15, x: 0, y: 1.3, blur: 3.3, spread: 0)
    }
    
    
    
    @objc func excuteTapGestureForGalleryButton(gesture:UITapGestureRecognizer) {
        self.delegate?.openPhotoGallery(from: self)
    }
}
