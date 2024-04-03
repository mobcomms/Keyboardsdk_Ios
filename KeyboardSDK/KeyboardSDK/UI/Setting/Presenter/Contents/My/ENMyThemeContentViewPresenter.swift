//
//  ENMyThemeContentViewPresenter.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/05.
//

import Foundation
import KeyboardSDKCore


class ENMyThemeContentViewPresenter: ENCollectionViewPresenter, MyThemeManageProtocol {
    
    var selectedTheme: ENKeyboardThemeModel? = nil
    
    var currentSelectedIndex:IndexPath? = nil
    var currentSelectedCategoryIndex:IndexPath? = nil
    
    let bottomBannerView: ENMyThemeBottomBannerView = ENMyThemeBottomBannerView.create()
    let emptyView: ENMyThemeEmptyView = ENMyThemeEmptyView.create()
    
    let deleteButton: UIButton = UIButton()
    
    var superView:UIView? = nil
    var bottomViewHeight:NSLayoutConstraint? = nil
    
    init(collectionView: UICollectionView, superView:UIView, bottomViewHeight:NSLayoutConstraint) {
        super.init(collectionView: collectionView)
        
        self.superView = superView
        self.bottomViewHeight = bottomViewHeight
        
        deleteButton.backgroundColor = UIColor.aikbdSubcolorPurple
        deleteButton.setTitleColor(UIColor.aikbdRollingOn, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        deleteButton.addTarget(self, action: #selector(deleteSelectedItems), for: .touchUpInside)
        updateDeleteButtonTitle()
        
        self.selectedTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        
        self.numberOfSections = 1
        self.updateUI()
        
        self.page = 1
        loadThemeData()
        loadBannerData()
    }
    
    
    
    
    /// 아이템 삭제 화면으로 전환한다.
    /// - Returns: 삭제 모드로 변경된 경우 true, 그 외의 경우 false
    func toggleEditMode() -> Bool {
        self.collectionView?.allowsMultipleSelection.toggle()
        updateUI()
        
        self.selectedTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        self.collectionView?.reloadData()
        
        
        return self.collectionView?.allowsMultipleSelection ?? false
    }
    
    
    func updateUI() {
        if self.collectionView?.allowsMultipleSelection ?? false {
            addDeleteButton()
        }
        else {
            addBottomBannerView()
        }
    }
    
    func addDeleteButton() {
        guard let _ = collectionView else {
            return
        }
        
        let needHeight:CGFloat = 45.0
        
        
        self.collectionView?.contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 15.0 + needHeight, right: 0.0)
        
        removeAddedItems()
        
        superView?.addSubview(deleteButton)
        
        var layoutConstraints:[NSLayoutConstraint] = []
        let views: [String: Any] = [
            "deleteButton": deleteButton
        ]
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[deleteButton]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[deleteButton]|", metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
        
        //active 끝나고 수정해야 적용이 된다...
        self.bottomViewHeight?.constant = needHeight
    }
    
    func addBottomBannerView() {
        self.collectionView?.contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 15.0, right: 0.0)
        removeAddedItems()
        
//        guard let _ = collectionView else {
//            return
//        }
//
//        let needHeight:CGFloat = ENMyThemeBottomBannerView.needHeight
//
//        self.collectionView?.contentInset = UIEdgeInsets.init(top: 12.0, left: 0.0, bottom: 15.0 + needHeight, right: 0.0)
//
//        removeAddedItems()
//
//        superView?.addSubview(bottomBannerView)
//
//        var layoutConstraints:[NSLayoutConstraint] = []
//        let views: [String: Any] = [
//            "bottomBannerView": bottomBannerView
//        ]
//
//        bottomBannerView.translatesAutoresizingMaskIntoConstraints = false
//
//        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[bottomBannerView]|", metrics: nil, views: views)
//        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[bottomBannerView]|", metrics: nil, views: views)
//        NSLayoutConstraint.activate(layoutConstraints)
//
//        //active 끝나고 수정해야 적용이 된다...
//        self.bottomViewHeight?.constant = needHeight
    }
    
    
    func removeAddedItems() {
        emptyView.removeFromSuperview()
        deleteButton.removeFromSuperview()
        bottomBannerView.removeFromSuperview()
        self.bottomViewHeight?.constant = 0.0
    }
    
    
    func updateDeleteButtonTitle() {
        let deleteCount = self.collectionView?.indexPathsForSelectedItems?.count ?? 0
        deleteButton.setTitle("\(deleteCount)개 테마 삭제", for: .normal)
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
//        cell.setBadge(isNew: theme.isNew, isOwn: false)
        
        if let selectThemeName = theme.name, let currentThemeName = ENKeyboardThemeManager.shared.getCurrentTheme().name {
            if selectThemeName == currentThemeName {
                cell.imageViewSelectIcon.isHidden = false
            } else {
                cell.imageViewSelectIcon.isHidden = true
            }
        } else {
            cell.imageViewSelectIcon.isHidden = true
        }
        
        cell.isEditMode = self.collectionView?.allowsMultipleSelection ?? false
        
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
        
        
        if self.collectionView?.allowsSelection ?? false {
            let isSelected = self.collectionView?.indexPathsForSelectedItems?.contains(indexPath) ?? false
            cell.updateCheckBox(isSelect: isSelected)
        }
    }
    
