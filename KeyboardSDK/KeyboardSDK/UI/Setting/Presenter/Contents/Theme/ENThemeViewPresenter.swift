//
//  ENThemeViewPresenter.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/06/21.
//

import Foundation
import KeyboardSDKCore


class ENThemeViewPresenter: ENTabContentPresenter {
    
    
    var cateCode:String = ""
    var themeData: [ENKeyboardThemeModel]? = []

    let headerView: ENThemeCategoryHeaderView = ENThemeCategoryHeaderView.create()
    
    
    override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
        
        contentPresenter = ENThemeCategoryPresenter.init(collectionView: collectionView)
        self.collectionView?.contentInsetAdjustmentBehavior = .never
        self.collectionView?.addSubview(headerView)
        
        self.loadThemeData()
        
        layoutHeaderView()
    }
    
    func layoutHeaderView() {
        headerView.setUpForRecommandTheme()
        
        headerView.setNeedsLayoutContentView()
        headerView.layoutContentViewIfNeeded()
        
        let topMargin = headerView.maximumHeight
        self.collectionView?.contentInset = UIEdgeInsets.init(top: topMargin,
                                                              left: self.collectionView?.contentInset.left ?? 0,
                                                              bottom: self.collectionView?.contentInset.bottom ?? 0,
                                                              right: self.collectionView?.contentInset.right ?? 0)
        
        headerView.delegate = self
    }
    
    override func loadData() {
        contentPresenter?.loadData()
    }
    
    
    func clearHeaderView() {
        headerView.removeFromSuperview()
        self.collectionView?.contentInset = UIEdgeInsets.init(top: 0.0,
                                                              left: self.collectionView?.contentInset.left ?? 0,
                                                              bottom: self.collectionView?.contentInset.bottom ?? 0,
                                                              right: self.collectionView?.contentInset.right ?? 0)
        headerView.delegate = nil
    }
    
    override func reset() {

        self.loadThemeData()
        
        if let collectionView = contentPresenter?.collectionView {
            contentPresenter = ENThemeCategoryPresenter.init(collectionView: collectionView)
            
            contentPresenter?.delegate = contentDelegate
            layoutHeaderView()
        }
        
    }
}



//MARK:- load data
extension ENThemeViewPresenter {
    
    func loadThemeData(){
         
        let request:DHNetwork = DHApi.themeList(cateCode:"00", keyword:"")
        DHApiClient.shared.fetch(with: request) {[weak self] (result: Result<ENKeyboardThemeListModel, DHApiError>) in
            guard let self else { return }
            switch result {
            case .success(let retValue):
//                DHLogger.log("\(retValue.debugDescription)")
                
                DispatchQueue.main.async {
                    guard let category = retValue.category, let data = retValue.data else {
                        return
                    }
                    self.headerView.categoryList.removeAll()
                    
                    self.headerView.categoryList = category
                    
                    if  data.count > 0 {
                        self.themeData = data
                        (self.contentPresenter as? ENThemeCategoryPresenter)?.themeData = data
                        (self.contentPresenter as? ENThemeCategoryPresenter)?.categoryCode = "00"

                    }
                }
                break
                
            case .failure(let error):
                DHLogger.log("\(error.localizedDescription)")
                break
            @unknown default:
                break
            }
        }
    }
}

//MARK:- ENThemeCategoryHeaderView Delegate

extension ENThemeViewPresenter: ENThemeCategoryHeaderViewDelegate {
    func enThemeCategoryHeaderView(headerView: ENThemeCategoryHeaderView, categorySelected category: ENKeyboardThemeCategoryModel?) {
        if let collectionView = self.collectionView, let categoryCode = category?.code_id {
            
                contentPresenter = ENThemeCategoryPresenter.init(collectionView: collectionView)
                (contentPresenter as? ENThemeCategoryPresenter)?.themeData = self.themeData
                (contentPresenter as? ENThemeCategoryPresenter)?.categoryCode = categoryCode
            
            
            contentPresenter?.delegate = contentDelegate
            layoutHeaderView()
        }
    }
    
}
