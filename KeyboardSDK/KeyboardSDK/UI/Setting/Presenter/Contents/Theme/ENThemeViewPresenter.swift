//
//  ENThemeViewPresenter.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/21.
//

import Foundation
import KeyboardSDKCore


class ENThemeViewPresenter: ENTabContentPresenter {
    
    
    var cateCode:String = ""
    
    let headerView: ENThemeCategoryHeaderView = ENThemeCategoryHeaderView.create()
    
    
    override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
        
        contentPresenter = ENThemeRecommandPresenter.init(collectionView: collectionView)
        
        self.collectionView?.contentInsetAdjustmentBehavior = .never
        self.collectionView?.addSubview(headerView)
        
//        self.loadBannerData()
        self.loadCategory()
        
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
        self.loadCategory()
        
        if let collectionView = contentPresenter?.collectionView {
            contentPresenter = ENThemeRecommandPresenter.init(collectionView: collectionView)
            (contentPresenter as? ENThemeRecommandPresenter)?.loadData()
            
            contentPresenter?.topButton = topButton
            contentPresenter?.delegate = contentDelegate
            layoutHeaderView()
        }
        
    }
}



//MARK:- load data
extension ENThemeViewPresenter {
    
    func loadBannerData() {
        let request:DHNetwork = DHApi.themeBannerList()
        DHApiClient.shared.fetch(with: request) {[weak self] (result: Result<[ENThemeBannerListModel], DHApiError>) in
            guard let self else { return }
            switch result {
            case .success(let retValue):
                DHLogger.log("\(retValue.debugDescription)")
                
                DispatchQueue.main.async {
                    self.headerView.bannerList.removeAll()
                    self.headerView.bannerList = retValue
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
    
    
    func loadCategory() {
        let request:DHNetwork = DHApi.categoryList()
        DHApiClient.shared.fetch(with: request) {[weak self] (result: Result<ENKeyboardThemeCategoryListModel, DHApiError>) in
            guard let self else { return }
            switch result {
            case .success(let retValue):
                DHLogger.log("\(retValue.debugDescription)")
                
                DispatchQueue.main.async {
                    guard let category = retValue.category else {
                        return
                    }
                    self.headerView.categoryList.removeAll()
                    self.headerView.colorList.removeAll()
                    
                    self.headerView.isColor = false
                    self.headerView.categoryList = category.word ?? []
                    self.headerView.colorList = category.color ?? []
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
    
    func enThemeCategoryHeaderView(headerView: ENThemeCategoryHeaderView, bannerSelected banner: ENThemeBannerListModel?) {
        delegate?.open(url: URL(string: banner?.url ?? ""), from: self)
    }
    
    func enThemeCategoryHeaderView(headerView: ENThemeCategoryHeaderView, categorySelected category: ENKeyboardThemeCategoryModel?) {
        if let collectionView = self.collectionView, let categoryCode = category?.code_id {
            if categoryCode.isEmpty || categoryCode == "00" {
                contentPresenter = ENThemeRecommandPresenter.init(collectionView: collectionView)
                (contentPresenter as? ENThemeRecommandPresenter)?.loadData()
            }
            else {
                contentPresenter = ENThemeCategoryPresenter.init(collectionView: collectionView)
                (contentPresenter as? ENThemeCategoryPresenter)?.categoryCode = categoryCode
            }
            
            contentPresenter?.topButton = topButton
            contentPresenter?.delegate = contentDelegate
            layoutHeaderView()
        }
    }
    
}
