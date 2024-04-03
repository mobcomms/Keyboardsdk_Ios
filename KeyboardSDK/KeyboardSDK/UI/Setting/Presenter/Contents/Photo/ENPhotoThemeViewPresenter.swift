//
//  ENPhotoThemeViewPresenter.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/28.
//

import Foundation
import KeyboardSDKCore


class ENPhotoThemeViewPresenter: ENTabContentPresenter {
    
    override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
        
        contentPresenter = ENPhotoThemeContentPresenter.init(collectionView: collectionView)
        contentPresenter?.delegate = contentDelegate
    }
    
}

