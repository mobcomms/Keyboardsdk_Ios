//
//  ENThemePhotoSearchPresenter.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/05.
//

import Foundation
import KeyboardSDKCore



class ENThemePhotoSearchPresenter: ENThemeSearchBasePresenter {
    var isShowingEmptyView:Bool = false
    
    var emptyHeaderView: ENSearchPhotoEmptyHeaderView = ENSearchPhotoEmptyHeaderView.create()
    
    private func getIndexedData(indexPath: IndexPath) -> ENPhotoThemeModel? {
        guard dataSource.count > indexPath.row else {
            return nil
        }
        
        return dataSource[indexPath.row] as? ENPhotoThemeModel
    }
    
    
    override func updateCellData(for cell:UICollectionViewCell?, indexPath: IndexPath) {
        guard let cell = cell as? ENPhotoThemeCollectionViewCell,
              let photo = getIndexedData(indexPath: indexPath) else {
            return
        }
        
        cell.contentImageView.loadImageAsync(with: photo.thumbnail)
    }
    
    
    override func showKeywordView() {
        keywordView.keywordType = .photoTheme
        
        self.hideEmptyView()
        super.showKeywordView()
    }
    
    override func hideKeywordView() {
        self.hideEmptyView()
        super.hideKeywordView()
    }
    
    
    override func showEmptyView() {
        self.page = 1
        self.isShowingEmptyView = true
        loadRecommandPhotoData(page: page)
    }
    
    override func hideEmptyView() {
        self.isShowingEmptyView = false
        
        self.emptyHeaderView.removeFromSuperview()
        self.dataSource.removeAll()
        self.collectionView?.reloadData()
    }
    
}




//MARK:- For UICollectionView
extension ENThemePhotoSearchPresenter {
    
    override func numberOfItems(section: Int) -> Int {
        return dataSource.count
    }
    
    override func sizeForHeader(section: Int) -> CGSize {
        if isShowingEmptyView {
            return CGSize.init(width: UIScreen.main.bounds.width, height: ENSearchPhotoEmptyHeaderView.needHeight)
        }
        
        return super.sizeForHeader(section: section)
    }
    
    override func dequeueViewForSupplementaryElementOf(kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            emptyHeaderView.removeFromSuperview()
            
            let reusableView = super.dequeueViewForSupplementaryElementOf(kind: kind, at: indexPath)
            reusableView.addSubview(emptyHeaderView)
            
            emptyHeaderView.frame = reusableView.bounds
            emptyHeaderView.sizeToFit()
            
            return reusableView
        }
        else {
            return super.dequeueViewForSupplementaryElementOf(kind: kind, at: indexPath)
        }
    }
    
    
    override func dequeueCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: ENPhotoThemeCollectionViewCell.ID, for: indexPath) as? ENPhotoThemeCollectionViewCell
        updateCellData(for: cell, indexPath: indexPath)
        
        return cell ?? super.dequeueCell(for: indexPath)
    }
    
    @objc override func didSelectedItem(at indexPath: IndexPath) {
        guard let photo = getIndexedData(indexPath: indexPath) else {
            return
        }
        
        let tempFile = "\(FileManager.default.temporaryDirectory)photo_theme_temp.png"
        if let source = URL(string: photo.link ?? ""), let dest = URL(string: tempFile) {
            if FileManager.default.fileExists(atPath: dest.path) {
                do {
                    try FileManager.default.removeItem(atPath: dest.path)
                }
                catch{
                    DHLogger.log("Download - File remove error:\(error)")
                }
            }
            
            DHApiClient.shared.downloadFile(src: source, dest: dest) {[weak self] finish in
                guard let self else { return }
                if finish, let image = UIImage(contentsOfFile: dest.path) {
                    DispatchQueue.main.async {
                        self.delegate?.editPhoto(self, edit: image)
                    }
                }
                else {
                    DHLogger.log("Oops!! Image Download Fail...")
                }
            }
        }
    }
    
}






//MARK:- Control Datas
extension ENThemePhotoSearchPresenter {
    
    override func searchData(keyword: String, page: Int) {
        guard !isShowingEmptyView else {
            self.loadRecommandPhotoData(page: page)
            return
        }
        
        super.searchData(keyword: keyword, page: page)
        
        if isInReqeust {
            self.page -= 1
            if self.page < 1 { self.page = 1 }
            return
        }
        isInReqeust = true
        
        
        
        let request:DHNetwork = DHApi.searchPhotos(keyword: keyword, userId: "test", page: page)
        
        DHApiClient.shared.fetch(with: request) { (result: Result<ENPhotoThemeListModel, DHApiError>) in
            switch result {
            case .success(let retValue):
                DHLogger.log("\(retValue.debugDescription)")
                
                DispatchQueue.main.async {
                    if page == 1 {
                        self.dataSource.removeAll()
                    }
                    
                    if retValue.result?.uppercased() == "SUCCESS" {
                        if let data = retValue.data, data.count > 0 {
                            self.dataSource.append(contentsOf: data)
                        }
                        else {
                            self.page -= 1
                        }
                        
                        self.isShowingEmptyView = false
                        self.collectionView?.reloadData()
                        self.collectionView?.collectionViewLayout.invalidateLayout()
                        self.collectionView?.layoutSubviews()
                    }
                    else  {
                        self.page = 1
                        self.dataSource.removeAll()
                    }
                }
                break
                
            case .failure(let error):
                DHLogger.log("\(error.localizedDescription)")
                break
            @unknown default:
                break
            }
            
            self.isInReqeust = false
            
            DispatchQueue.main.async {
                if page == 1 && self.dataSource.count <= 0 {
                    self.showEmptyView()
                }
            }
            
            
        }
    }
    
    
    func loadRecommandPhotoData(page:Int) {
        if isInReqeust {
            self.page -= 1
            if self.page < 1 { self.page = 1 }
            return
        }
        isInReqeust = true
        
        let request:DHNetwork = DHApi.recommandPhotos(userId: "test", page: page)
        
        DHApiClient.shared.fetch(with: request) { (result: Result<ENPhotoThemeListModel, DHApiError>) in
            switch result {
            case .success(let retValue):
                DHLogger.log("\(retValue.debugDescription)")
                
                DispatchQueue.main.async {
                    if page == 1 {
                        self.dataSource.removeAll()
                    }
                    
                    
                    if let data = retValue.data, data.count > 0 {
                        self.dataSource.append(contentsOf:data)
                    }
                    else {
                        self.page -= 1
                    }
                    
                    self.collectionView?.reloadData()
                }
                break
                
            case .failure(let error):
                DHLogger.log("\(error.localizedDescription)")
                break
            @unknown default:
                break
            }
            
            self.isInReqeust = false
        }
    }
    
    
    override func loadKeywordList() {
        super.loadKeywordList()
        
        let request:DHNetwork = DHApi.photoThemeSearchKeywordList(userId: "test")
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

