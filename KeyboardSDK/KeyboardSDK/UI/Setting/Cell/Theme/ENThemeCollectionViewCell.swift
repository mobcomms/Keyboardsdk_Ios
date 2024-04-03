//
//  ENThemeCollectionViewCell.swift
//  KeyboardSDKCore
//
//  Created by cashwalkKeyboard on 2021/05/18.
//

import UIKit

public class ENThemeCollectionViewCell: UICollectionViewCell {
    
    static let needSize:CGSize = CGSize.init(width: 168.5, height: 126.0)
    static let ID:String = "ENThemeCollectionViewCell"

    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var imageViewThumbnail: UIImageView!
    @IBOutlet weak var imageViewSelectIcon: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        imageViewSelectIcon.isHidden = true
        
        rootView.layer.applyRounding(cornerRadius: 8.0)
        shadowView.layer.applySketchShadow(color: .black, alpha: 0.1, x: 0.0, y: 0.7, blur: 2.7, spread: 0.0)
        self.clipsToBounds = false
        
        setBadge()
    }
    
    
    func setSelectedTheme(isSelected:Bool) {
        imageViewSelectIcon.isHidden = !isSelected
        
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
    
    
    
}
