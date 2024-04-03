//
//  ENThemeManageViewController.swift
//  KeyboardSDKCore
//
//  Created by enlipleIOS1 on 2021/05/17.
//

import UIKit
import KeyboardSDKCore

public class ENThemeManageViewController: UIViewController, ENViewPrsenter {
    
    public static func create(theme:ENKeyboardThemeModel? = nil) -> ENThemeManageViewController {
        let vc = ENThemeManageViewController.init(nibName: "ENThemeManageViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        vc.focusTheme = theme
        
        return vc
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var keyboardSampleView: UIView!
    @IBOutlet weak var keyboardSampleViewHeight: NSLayoutConstraint!
    
    var themeData:ENKeyboardThemeListModel? = nil
    
    var selectedTheme: ENKeyboardThemeModel? = nil
    var selectedCagegoryCode:String = "00"
    
    var downloadProgressView: UIViewController = UIViewController.init()
    var progressViewMessageLable:UILabel = UILabel()
    var indicatorVeiw: ENActivityIndicatorView? = nil
    
    
    var currentSelectedIndex:IndexPath? = nil
    var currentSelectedCategoryIndex:IndexPath? = nil
    
    var focusTheme:ENKeyboardThemeModel? = nil
    
    var keyboardViewManager:ENKeyboardViewManager = ENKeyboardViewManager.init(proxy: nil, needsInputModeSwitchKey: true)
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        initKeyboardView()
        
        initProgressView()
        
        selectedTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        
        collectionView.register(UINib.init(nibName: "ENThemeCollectionViewCell", bundle: Bundle.frameworkBundle), forCellWithReuseIdentifier: ENThemeCollectionViewCell.ID)
        collectionView.contentInset = UIEdgeInsets.init(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        
        categoryCollectionView.register(UINib.init(nibName: "ENThemeCategoryCollectionViewCell", bundle: Bundle.frameworkBundle), forCellWithReuseIdentifier: ENThemeCategoryCollectionViewCell.ID)
        
        loadThemeData(inLoad: true)
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        let parent = self.presentingViewController as? ENSettingViewController
        parent?.reloadData()
        
        enDismiss()
    }
    
    @IBAction func confirmThemeButtonClicked(_ sender: Any) {
        if let theme = selectedTheme {
            self.showProgressView(with: "테마 적용중입니다.")
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                timer.invalidate()
                
                ENKeyboardThemeManager.shared.saveSelectedThemeInfo(theme: theme)
                self.dismiss(animated: true) {
                    self.hideKeyboard()
                }
            }
        }
        else {
            hideKeyboard()
        }
    }
    
    @IBAction func cancelThemeButtonClicked(_ sender: Any) {
        hideKeyboard()
    }
    
    
    
    func loadThemeData(inLoad:Bool = false, notUpdateCategory:Bool = false) {
//        let request:DHNetwork = DHApi.themeList(userId: "", partnerCode: "00", category: selectedCagegoryCode)
//        DHApiClient.shared.fetch(with: request) { (result: Result<ENKeyboardThemeListModel, DHApiError>) in
//            switch result {
//            case .success(let retValue):
//                DHLogger.log("\(retValue.debugDescription)")
//                self.themeData = retValue
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                    
//                    if !notUpdateCategory {
//                        self.categoryCollectionView.reloadData()
//                    }
//
//                    if inLoad, let focusTheme = self.focusTheme, let data = self.themeData?.data {
//                        for index in 0..<data.count {
//                            let theme = data[index]
//                            if theme.name == focusTheme.name {
//                                UIView.animate(withDuration: 0.2, delay: 0.5, options: .curveEaseInOut) {
//                                    self.collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .top, animated: false)
//                                } completion: { finish in
//                                    self.collectionView.selectItem(at: IndexPath.init(row: index, section: 0), animated: false, scrollPosition: .top)
//                                }
//                                break
//                            }
//                        }
//                    }
//
//                    self.focusTheme = nil
//                }
//                break
//
//            case .failure(let error):
//                DHLogger.log("\(error.localizedDescription)")
//                break
//            @unknown default:
//                break
//            }
//        }
    }
    
}


extension ENThemeManageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoryCollectionView == collectionView {
//            return themeData?.category?.count ?? 0
            return 0
        }
        else {
            return themeData?.data?.count ?? 0
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var retCell:UICollectionViewCell? = nil
        
        if categoryCollectionView == collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ENThemeCategoryCollectionViewCell.ID, for: indexPath) as? ENThemeCategoryCollectionViewCell
//            if let category = themeData?.category?[indexPath.row] {
//                cell?.labelName.text = category.code_val
//
//                if category.code_id == selectedCagegoryCode {
//                    currentSelectedCategoryIndex = indexPath
//                    cell?.setSelectedCategory(isSelected: true)
//                }
//                else {
//                    cell?.setSelectedCategory(isSelected: false)
//                }
//            }
            retCell = cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ENThemeCollectionViewCell.ID, for: indexPath) as? ENThemeCollectionViewCell
            
            if let theme = themeData?.data?[indexPath.row] {
                cell?.imageViewThumbnail.loadImageAsync(with: theme.image)
                cell?.labelName.text = theme.name
                
                if theme.name == selectedTheme?.name {
                    currentSelectedIndex = indexPath
                    cell?.setSelectedTheme(isSelected: true)
                }
                else {
                    cell?.setSelectedTheme(isSelected: false)
                }
            }
            retCell = cell
        }
        
        
        return retCell ?? UICollectionViewCell.init()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if categoryCollectionView == collectionView {
            return 0.1
        }
        
        return 15.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if categoryCollectionView == collectionView {
            return 0.1
        }
        
        return 10.0
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if categoryCollectionView == collectionView {
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ENThemeCategoryCollectionViewCell.ID, for: indexPath) as? ENThemeCategoryCollectionViewCell,
//               let category = themeData?.category?[indexPath.row],
//               let themeName = category.code_val
//            {
//                var needWidth = themeName.width(withConstrainedHeight: 50.0, font: cell.labelName.font) + 30.0
//                if needWidth < 70 {
//                    needWidth = 70
//                }
//                return CGSize.init(width: needWidth, height: 50.0)
//            }
//            else {
//                return CGSize.init(width: 50, height: 50)
//            }
            return .zero
        }
        else {
            let needSize = ENThemeCollectionViewCell.needSize
            let width = (UIScreen.main.bounds.width - (15.0 + 15.0 + 10.0)) / 2.0
            
            return CGSize.init(width: width, height: ((width * needSize.height) / needSize.width))
        }
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categoryCollectionView == collectionView {
//            if indexPath != currentSelectedCategoryIndex, let category = themeData?.category?[indexPath.row] {
//                self.selectedCagegoryCode = category.code_id ?? "00"
//                self.reloadItems(collection: collectionView, new: indexPath, old: self.currentSelectedCategoryIndex)
//                
//                loadThemeData(notUpdateCategory: true)
//                self.collectionView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 1, height: 1), animated: false)
//            }
        }
        else {
            if indexPath != currentSelectedIndex, let theme = themeData?.data?[indexPath.row] {
                let themeFileInfo = theme.themeFileInfo()
                
                if !(ENKeyboardThemeManager.shared.alreadyDownlaoded(theme: themeFileInfo)) {
                    
                    self.showProgressView(with: "Download...")
                    
                    ENKeyboardThemeManager.shared.download(theme: themeFileInfo) { result in
                        if result {
                            DispatchQueue.main.async {
                                self.hideProgressView {
                                    self.selectedTheme = theme
                                    self.reloadItems(collection: collectionView, new: indexPath, old: self.currentSelectedIndex)
                                    
                                    self.showKeyboard()
                                }
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.hideProgressView {
                                    self.showErrorMessage(message: "테마 파일 다운로드를\n실패하였습니다.")
                                    DHLogger.log("Fail Theme Name  : \(theme.name ?? "")")
                                    DHLogger.log("Fail URL[Common] : \(theme.common_down_path ?? "")")
                                    DHLogger.log("Fail URL[Custom] : \(theme.custom_down_path ?? "")")
                                }
                            }
                            
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.selectedTheme = theme
                        self.reloadItems(collection: collectionView, new: indexPath, old: self.currentSelectedIndex)
                        
                        self.showKeyboard()
                    }
                }
            }
        }
    }
    
    
    private func reloadItems(collection:UICollectionView, new:IndexPath, old:IndexPath?) {
        if let old = old {
            collection.reloadItems(at: [new, old])
        }
        else {
            collection.reloadItems(at: [new])
        }
    }
}


