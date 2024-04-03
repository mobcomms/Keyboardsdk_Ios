//
//  ENThemeCategoryHeaderView.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/22.
//

import UIKit
import KeyboardSDKCore



protocol ENThemeCategoryHeaderViewDelegate: AnyObject {
    
    func enThemeCategoryHeaderView(headerView:ENThemeCategoryHeaderView, categorySelected category:ENKeyboardThemeCategoryModel?)
    func enThemeCategoryHeaderView(headerView:ENThemeCategoryHeaderView, bannerSelected banner:ENThemeBannerListModel?)
    
    func enThemeCategoryHeaderView(headerView:ENThemeCategoryHeaderView, sortBy isFamous:Bool)
}

extension ENThemeCategoryHeaderViewDelegate {
    func enThemeCategoryHeaderView(headerView:ENThemeCategoryHeaderView, sortBy isFamous:Bool) {}
}



class ENThemeCategoryHeaderView: GSKStretchyHeaderView {
    
    static let ID = "ENThemeCategoryHeaderView"
    static let needHeight:CGFloat = 110.0
    
    static func create() -> ENThemeCategoryHeaderView {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENThemeCategoryHeaderView", owner: self, options: nil)
        let tempView = nibViews?.first as! ENThemeCategoryHeaderView
        
        return tempView
    }
    
    
    
//    @IBOutlet weak var bannerCollectionView: UICollectionView!
//    @IBOutlet weak var pageControl: ENPageControlAleppo!
    
//    @IBOutlet weak var pageControlBackgroundView:UIView!
    
    @IBOutlet weak var textCategoryCollectionView: UICollectionView!
    @IBOutlet weak var colorCategoryCollectionView: UICollectionView!
    
    @IBOutlet weak var sortOptionRootView: UIView!
    @IBOutlet weak var sortByRecentButton: ENSortButtonView!
    @IBOutlet weak var sortByFamousButton: ENSortButtonView!
    
    
//    @IBOutlet var constraintBannerViewHeight: NSLayoutConstraint!
    @IBOutlet var constraintTextCategoryTopMargin: NSLayoutConstraint!
    @IBOutlet var constraintSortButtonViewsHeight: NSLayoutConstraint!
    @IBOutlet var constraintSortButtonViewsTopMargin: NSLayoutConstraint!
    
    
//    var bannerViewHeight: CGFloat = 90.0 {
//        didSet {
//            constraintBannerViewHeight?.constant = bannerViewHeight
//            updateContentHeightInfo()
//        }
//    }
    
    var textCategoryTopMargin: CGFloat = 15.0 {
        didSet {
            constraintTextCategoryTopMargin?.constant = textCategoryTopMargin
            updateContentHeightInfo()
        }
    }
    
    var sortButtonViewsHeight: CGFloat = 14.0 {
        didSet {
            constraintSortButtonViewsHeight?.constant = textCategoryTopMargin
            updateContentHeightInfo()
        }
    }
    
    var sortButtonViewsTopMargin: CGFloat = 26.0 {
        didSet {
            constraintSortButtonViewsTopMargin?.constant = sortButtonViewsTopMargin
            updateContentHeightInfo()
        }
    }
    
    
    let defaultMaxHeight:CGFloat = 110.0
    let defaultMinHeight:CGFloat = 50.0
    
    weak var delegate: ENThemeCategoryHeaderViewDelegate?
    
    
    var bannerList:[ENThemeBannerListModel] = []
//    {
//        didSet {
//            stopAutoScrollBanner()
//
//            bannerCollectionView.reloadData()
//            bannerCollectionView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 1, height: 1), animated: false)
//
//            pageControl.progress = 0
//            pageControl.numberOfPages = bannerList.count
//
//            runAutoScrollBanner()
//        }
//    }
    
