//
//  ENMyThemeViewPresenter.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/28.
//

import Foundation
import KeyboardSDKCore


class ENMyThemeViewPresenter: ENTabContentPresenter {
    
    init(collectionView: UICollectionView, superView:UIView, bottomViewHeight:NSLayoutConstraint) {
        super.init(collectionView: collectionView)
        
        contentPresenter = ENMyThemeContentViewPresenter.init(collectionView: collectionView, superView: superView, bottomViewHeight:bottomViewHeight)
        contentPresenter?.delegate = contentDelegate
    }
    
}