//MARK:- ProgressDialogView
extension ENThemeManageViewController {
    
    func initProgressView() {
        
        let root = UIView()
        root.backgroundColor = .clear
        
        progressViewMessageLable.text = "Download..."
        progressViewMessageLable.textColor = .white
        progressViewMessageLable.textAlignment = .center
        progressViewMessageLable.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        
        indicatorVeiw = ENActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 70, height: 70), type: .ballClipRotate, color: .white, padding: nil)
        
        root.addSubview(indicatorVeiw!)
        root.addSubview(progressViewMessageLable)
        
        
        root.translatesAutoresizingMaskIntoConstraints = false
        indicatorVeiw?.translatesAutoresizingMaskIntoConstraints = false
        progressViewMessageLable.translatesAutoresizingMaskIntoConstraints = false
        
        var layoutConstraints:[NSLayoutConstraint] = []
        let views: [String: Any] = [
            "label": progressViewMessageLable,
            "indicatorVeiw": indicatorVeiw!,
            "root": root,
            "parent": downloadProgressView.view as Any
        ]
        
        downloadProgressView.view.addSubview(root)
        downloadProgressView.view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.3)
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[indicatorVeiw]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[indicatorVeiw(70)]-5-[label]|", metrics: nil, views: views)
        layoutConstraints += [
            NSLayoutConstraint.init(item: root, attribute: .centerX, relatedBy: .equal, toItem: downloadProgressView.view, attribute: .centerX, multiplier: 1.0, constant: 1.0),
            NSLayoutConstraint.init(item: root, attribute: .centerY, relatedBy: .equal, toItem: downloadProgressView.view, attribute: .centerY, multiplier: 1.0, constant: 1.0)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
        
        downloadProgressView.modalPresentationStyle = .overFullScreen
        downloadProgressView.modalTransitionStyle = .crossDissolve
    }
    
    
    func showProgressView(with message:String) {
        progressViewMessageLable.text = message
        self.indicatorVeiw?.startAnimating()
        self.present(downloadProgressView, animated: true, completion: nil)
    }
    
    
    func hideProgressView(completion: (() -> Void)? = nil) {
        self.downloadProgressView.dismiss(animated: true) {
            self.indicatorVeiw?.stopAnimating()
            completion?()
        }
    }
}



