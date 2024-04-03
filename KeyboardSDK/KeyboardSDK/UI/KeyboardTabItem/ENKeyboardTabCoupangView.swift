//
//  ENKeyboardTabCoupangView.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/07/14.
//

import UIKit

class ENKeyboardTabCoupangView: UIView {
    
    static let ID = "ENKeyboardTabCoupangView"
    
    static func create() -> ENKeyboardTabCoupangView {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENKeyboardTabCoupangView", owner: self, options: nil)
        let tempView = nibViews?.first as! ENKeyboardTabCoupangView
        
        return tempView
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var dataSource:[Any] = []
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutInit()
    }
    
    func layoutInit() {
    }
    
}


extension ENKeyboardTabCoupangView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
}