    var categoryList: [ENKeyboardThemeCategoryModel] = [] {
        didSet {
//            do {
//                let json = "{\"code_id\": \"\", \"code_desc\": \"추천\"}"
//                if let jsonData = json.data(using: .utf8) {
//                    let recommand = try JSONDecoder().decode(ENKeyboardThemeCategoryModel.self, from: jsonData)
//                    categoryList.insert(recommand, at: 0)
//                }
//            }
//            catch {}
            
            selectedIndexPath = nil
            if categoryList.count > 0 {
                selectedCategory = categoryList[0]
            }
            
            textCategoryCollectionView.reloadData()
            textCategoryCollectionView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 1, height: 1), animated: true)
        }
    }
    
    var colorList: [ENKeyboardThemeCategoryModel] = [] {
        didSet {
            colorCategoryCollectionView.reloadData()
            colorCategoryCollectionView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 1, height: 1), animated: true)
        }
    }
    
    
    var selectedCategory: ENKeyboardThemeCategoryModel? = nil
    var selectedIndexPath:IndexPath? = nil
    var isColor:Bool = false
    
    
    
    var bannerAutoScrollTimer:Timer? = nil
    var bannerCurrentIndex:Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func commonInit() {
        stretchDelegate = self
        self.contentView.backgroundColor = .white
        self.expansionMode = GSKStretchyHeaderViewExpansionMode.topOnly
        self.contentShrinks = true
        self.contentExpands = false
        
//        pageControlBackgroundView.layer.applyRounding(cornerRadius: 9.0, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
        
        layoutInit()
        updateContentHeightInfo()
    }
    
    func layoutInit() {
//        bannerCollectionView.register(UINib(nibName: "ENThemeBannerCollectionViewCell", bundle: Bundle.frameworkBundle),
//                                      forCellWithReuseIdentifier: ENThemeBannerCollectionViewCell.ID)
//        bannerCollectionView.delegate = self
//        bannerCollectionView.dataSource = self
        
        textCategoryCollectionView.register(UINib(nibName: "ENThemeCategoryCollectionViewCell", bundle: Bundle.frameworkBundle),
                                      forCellWithReuseIdentifier: ENThemeCategoryCollectionViewCell.ID)
        textCategoryCollectionView.delegate = self
        textCategoryCollectionView.dataSource = self
        
        colorCategoryCollectionView.register(UINib(nibName: "ENThemeColorCategoryCollectionViewCell", bundle: Bundle.frameworkBundle),
                                             forCellWithReuseIdentifier: ENThemeColorCategoryCollectionViewCell.ID)
        colorCategoryCollectionView.delegate = self
        colorCategoryCollectionView.dataSource = self
        
//        constraintBannerViewHeight.constant = bannerViewHeight
        constraintTextCategoryTopMargin.constant = textCategoryTopMargin
        constraintSortButtonViewsHeight.constant = sortButtonViewsHeight
        constraintSortButtonViewsTopMargin.constant = sortButtonViewsTopMargin
        
        
        sortByRecentButton.isUserInteractionEnabled = true
        sortByRecentButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGestureForSortButton(gesture:))))
        
        sortByFamousButton.isUserInteractionEnabled = true
        sortByFamousButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGestureForSortButton(gesture:))))
        
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
    
    
    func setUpForRecommandTheme() {
        runAutoScrollBanner()
        
//        bannerViewHeight = 90.0
//        bannerViewHeight = 270.0 * (UIScreen.main.bounds.width / 1080.0)
        textCategoryTopMargin = 15.0
        sortButtonViewsTopMargin = 4.0
        sortButtonViewsHeight = 0.0
        
        updateContentHeightInfo()
    }
    
    func setUpForTheme() {
        stopAutoScrollBanner()
        
//        bannerViewHeight = 0.0
//        textCategoryTopMargin = 9.0
        
        
//        bannerViewHeight = 90.0
//        bannerViewHeight = 270.0 * (UIScreen.main.bounds.width / 1080.0)
        textCategoryTopMargin = 15.0
        sortButtonViewsTopMargin = 26.0
        sortButtonViewsHeight = 14.0
        
        updateContentHeightInfo()
    }
    
    func updateContentHeightInfo() {
//        constraintBannerViewHeight?.constant = bannerViewHeight
        constraintTextCategoryTopMargin?.constant = textCategoryTopMargin
        constraintSortButtonViewsHeight?.constant = sortButtonViewsHeight
        constraintSortButtonViewsTopMargin?.constant = sortButtonViewsTopMargin
        
        let defaultLayoutHeight = textCategoryTopMargin + sortButtonViewsTopMargin + sortButtonViewsHeight
        
//        minimumContentHeight = 70 + (defaultLayoutHeight - (textCategoryTopMargin))
//        maximumContentHeight = 70 + defaultLayoutHeight + bannerViewHeight
        
        minimumContentHeight = 90.0
        maximumContentHeight = 90.0
    }
}



//MARK:- GSKStretchyHeaderViewStretchDelegate

extension ENThemeCategoryHeaderView: GSKStretchyHeaderViewStretchDelegate {
    