//MARK:- Keyboard Theme Preview
extension ENThemeManageViewController {
    
    func initKeyboardView() {
        let keyboard = keyboardViewManager.loadKeyboardView()
        self.keyboardSampleView.addSubview(keyboard)
        
        self.keyboardViewManager.updateConstraints()
        self.keyboardViewManager.updateKeys()
        
        let label = UILabel()
        label.text = "Keyboard Sample"
        label.textAlignment = .center
        label.frame = keyboardViewManager.customView.bounds
        label.frame.size.height = 50.0
        label.frame.size.width = UIScreen.main.bounds.width
        keyboardViewManager.customView.backgroundColor = UIColor.init(white: 0.8, alpha: 0.5)
        
        keyboardViewManager.initCustomArea(with: label)
        
        self.keyboardSampleViewHeight.constant = 0
    }
    
    func showKeyboard() {
        let currentTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        let themeFileInfo = self.selectedTheme?.themeFileInfo() ?? currentTheme.themeFileInfo()
        
        ENKeyboardThemeManager.shared.loadTheme(theme: themeFileInfo) { theme in
            self.keyboardViewManager.keyboardTheme = theme
            self.keyboardSampleViewHeight.constant = 45.0 + (self.keyboardViewManager.heightConstraint?.constant ?? 0.0)
        }
    }
    
    
    func hideKeyboard() {
        self.keyboardSampleViewHeight.constant = 0
    }
    
    
    
    
}
