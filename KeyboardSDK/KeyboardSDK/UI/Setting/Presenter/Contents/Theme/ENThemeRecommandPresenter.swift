//
//  ENThemeRecommandPresenter.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/21.
//

import Foundation
import KeyboardSDKCore


class ENThemeRecommandSectionHeaderView: UICollectionReusableView {
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
        label.textColor = UIColor.titleLabel
        
        return label
    }()
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints:[NSLayoutConstraint] = []
        let views: [String: Any] = [
            "titleLabel": titleLabel
        ]
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[titleLabel]-14-|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[titleLabel(27)]-11-|", metrics: nil, views: views)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
}

class ENThemeRecommandPresenter: ENCollectionViewPresenter {
    
    let SectionHeaderViewID:String = "ENThemeRecommandPresenter_SectionHeaderViewID"
    
    var selectedTheme: ENKeyboardThemeModel? = nil
    var focusTheme:ENKeyboardThemeModel? = nil
    
    var currentSelectedIndex:IndexPath? = nil
    var currentSelectedCategoryIndex:IndexPath? = nil
    
    
    
    override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
        
        self.collectionView?.register(ENThemeRecommandSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderViewID)
        
        self.selectedTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        self.numberOfSections = 2
        willPaging = false
    }
    
    
    private func getIndexedData(indexPath: IndexPath) -> ENKeyboardThemeModel? {
        guard dataSource.count > indexPath.section, let subItem = (dataSource[indexPath.section] as? Array<Any>), subItem.count > indexPath.row else {
            return nil
        }
        
        return subItem[indexPath.row] as? ENKeyboardThemeModel
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
            if self.currentSelectedIndex == nil {
                self.currentSelectedIndex = indexPath
            }
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
    
    override func loadData() {
        self.loadThemeData()
    }
    
    
    func updateSelectedThemeDataTo(isOwn:Bool) {
        
        for index in 0..<dataSource.count {
            guard let subItem = (dataSource[index] as? Array<Any>) else {
                continue
            }
            
            for subIndex in 0..<subItem.count {
                let theme = subItem[subIndex] as? ENKeyboardThemeModel
                
                if theme?.idx == selectedTheme?.idx {
                    theme?.isOwn = isOwn
                }
            }
        }
        
        self.collectionView?.reloadData()
    }
    
}

//MARK:- For UICollectionView
extension ENThemeRecommandPresenter {
    
    override func numberOfItems(section: Int) -> Int {
        guard dataSource.count > section, let subItem = (dataSource[section] as? Array<Any>) else {
            return 0
        }
        
        return subItem.count
    }
    
    override func sizeForHeader(section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width - (15.0 + 15.0)
        return CGSize.init(width: width, height: 50.0)
    }
    
    override func sizeForFooter(section: Int) -> CGSize {
        let width = UIScreen.main.bounds.width - (15.0 + 15.0)
        return CGSize.init(width: width, height: 12.0)
    }
    
    
    override func dequeueViewForSupplementaryElementOf(kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderViewID, for: indexPath) as? ENThemeRecommandSectionHeaderView
            if indexPath.section == 0 {
                header?.titleLabel.text = "오늘의 인기테마"
            }
            else {
                header?.titleLabel.text = "오늘의 추천테마"
                
            }
            
            return header ?? super.dequeueViewForSupplementaryElementOf(kind: kind, at: indexPath)
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
                        self.delegate?.collectionViewPresenter(self, hideProgress: { [weak self] in
                            guard let self else { return }
                            self.selectedTheme = theme
                            self.updateSections(old: self.currentSelectedIndex, new: indexPath)
                            self.delegate?.showKeyboardPreview(self)
                        })
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.delegate?.collectionViewPresenter(self, hideProgress: { [weak self] in
                            guard let self else { return }
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
                self.updateSections(old: self.currentSelectedIndex, new: indexPath)
                self.delegate?.showKeyboardPreview(self)
            }
        }
    }
    
    
    func updateSections(old:IndexPath?, new:IndexPath) {
        self.currentSelectedIndex = new
        
        if let old = old, new.section != old.section {
            self.collectionView?.reloadSections(IndexSet.init(integer: old.section))
            self.reloadItems(collection: self.collectionView, new: new, old: old)
        }
        else {
            self.reloadItems(collection: self.collectionView, new: new, old: old)
        }
    }
}



//MARK:- load data
extension ENThemeRecommandPresenter {
    
    func loadThemeData() {
        let request:DHNetwork = DHApi.themeList(cateCode: "", userId: "test")
//        print("path : \(request.path)")
//        print("param : \(request.parameters)")
//        print("method : \(request.method)")
//        print("isBodyData : \(request.isBodyData)")
//        print("dataEncoding : \(request.dataEncoding)")
//        let url = "https://api.cashkeyboard.co.kr/API/renew_theme/theme_list.php"
//        var components = URLComponents(string: url)!
//        let parameters: [String: String] = [
//            "sort": "0",
//            "np": "1",
//            "uuid": "test"
//        ]
//        components.queryItems = parameters.map{ key, value in
//            URLQueryItem(name: key, value: value)
//        }
//
//        guard let finalURL = components.url else {
//            print("finalURL error")
//            return
//        }
//
//        let re = URLRequest(url: finalURL)
//
//        let task = URLSession.shared.dataTask(with: re) { (data, response, error) in
//            if let error = error {
//                print("API 요청 실패 : \(error)")
//                return
//            }
//
//            if let data = data {
//                do {
//                    print("API 성공 : \(data)")
//                }catch {
//                    print("API 파싱 오류")
//                }
//            }
//        }
        DHApiClient.shared.fetch(with: request) { [weak self] (result: Result<ENRecommandThemeListModel, DHApiError>) in
            guard let self else { return }
            switch result {
            case .success(let retValue):
                print("ENThemeRecommandPresenter load theme : \(retValue.debugDescription)")
//                DHLogger.log("\(retValue.debugDescription)")

                if let data = retValue.data {
                    self.dataSource.append(contentsOf:[
                        data.theme_favor ?? [],
                        data.theme_recommend ?? []
                    ])
                }



                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                break

            case .failure(let error):
                print("ENThemeRecommandPresenter load theme error : \(error.localizedDescription)")
//                DHLogger.log("\(error.localizedDescription)")
                break

            @unknown default:
                break
            }
        }
    }
    
}
