//
//  ENThemeCategoryPresenter.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/24.
//

import Foundation
import KeyboardSDKCore



class ENThemeCategoryPresenter: ENCollectionViewPresenter {
    
    var selectedTheme: ENKeyboardThemeModel? = nil
    var focusTheme:ENKeyboardThemeModel? = nil
    
    var currentSelectedIndex:IndexPath? = nil
    var currentSelectedCategoryIndex:IndexPath? = nil
    
    let sortOptionView: ENThemeSortOptionView = ENThemeSortOptionView.create()
    
    
    var categoryCode:String = "" {
        didSet {
            if !categoryCode.isEmpty {
                self.page = 1
                self.loadThemeData()
            }
        }
    }
    
    
    override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
        
        sortOptionView.updateSortButtonState(isFamousSelected: false)
        sortOptionView.delegate = self
        
        self.selectedTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        self.numberOfSections = 1
    }
    
    
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
//        cell.setBadge(isNew: theme.isNew, isOwn: theme.isOwn)
        if let selectThemeName = theme.name, let currentThemeName = ENKeyboardThemeManager.shared.getCurrentTheme().name {
            if selectThemeName == currentThemeName {
                cell.imageViewSelectIcon.isHidden = false
            } else {
                cell.imageViewSelectIcon.isHidden = true
            }
        } else {
            cell.imageViewSelectIcon.isHidden = true
        }
        
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
    
    
    func updateSelectedThemeDataTo(isOwn:Bool) {
        
        for index in 0..<dataSource.count {
            let theme = dataSource[index] as? ENKeyboardThemeModel
            
            if theme?.idx == selectedTheme?.idx {
                theme?.isOwn = isOwn
            }
        }
        
        self.collectionView?.reloadData()
    }
    
    
    
    override func loadData() {
        self.page += 1
        self.loadThemeData()
    }
}

//MARK:- For UICollectionView
extension ENThemeCategoryPresenter {
    
    override func numberOfItems(section: Int) -> Int {
        return dataSource.count
    }
    
    
    override func sizeForHeader(section: Int) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: 45)
    }
    
    override func dequeueViewForSupplementaryElementOf(kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            sortOptionView.removeFromSuperview()
            
            let reusableView = super.dequeueViewForSupplementaryElementOf(kind: kind, at: indexPath)
            reusableView.addSubview(sortOptionView)
            
            sortOptionView.frame = reusableView.bounds
            sortOptionView.sizeToFit()
            
            return reusableView
        }
        else {
            return super.dequeueViewForSupplementaryElementOf(kind: kind, at: indexPath)
        }
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



//MARK:- load data
extension ENThemeCategoryPresenter {
    
    func loadThemeData() {
        if categoryCode.isEmpty || isInReqeust {
            return
        }
        isInReqeust = true
        
        let request:DHNetwork = DHApi.themeList(cateCode: categoryCode, userId: "test", sortByFamous: sortOptionView.sortByFamousButton.isSelected, page: page)
        DHApiClient.shared.fetch(with: request) {[weak self] (result: Result<ENKeyboardThemeListModel, DHApiError>) in
            guard let self else { return }
            switch result {
            case .success(let retValue):
                DHLogger.log("\(retValue.debugDescription)")
                
                if self.page == 1 {
                    self.dataSource.removeAll()
                }
                
                if let data = retValue.data, data.count > 0 {
                    self.dataSource.append(contentsOf:data)
                }
                else {
                    self.page = -1
                }
                
                DispatchQueue.main.async {
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



extension ENThemeCategoryPresenter: ENThemeSortOptionViewDelegate {
    
    func enThemeSortOptionView(sortOptionView: ENThemeSortOptionView, sortBy isFamous: Bool) {
        self.page = 1
        loadThemeData()
    }
}
