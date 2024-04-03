//
//  ENTabContentPresenter.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/21.
//

import Foundation
import UIKit


protocol ENTabContentPresenterDelegate: AnyObject {
    func open(url:URL?, from: ENTabContentPresenter)
    func openPhotoGallery(from: ENTabContentPresenter)
}

extension ENTabContentPresenterDelegate where Self:UIViewController {
    func open(url:URL?, from: ENTabContentPresenter) {
        if let url = url {
            self.open(url: url)
        }
    }
    
    func openPhotoGallery(from: ENTabContentPresenter) {
    }
}



class ENTabContentPresenter: NSObject {
    
    var collectionView: UICollectionView? = nil
    var topButton:UIView? = nil {
        didSet {
            contentPresenter?.topButton = topButton
        }
    }
    
    var delegate:ENTabContentPresenterDelegate?
    
    var contentPresenter:ENCollectionViewPresenter? = nil
    var contentDelegate:ENCollectionViewPresenterDelegate? {
        didSet {
            contentPresenter?.delegate = contentDelegate
        }
    }
    
    
    init(collectionView:UICollectionView) {
        self.collectionView = collectionView
        contentPresenter = ENCollectionViewPresenter.init(collectionView: collectionView)
        contentPresenter?.topButton = topButton
    }
    
    
    func loadData() {
        contentPresenter?.loadData()
    }
    
    
    func reset() {
    }
}