    func stretchyHeaderView(_ headerView: GSKStretchyHeaderView, didChangeStretchFactor stretchFactor: CGFloat) {
//        if bannerViewHeight > 0 {
//            let stretch = stretchFactor > 1.0 ? 1.0 : stretchFactor
//
//            self.constraintBannerViewHeight?.constant = bannerViewHeight * stretch
//
//            let margin = textCategoryTopMargin / 2.0
//            self.constraintTextCategoryTopMargin?.constant = margin + (margin * stretch)
//
//            if stretch < 0.3 {
//                self.layer.applySketchShadow(color: .black, alpha: 0.15, x: 0, y: 1.3, blur: 3.3, spread: 0)
//            }
//            else {
//                self.layer.applySketchShadow(color: .black, alpha: 0.0, x: 0, y: 1.3, blur: 3.3, spread: 0)
//            }
//        }
    }
}




//MARK:- UICollectionView's Delegate

extension ENThemeCategoryHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
//        case bannerCollectionView:
//            return bannerList.count
            
        case textCategoryCollectionView:
            return categoryList.count
            
        case colorCategoryCollectionView:
            return colorList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
//        case bannerCollectionView:
//            return CGSize.init(width: UIScreen.main.bounds.width, height: bannerViewHeight)
            
        case textCategoryCollectionView:
            var needWidth = 10.0
            
            if indexPath.row < categoryList.count {
                let category = categoryList[indexPath.row]
                let textWidth = (category.code_val?.width(withConstrainedHeight: 28, font: UIFont.systemFont(ofSize: 15, weight: .medium)) ?? 0)
                needWidth = Double(5.0 + textWidth)
            }
            
            return CGSize.init(width: needWidth, height: 28.0)
            
        case colorCategoryCollectionView:
            return CGSize.init(width: 23, height: 23) //ENThemeColorCategoryCollectionViewCell.needSize
            
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case colorCategoryCollectionView:
            return 13.0         // Why????????? ((O_O))
            
        case textCategoryCollectionView:
            return 0.0
                        
//        case bannerCollectionView:
//            return 0.0
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case colorCategoryCollectionView:
            return 13.0                     // Why????????? ((O_O))
            
        case textCategoryCollectionView:
            return 22.0
                        
//        case bannerCollectionView:
//            return 0.0
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
//        case bannerCollectionView:
//            return cellForBanner(indexPath: indexPath)
            
        case textCategoryCollectionView:
            return cellForTextCategory(collectionView, indexPath: indexPath)
        
        case colorCategoryCollectionView:
            return cellForColorCategory(indexPath: indexPath)
        
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
//        case bannerCollectionView:
//            if indexPath.row < bannerList.count {
//                delegate?.enThemeCategoryHeaderView(headerView: self, bannerSelected: bannerList[indexPath.row])
//            }
//
//            break
            
        case textCategoryCollectionView:
            if indexPath.row < categoryList.count {
                self.selectedCategory = categoryList[indexPath.row]
            }
            
            if isColor {
                isColor = false
                if let selectedIndexPath = selectedIndexPath {
                    reloadItems(collection: colorCategoryCollectionView, new: selectedIndexPath, old: nil)
                }
                
                self.selectedIndexPath = indexPath
                reloadItems(collection: textCategoryCollectionView, new: indexPath, old: nil)
            }
            else {
                reloadItems(collection: textCategoryCollectionView, new: indexPath, old: selectedIndexPath)
            }
            
            delegate?.enThemeCategoryHeaderView(headerView: self, categorySelected: self.selectedCategory)
            break
            
        case colorCategoryCollectionView:
            if indexPath.row < colorList.count {
                self.selectedCategory = colorList[indexPath.row]
            }
            
            if !isColor {
                isColor = true
                if let selectedIndexPath = selectedIndexPath {
                    reloadItems(collection: textCategoryCollectionView, new: selectedIndexPath, old: nil)
                }
                
                self.selectedIndexPath = indexPath
                reloadItems(collection: colorCategoryCollectionView, new: indexPath, old: nil)
            }
            else {
                reloadItems(collection: colorCategoryCollectionView, new: indexPath, old: selectedIndexPath)
            }
            
            delegate?.enThemeCategoryHeaderView(headerView: self, categorySelected: self.selectedCategory)
            break
            
        default:
            break
        }
    }
    
    func reloadItems(collection:UICollectionView?, new:IndexPath, old:IndexPath?) {
        if let old = old {
            collection?.reloadItems(at: [new, old])
        }
        else {
            collection?.reloadItems(at: [new])
        }
    }
}



//MARK:- For SortButtons
extension ENThemeCategoryHeaderView {
    
