//
//  ENPhotoThemeContentPresenter.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/28.
//

import Foundation
import KeyboardSDKCore



protocol ENPhotoThemeContentPresenterDelegate: AnyObject {
    
}


class ENPhotoThemeContentPresenter: ENCollectionViewPresenter {
    
    let mainHeaderView: ENPhotoThemeHeaderView = ENPhotoThemeHeaderView.create()
    
    
    override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
        
        mainHeaderView.delegate = self
        self.numberOfSections = 1
        
        self.page = 1
        loadPhotoData(page: page)
    }
    
    
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
    
    override func loadData() {
        self.page += 1
        self.loadPhotoData(page: page)
    }
    
}

//MARK:- For UICollectionView
extension ENPhotoThemeContentPresenter {
    
    override func numberOfItems(section: Int) -> Int {
        return dataSource.count
    }
    
    
    override func sizeForHeader(section: Int) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: ENPhotoThemeHeaderView.needHeight)
    }
    
    override func dequeueCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: ENPhotoThemeCollectionViewCell.ID, for: indexPath) as? ENPhotoThemeCollectionViewCell
        updateCellData(for: cell, indexPath: indexPath)
        
        return cell ?? super.dequeueCell(for: indexPath)
    }
    
    override func dequeueViewForSupplementaryElementOf(kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            mainHeaderView.removeFromSuperview()
            
            let reusableView = super.dequeueViewForSupplementaryElementOf(kind: kind, at: indexPath)
            reusableView.addSubview(mainHeaderView)
            
            mainHeaderView.frame = reusableView.bounds
            mainHeaderView.sizeToFit()
            
            return reusableView
        }
        else {
            return super.dequeueViewForSupplementaryElementOf(kind: kind, at: indexPath)
        }
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



//MARK:- load data
extension ENPhotoThemeContentPresenter {
    
    func loadPhotoData(page:Int) {
        
        if isInReqeust {
            self.page -= 1
            if self.page < 1 { self.page = 1 }
            
            return
        }
        
        isInReqeust = true
        
        let request:DHNetwork = DHApi.recommandPhotos(userId: "test", page: page)
        
        DHApiClient.shared.fetch(with: request) {[weak self] (result: Result<ENPhotoThemeListModel, DHApiError>) in
            guard let self else { return }
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
                        self.page = -1
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
}



extension ENPhotoThemeContentPresenter: ENPhotoThemeHeaderViewDelegate {
    
    func openPhotoGallery(from: ENPhotoThemeHeaderView) {
        delegate?.openGallery(self)
    }
}
