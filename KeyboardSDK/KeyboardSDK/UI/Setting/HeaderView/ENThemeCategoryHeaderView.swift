//
//  ENThemeCategoryHeaderView.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/06/22.
//

import UIKit
import KeyboardSDKCore



protocol ENThemeCategoryHeaderViewDelegate: AnyObject {
    
    func enThemeCategoryHeaderView(headerView:ENThemeCategoryHeaderView, categorySelected category:ENKeyboardThemeCategoryModel?)
    
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
    
    @IBOutlet weak var textCategoryCollectionView: UICollectionView!
    @IBOutlet var constraintTextCategoryTopMargin: NSLayoutConstraint!
    
    var textCategoryTopMargin: CGFloat = 15.0 {
        didSet {
            constraintTextCategoryTopMargin?.constant = textCategoryTopMargin
            updateContentHeightInfo()
        }
    }
    
    
    
    let defaultMaxHeight:CGFloat = 60.0
    let defaultMinHeight:CGFloat = 50.0
    
    weak var delegate: ENThemeCategoryHeaderViewDelegate?
    
    
    
    var categoryList: [ENKeyboardThemeCategoryModel] = [] {
        didSet {
            selectedIndexPath = nil
            if categoryList.count > 0 {
                selectedCategory = categoryList[0]
            }
            textCategoryCollectionView.reloadData()
            textCategoryCollectionView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 1, height: 1), animated: true)
        }
    }
    
    
    var selectedCategory: ENKeyboardThemeCategoryModel? = nil
    var selectedIndexPath:IndexPath? = nil
    
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
        layoutInit()
        updateContentHeightInfo()
    }
    
    func layoutInit() {
        
        textCategoryCollectionView.register(UINib(nibName: "ENThemeCategoryCollectionViewCell", bundle: Bundle.frameworkBundle),
                                      forCellWithReuseIdentifier: ENThemeCategoryCollectionViewCell.ID)
        textCategoryCollectionView.delegate = self
        textCategoryCollectionView.dataSource = self
        constraintTextCategoryTopMargin.constant = textCategoryTopMargin
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
    
    
    func setUpForRecommandTheme() {
        textCategoryTopMargin = 15.0
        updateContentHeightInfo()
    }
    
    func setUpForTheme() {
        textCategoryTopMargin = 15.0
        updateContentHeightInfo()
    }
    
    func updateContentHeightInfo() {
        constraintTextCategoryTopMargin?.constant = textCategoryTopMargin
        minimumContentHeight = 56.0
        maximumContentHeight = 56.0
    }
}



//MARK:- GSKStretchyHeaderViewStretchDelegate

extension ENThemeCategoryHeaderView: GSKStretchyHeaderViewStretchDelegate {
    
    func stretchyHeaderView(_ headerView: GSKStretchyHeaderView, didChangeStretchFactor stretchFactor: CGFloat) {
    }
}

//MARK:- UICollectionView's Delegate

extension ENThemeCategoryHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            
        case textCategoryCollectionView:
            return categoryList.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case textCategoryCollectionView:
            var needWidth = 10.0
            
            if indexPath.row < categoryList.count {
                let category = categoryList[indexPath.row]
                let textWidth = (category.code_val?.width(withConstrainedHeight: 28, font: UIFont.systemFont(ofSize: 15, weight: .medium)) ?? 0)
                needWidth = Double(5.0 + textWidth)
            }
            
            return CGSize.init(width: needWidth, height: 28.0)
            
        
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
     
        case textCategoryCollectionView:
            return 0.0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
      
        case textCategoryCollectionView:
            return 22.0
                
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case textCategoryCollectionView:
            return cellForTextCategory(collectionView, indexPath: indexPath)
        
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case textCategoryCollectionView:
            if indexPath.row < categoryList.count {
                self.selectedCategory = categoryList[indexPath.row]
            }
            
                reloadItems(collection: textCategoryCollectionView, new: indexPath, old: selectedIndexPath)
            
            
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







//MARK:- for Text Category
extension ENThemeCategoryHeaderView {
    
    func cellForTextCategory(_ collectionView:UICollectionView, indexPath:IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ENThemeCategoryCollectionViewCell.ID, for: indexPath) as? ENThemeCategoryCollectionViewCell
        
        if indexPath.row < categoryList.count {
            let category = categoryList[indexPath.row]
            cell?.labelName.text = category.code_val
            
            if  category.code_id == selectedCategory?.code_id {
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

