//
//  ENThemeSearchBasePresenter.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/06.
//

import Foundation
import KeyboardSDKCore


class ENThemeSearchBasePresenter: ENCollectionViewPresenter {

    var keywordTextField: UITextField? = nil
    var contentRootView: UIView? = nil    
    
    let keywordView = ENSearchKeywordView.create()
    
    
    var keyword:String = "" {
        didSet {
            if keyword.isEmpty {
                showKeywordView()
            }
            else {
                self.page = 1
                searchData(keyword: keyword, page: page)
            }
        }
    }
    
    init(collectionView: UICollectionView, contentView:UIView, keywordTextField:UITextField) {
        super.init(collectionView: collectionView)
        
        self.collectionView?.contentInset = UIEdgeInsets.init(top: 12.0, left: 0.0, bottom: 15.0, right: 0.0)
        
        self.contentRootView = contentView
        self.keywordTextField = keywordTextField
        self.numberOfSections = 1
        
        keywordView.delegate = self
        
        
        showKeywordView()
    }
    
    
    func showKeywordView() {
        if let _ = keywordView.superview {
            return
        }
        
        self.contentRootView?.addSubview(keywordView)
        
        var layoutConstraints:[NSLayoutConstraint] = []
        let views: [String: Any] = [
            "keywordView": keywordView
        ]
        
        keywordView.translatesAutoresizingMaskIntoConstraints = false
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[keywordView]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[keywordView]|", metrics: nil, views: views)
        self.contentRootView?.addConstraints(layoutConstraints)
        
        loadKeywordList()
    }
    
    func hideKeywordView() {
        if page == 1 {
            dataSource.removeAll()
            collectionView?.reloadData()
        }
        
        keywordView.removeFromSuperview()
    }
    
    override func loadData() {
        self.page += 1
        self.searchData(keyword: keyword, page: page)
    }
    
    func showEmptyView() {}
    func hideEmptyView() {}
}



//MARK:- ENSearchKeywordViewDelegate
extension ENThemeSearchBasePresenter: ENSearchKeywordViewDelegate {
    func search(By keyword: String, keywordView: ENSearchKeywordView) {
        self.keywordTextField?.text = keyword
        self.keyword = keyword
    }
    
    
}




//MARK:- ENThemeSearchProtocol
extension ENThemeSearchBasePresenter: ENThemeSearchProtocol {
    
    func search(by keyword: String, from: ENThemeSearchProtocol?) {
        self.keyword = keyword
    }
}



//MARK:- Control Datas
extension ENThemeSearchBasePresenter {
    @objc func searchData(keyword:String, page:Int) {
        hideKeywordView()
    }
    
    @objc func loadKeywordList() {
    }
}
