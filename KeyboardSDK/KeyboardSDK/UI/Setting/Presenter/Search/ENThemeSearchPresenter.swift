//
//  ENThemeSearchPresenter.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/05.
//

import Foundation
import KeyboardSDKCore


class ENThemeSearchPresenter: ENThemeSearchBasePresenter {
    var selectedTheme: ENKeyboardThemeModel? = nil
    
    var currentSelectedIndex:IndexPath? = nil
    var currentSelectedCategoryIndex:IndexPath? = nil
    
    let emptyView = ENThemeSearchEmptyView.create()
    
    private func getIndexedData(indexPath: IndexPath) -> ENKeyboardThemeModel? {
        guard dataSource.count > indexPath.row else {
            return nil
        }
        
        return dataSource[indexPath.row] as? ENKeyboardThemeModel
    }
    
    
    override func updateCellData(for cell:UICollectionViewCell?, indexPath: IndexPath) {
        guard let cell = cell as? ENThemeCollectionViewCell,
              let theme = getIndexedData(indexPath: indexPath) else {
            return
        }
        
        cell.imageViewThumbnail.loadImageAsync(with: theme.image)
        cell.labelName.text = theme.name
        
        
        if theme.name == selectedTheme?.name {
            currentSelectedIndex = indexPath
//            cell.setSelectedTheme(isSelected: true)
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1).cgColor
            cell.layer.cornerRadius = 8
        }
        else {
//            cell.setSelectedTheme(isSelected: false)
            cell.layer.borderWidth = 0
        }
    }
    
    
    override func showKeywordView() {
        keywordView.keywordType = .theme
        
        self.hideEmptyView()
        super.showKeywordView()
    }
    
    override func hideKeywordView() {
        self.hideEmptyView()
        super.hideKeywordView()
    }
    
    override func showEmptyView() {
        hideEmptyView()
        
        self.contentRootView?.addSubview(emptyView)
        
        var layoutConstraints:[NSLayoutConstraint] = []
        let views: [String: Any] = [
            "emptyView": emptyView
        ]
        
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[emptyView]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[emptyView]|", metrics: nil, views: views)
        self.contentRootView?.addConstraints(layoutConstraints)
        
        emptyView.delegate = self
    }
    
    override func hideEmptyView() {
        emptyView.removeFromSuperview()
        emptyView.delegate = nil
    }
}



//MARK:- ENThemeSearchEmptyViewDelegate
extension ENThemeSearchPresenter: ENThemeSearchEmptyViewDelegate {
    
    func search(By keyword: String, from view: ENThemeSearchEmptyView) {
        self.keywordTextField?.text = keyword
        self.keyword = keyword
    }
    
}



//MARK:- For UICollectionView
extension ENThemeSearchPresenter {
    
    override func numberOfItems(section: Int) -> Int {
        return dataSource.count
    }
    
    @objc override func didSelectedItem(at indexPath: IndexPath) {
        guard let theme = getIndexedData(indexPath: indexPath) else {
            return
        }
        
        let themeFileInfo = theme.themeFileInfo()
        
        if !(ENKeyboardThemeManager.shared.alreadyDownlaoded(theme: themeFileInfo)) {
            
            delegate?.collectionViewPresenter(self, showProgress: "테마 미리보기 적용중")
            
            ENKeyboardThemeManager.shared.download(theme: themeFileInfo) {[weak self] result in
                guard let self else { return }
                if result {
                    DispatchQueue.main.async {
                        self.delegate?.collectionViewPresenter(self, hideProgress: {
                            self.selectedTheme = theme
                            self.reloadItems(collection: self.collectionView, new: indexPath, old: self.currentSelectedIndex)
                            self.delegate?.showKeyboardPreview(self)
                        })
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.delegate?.collectionViewPresenter(self, hideProgress: {
                            self.delegate?.collectionViewPresenter(self, showErrorMessage: "테마 파일 다운로드를\n실패하였습니다.")
                            DHLogger.log("Fail Theme Name  : \(theme.name ?? "")")
                            DHLogger.log("Fail URL[Common] : \(theme.common_down_path ?? "")")
                            DHLogger.log("Fail URL[Custom] : \(theme.custom_down_path ?? "")")
                        })
                    }
                    
                }
            }
        }
        else {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.selectedTheme = theme
                self.reloadItems(collection: self.collectionView, new: indexPath, old: self.currentSelectedIndex)
                self.delegate?.showKeyboardPreview(self)
            }
        }
    }
    
}






//MARK:- Control Datas
extension ENThemeSearchPresenter {
    
    override func searchData(keyword: String, page: Int) {
        super.searchData(keyword: keyword, page: page)
        if isInReqeust {
            self.page -= 1
            if self.page < 1 { self.page = 1 }
            return
        }
        isInReqeust = true
        
        let request:DHNetwork = DHApi.searchTheme(keyword: keyword, userId: "test", page: page)
        DHApiClient.shared.fetch(with: request) { (result: Result<ENSearchResultListModel, DHApiError>) in
            switch result {
            case .success(let retValue):
                DHLogger.log("\(retValue.debugDescription)")
                
                if let data = retValue.data, data.count > 0 {
                    self.dataSource.append(contentsOf:data)
                }
                else {
                    self.page = -1
                }
                
                
                self.emptyView.recommandKeywordList.removeAll()
                self.emptyView.recommandKeywordList = retValue.recentList ?? []
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.isInReqeust = false
                }
                break
                
            case .failure(let error):
                DHLogger.log("\(error.localizedDescription)")
                break
                
            @unknown default:
                break
            }
            
            DispatchQueue.main.async {
                if page == 1 && self.dataSource.count <= 0 {
                    self.showEmptyView()
                }
                else {
                    self.hideEmptyView()
                }
            }
        }
    }
    
    override func loadKeywordList() {
        super.loadKeywordList()
        
        let request:DHNetwork = DHApi.themeSearchKeywordList(userId: "test")
        DHApiClient.shared.fetch(with: request) { (result: Result<ENKeywordListModel, DHApiError>) in
            
            switch result {
            case .success(let retValue):
                DHLogger.log("\(retValue.debugDescription)")
                
                let recent = retValue.recentList
                let most = retValue.mostList
                
                DispatchQueue.main.async {
                    self.keywordView.recentKeywordList.removeAll()
                    self.keywordView.realtimeKeywordList.removeAll()
                    
                    self.keywordView.recentKeywordList = recent ?? []
                    self.keywordView.realtimeKeywordList = most ?? []
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