    override func loadData() {
        self.page += 1
        self.loadThemeData()
    }
}




//MARK:- For UICollectionView
extension ENMyThemeContentViewPresenter {
    
    override func numberOfItems(section: Int) -> Int {
        return dataSource.count
    }
    
    override func sizeForHeader(section: Int) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: ENMyThemeBottomBannerView.needHeight)
    }
    
    override func sizeForFooter(section: Int) -> CGSize {
        if dataSource.count == 0 {
            return CGSize.init(width: UIScreen.main.bounds.width,
                               height: ((collectionView?.frame.size.height ?? ENMyThemeBottomBannerView.needHeight) - (ENMyThemeBottomBannerView.needHeight + 30.0)))
        }
        
        return super.sizeForFooter(section: section)
    }
    
    
    override func dequeueViewForSupplementaryElementOf(kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = super.dequeueViewForSupplementaryElementOf(kind: kind, at: indexPath)
        
        if kind == UICollectionView.elementKindSectionHeader {
            bottomBannerView.removeFromSuperview()
            reusableView.addSubview(bottomBannerView)
            
            bottomBannerView.frame = reusableView.bounds
            bottomBannerView.sizeToFit()
        }
        else if kind == UICollectionView.elementKindSectionFooter {
            emptyView.removeFromSuperview()
            reusableView.addSubview(emptyView)
            
            emptyView.frame = reusableView.bounds
            emptyView.sizeToFit()
            emptyView.isHidden = (dataSource.count > 0)
        }
        
        return reusableView
    }
    
    
    @objc override func didSelectedItem(at indexPath: IndexPath) {
        
        guard let theme = getIndexedData(indexPath: indexPath) else {
            return
        }
        
        guard !(collectionView?.allowsMultipleSelection ?? false) else {
            if theme.name == selectedTheme?.name {
                collectionView?.deselectItem(at: indexPath, animated: false)
            }
            else if let cell = collectionView?.cellForItem(at: indexPath) as? ENThemeCollectionViewCell {
                cell.updateCheckBox(isSelect: true)
            }
            
            updateDeleteButtonTitle()
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
    
    
    override func didDeSelectedItem(at indexPath: IndexPath) {
        
        guard (collectionView?.allowsMultipleSelection ?? false),
              let cell = collectionView?.cellForItem(at: indexPath) as? ENThemeCollectionViewCell,
              let theme = getIndexedData(indexPath: indexPath) else  {
            return
        }
        
        if theme.name == selectedTheme?.name {
            collectionView?.deselectItem(at: indexPath, animated: false)
        }
        else {
            cell.updateCheckBox(isSelect: false)
        }
        
        updateDeleteButtonTitle()
    }
    
}



//MARK:- Control Datas.
extension ENMyThemeContentViewPresenter {
    
    func loadThemeData() {
        if isInReqeust {
            self.page -= 1
            if self.page < 1 { self.page = 1 }
            return
        }
        isInReqeust = true
        
        let request:DHNetwork = DHApi.myThemeList(userId: "test", page: page)
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
    
    
    @objc func deleteSelectedItems() {
        let alert = UIAlertController.init(title: nil, message: "선택한 테마를 삭제합니다. 유료 테마의 경우에도 복구되지 않습니다. 계속하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "확인", style: .default, handler: {[weak self] action in
            guard let self else { return }
            self.removeSelectedTheme()
        }))
        
        delegate?.collectionViewPresenter(self, showDialog: alert)
    }
    
    
    private func removeSelectedTheme() {
        delegate?.collectionViewPresenter(self, showProgress: "선택한 테마를 삭제중 입니다.")
        let selected = self.collectionView?.indexPathsForSelectedItems
        
        var themeList:[ENKeyboardThemeModel] = []
        
        selected?.forEach({ index in
            DHLogger.log("delete : \(index.section) : \(index.row)")
            if let theme = getIndexedData(indexPath: index) {
                themeList.append(theme)
            }
        })
        
        removeThemeFromMyTheme(themeList: themeList) {[weak self] finish in
            guard let self else { return }
            DispatchQueue.main.async {
                self.delegate?.collectionViewPresenter(self, hideProgress: {
                    if self.toggleEditMode() {
                        let _ = self.toggleEditMode()
                    }
                    
                    self.delegate?.exitEditMode(self, deletedCount: selected?.count ?? 0)
                    
                    self.page = 1
                    self.loadThemeData()
//                    self.dataSource.removeAll { item in
//                        if let themeItem = item as? ENKeyboardThemeModel {
//                            return themeList.contains { theme in
//                                return theme.idx == themeItem.idx
//                            }
//                        }
//                        return false
//                    }
                })
            }
            
        }
    }
    
    
    
    func loadBannerData() {
        let request:DHNetwork = DHApi.themeBannerList()
        DHApiClient.shared.fetch(with: request) {[weak self] (result: Result<[ENThemeBannerListModel], DHApiError>) in
            guard let self else { return }
            switch result {
            case .success(let retValue):
                DHLogger.log("\(retValue.debugDescription)")
                
                DispatchQueue.main.async {
                    self.bottomBannerView.bannerList.removeAll()
                    self.bottomBannerView.bannerList = retValue
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
