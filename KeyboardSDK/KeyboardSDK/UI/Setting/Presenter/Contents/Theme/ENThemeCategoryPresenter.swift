//
//  ENThemeCategoryPresenter.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/06/24.
//

import Foundation
import KeyboardSDKCore



class ENThemeCategoryPresenter: ENCollectionViewPresenter {
    
    var selectedTheme: ENKeyboardThemeModel? = nil
    var focusTheme:ENKeyboardThemeModel? = nil
    
    var currentSelectedIndex:IndexPath? = nil
    var currentSelectedCategoryIndex:IndexPath? = nil
    
    let defaultThemeName = "라이트모드 (기본)"
    
    var categoryCode:String = "" {
        didSet {
            if !categoryCode.isEmpty {
                self.reloadFilterData()
            }
        }
    }
    var themeData: [ENKeyboardThemeModel]? = []
    
    override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
        
        
        
        self.selectedTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        if self.selectedTheme?.name == "default"{
            self.selectedTheme?.name = defaultThemeName
        }
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
        cell.setBadge(isNew: theme.isNew, isOwn: theme.isOwn ?? false)
        var currentThemeName = ENKeyboardThemeManager.shared.getCurrentTheme().name
        if currentThemeName == "default"{
            currentThemeName = defaultThemeName
        }
        if let selectThemeName = theme.name   {
            if selectThemeName == currentThemeName {
                cell.imageViewSelectIcon.isHidden = false
                cell.selectionView.backgroundColor = UIColor(red: 1, green: 236/255, blue: 146/255, alpha: 0.6)
                
            } else {
                cell.imageViewSelectIcon.isHidden = true
                cell.selectionView.backgroundColor = .clear
                
            }
        } else {
            cell.imageViewSelectIcon.isHidden = true
        }
        
        if theme.name == selectedTheme?.name {
            currentSelectedIndex = indexPath
            cell.rootView.layer.borderWidth = 3
            cell.rootView.layer.borderColor = UIColor(red: 94/255, green: 80/255, blue: 80/255, alpha: 1).cgColor
            cell.rootView.layer.cornerRadius = 8
        }
        else {
            cell.rootView.layer.borderWidth = 0
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
        
    }
}

//MARK:- For UICollectionView
extension ENThemeCategoryPresenter {
    
    override func numberOfItems(section: Int) -> Int {
        return dataSource.count
    }
    
    
    override func sizeForHeader(section: Int) -> CGSize {
        return .zero
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
    
    func reloadFilterData(){
        self.dataSource.removeAll()
        
        if let data = themeData, data.count > 0 {
            if categoryCode == "" || categoryCode == "00"{
                self.dataSource.append(contentsOf:data)
            }else{
                let rs = data.filter({ $0.cat!.lowercased().contains(categoryCode)})
                self.dataSource.append(contentsOf:rs)
            }
        }
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}