    func updateSortButtonState(isFamousSelected:Bool) {
        sortByFamousButton.isSelected = isFamousSelected
        sortByRecentButton.isSelected = !isFamousSelected
    }
    
    
    @objc func excuteTapGestureForSortButton(gesture:UITapGestureRecognizer) {
        switch gesture.view {
        case sortByRecentButton:
            sortByFamousButton.isSelected = false
            sortByRecentButton.isSelected = true
            delegate?.enThemeCategoryHeaderView(headerView: self, sortBy: false)
            break
            
        case sortByFamousButton:
            sortByFamousButton.isSelected = true
            sortByRecentButton.isSelected = false
            delegate?.enThemeCategoryHeaderView(headerView: self, sortBy: true)
            break
            
        default:
            break
        }
        
        
        
    }
}


//MARK:- UIScrollView Delegate

extension ENThemeCategoryHeaderView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScrollBanner()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if scrollView == bannerCollectionView {
//            let visibles = bannerCollectionView.visibleCells
//
//            var moveIndex:Int = 0
//            visibles.forEach { cell in
//                if let indexPath = bannerCollectionView.indexPath(for: cell), indexPath.row != Int(pageControl.progress) {
//                    moveIndex = indexPath.row
//                }
//            }
//
//            pageControl.progress = Double(moveIndex)
//            bannerCurrentIndex = moveIndex
//
//            runAutoScrollBanner()
//        }
    }
}






//MARK:- for Banner
extension ENThemeCategoryHeaderView {
    
    func runAutoScrollBanner() {
        guard bannerList.count > 0 else { return }
        
        bannerAutoScrollTimer?.invalidate()
        bannerAutoScrollTimer = nil
        
        bannerAutoScrollTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) {[weak self] t in
            guard let self else { return }
            self.bannerCurrentIndex += 1
            if self.bannerCurrentIndex >= self.bannerList.count {
                self.bannerCurrentIndex = 0
            }
            
//            self.bannerCollectionView.scrollToItem(at: IndexPath.init(row: self.bannerCurrentIndex, section: 0), at: .centeredHorizontally, animated: true)
//            self.pageControl.progress = Double(self.bannerCurrentIndex)
        }
    }
    
    
    func stopAutoScrollBanner() {
        bannerAutoScrollTimer?.invalidate()
        bannerCurrentIndex = 0
    }
    
//    func cellForBanner(indexPath:IndexPath) -> UICollectionViewCell {
//        let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: ENThemeBannerCollectionViewCell.ID, for: indexPath) as? ENThemeBannerCollectionViewCell
//
//        if indexPath.row < bannerList.count {
//            let banner = bannerList[indexPath.row]
//            cell?.bannerImageView.loadImageAsync(with: banner.img_path)
//        }
//
//        return cell ?? UICollectionViewCell()
//    }
//
}



//MARK:- for Text Category
extension ENThemeCategoryHeaderView {
    
    func cellForTextCategory(_ collectionView:UICollectionView, indexPath:IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ENThemeCategoryCollectionViewCell.ID, for: indexPath) as? ENThemeCategoryCollectionViewCell
        
        if indexPath.row < categoryList.count {
            let category = categoryList[indexPath.row]
            cell?.labelName.text = category.code_val
            
            if !isColor, category.code_id == selectedCategory?.code_id {
                selectedIndexPath = indexPath
                cell?.setSelectedCategory(isSelected: true)
            }
            else {
                cell?.setSelectedCategory(isSelected: false)
            }
        }
        
        return cell ?? UICollectionViewCell()
    }
    
}



//MARK:- for Color Category
extension ENThemeCategoryHeaderView {
    
    func cellForColorCategory(indexPath:IndexPath) -> UICollectionViewCell {
        let cell = colorCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: ENThemeColorCategoryCollectionViewCell.ID, for: indexPath) as? ENThemeColorCategoryCollectionViewCell
        
        if indexPath.row < colorList.count {
            let category = colorList[indexPath.row]
            
            if let colorCode = category.code_val {
                cell?.colorView.backgroundColor = UIColor.init(hexString: colorCode)
                
                if colorCode.uppercased() == "#FFFFFF" ||
                    colorCode.uppercased() == "FFFFFF" ||
                    colorCode.uppercased() == "#FFFFFFFF" ||
                    colorCode.uppercased() == "FFFFFFFF" {
                    cell?.colorView.layer.borderWidth = 1.0
                }
                else {
                    cell?.colorView.layer.borderWidth = 0.0
                }
            }
            
            
            if isColor, category.code_id == selectedCategory?.code_id {
                selectedIndexPath = indexPath
                cell?.setSelectedCategory(isSelected: true)
            }
            else {
                cell?.setSelectedCategory(isSelected: false)
            }
        }
        
        return cell ?? UICollectionViewCell()
    }
    
}
