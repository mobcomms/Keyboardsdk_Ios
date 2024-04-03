//
//  ENThemeCollectionViewCell.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/18.
//

import UIKit

public class ENThemeCollectionViewCell: UICollectionViewCell {
    
    static let needSize:CGSize = CGSize.init(width: 168.5, height: 126.0)
    static let ID:String = "ENThemeCollectionViewCell"

    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var imageViewThumbnail: UIImageView!
    @IBOutlet weak var imageViewSelectIcon: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var downloadCountRootView: UIView!
    @IBOutlet weak var labelDownloadCount: UILabel!
    
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var badgeImageView: UIImageView!
    
    
    var isEditMode:Bool = false {
        didSet {
            self.checkBoxImageView?.isHidden = !isEditMode
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        imageViewSelectIcon.isHidden = true
        
        rootView.layer.applyRounding(cornerRadius: 8.0)
        shadowView.layer.applySketchShadow(color: .black, alpha: 0.1, x: 0.0, y: 0.7, blur: 2.7, spread: 0.0)
        self.clipsToBounds = false
        
        downloadCountRootView.isHidden = true
        checkBoxImageView.backgroundColor = UIColor.aikbdBodyLargeTitle.withAlphaComponent(0.3)
        updateCheckBox(isSelect: false)
        isEditMode = false
        setBadge()
    }
    
    
    func setSelectedTheme(isSelected:Bool) {
        imageViewSelectIcon.isHidden = !isSelected
        if isSelected {
            isEditMode = false
        }
    }
    
    func setBadge(isNew:Bool = false, isOwn:Bool = false) {
        badgeImageView.isHidden = false
        
        if isOwn {
            badgeImageView.image = UIImage(named: "aikbdNewTag2", in: Bundle.frameworkBundle, compatibleWith: nil)
        }
        else if isNew {
            badgeImageView.image = UIImage(named: "aikbdNewTag1", in: Bundle.frameworkBundle, compatibleWith: nil)
        }
        else {
            badgeImageView.isHidden = true
        }
    }
    
    
    
    func updateCheckBox(isSelect: Bool) {
        if isSelect {
            checkBoxImageView.image = UIImage.init(named: "aikbdISmallChkP", in: Bundle.frameworkBundle, compatibleWith: nil)
            checkBoxImageView.layer.applyRounding(cornerRadius: 11.5, borderColor: UIColor.clear, borderWidth: 1.7, masksToBounds: true)
        }
        else {
            checkBoxImageView.image = nil
            checkBoxImageView.layer.applyRounding(cornerRadius: 11.5, borderColor: UIColor.aikbdRollingOn, borderWidth: 1.7, masksToBounds: true)
        }
        
    }
}
