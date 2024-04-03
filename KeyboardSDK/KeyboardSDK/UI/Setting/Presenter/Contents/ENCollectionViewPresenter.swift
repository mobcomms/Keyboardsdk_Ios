//
//  ENCollectionViewPresenter.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/18.
//


import UIKit



protocol ENCollectionViewPresenterDelegate: AnyObject {
    func collectionViewPresenter(_ presenter:ENCollectionViewPresenter, showProgress message:String)
    func collectionViewPresenter(_ presenter:ENCollectionViewPresenter, hideProgress completion: (() -> Void)?)
    func collectionViewPresenter(_ presenter:ENCollectionViewPresenter, showErrorMessage message:String)
    
    func collectionViewPresenter(_ presenter:ENCollectionViewPresenter, showDialog dialog:UIViewController)
    
    
    func showKeyboardPreview(_ presenter:ENCollectionViewPresenter)
    func hideKeyboardPreview(_ presenter:ENCollectionViewPresenter)
    
    func openGallery(_ presenter:ENCollectionViewPresenter)
    func editPhoto(_ presenter:ENCollectionViewPresenter, edit image:UIImage)
    
    func exitEditMode(_ presenter:ENCollectionViewPresenter, deletedCount:Int)
    
    
}

class ENCollectionViewPresenter: NSObject {
    
    let ENCollectionViewPresenterHeaderDefault = "__ENCollectionViewPresenter__UICollectionReusableView__Header_default__"
    let ENCollectionViewPresenterFooterDefault = "__ENCollectionViewPresenter__UICollectionReusableView__Footer_default__"
    
    
    weak var delegate:ENCollectionViewPresenterDelegate?
    
    var collectionView:UICollectionView?
    var topButton:UIView? = nil {
        didSet {
            topButton?.isHidden = true
        }
    }
    
    var dataSource:[Any] = []
    
    var numberOfSections:Int = 1
    var minimumLineSpacing:CGFloat = 11.0
    var minimumInteritemSpacing:CGFloat = 10.0
    
    var topButtonHideTimer:Timer? = nil
    
    var page:Int = 0
    var willPaging:Bool = true
    var isInReqeust:Bool = false
    
    init(collectionView:UICollectionView) {
        super.init()
        
        self.collectionView = collectionView
        self.collectionView?.allowsMultipleSelection = false
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        self.collectionView?.contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 15.0, right: 0.0)
        
        self.collectionView?.register(UINib.init(nibName: "ENThemeCollectionViewCell", bundle: Bundle.frameworkBundle), forCellWithReuseIdentifier: ENThemeCollectionViewCell.ID)
        self.collectionView?.register(UINib.init(nibName: "ENPhotoThemeCollectionViewCell", bundle: Bundle.frameworkBundle), forCellWithReuseIdentifier: ENPhotoThemeCollectionViewCell.ID)
        
        self.collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ENCollectionViewPresenterHeaderDefault)
        self.collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ENCollectionViewPresenterFooterDefault)
    }
    
    @objc func updateCellData(for cell:UICollectionViewCell?, indexPath: IndexPath) {
        //Need Override
    }
    
    @objc func loadData() {
        self.collectionView?.reloadData()
    }
}




//MARK:- For UICollectionView
extension ENCollectionViewPresenter {
    
    @objc func numberOfItems(section:Int) -> Int {
        return dataSource.count
    }
    
    @objc func dequeueCell(for indexPath:IndexPath) -> UICollectionViewCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: ENThemeCollectionViewCell.ID, for: indexPath) as? ENThemeCollectionViewCell
        updateCellData(for: cell, indexPath: indexPath)
        
        return cell ?? UICollectionViewCell.init()
    }
    
    @objc func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let needSize = ENThemeCollectionViewCell.needSize
        let width = (UIScreen.main.bounds.width - (15.0 + 15.0 + minimumInteritemSpacing)) / 2.0
        
        return CGSize.init(width: width, height: ((width * needSize.height) / needSize.width))
    }
    
    @objc func reloadItems(collection:UICollectionView?, new:IndexPath, old:IndexPath?) {
        if new == old {
            return
        }
        
        if let old = old {
            collection?.reloadItems(at: [new, old])
        }
        else {
            collection?.reloadItems(at: [new])
        }
    }
    
    @objc func insetForSectionAt(section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0.0, left: 14.0, bottom: 0.0, right: 14.0)
    }
    
    @objc func sizeForHeader(section:Int) -> CGSize {
        return .zero
    }
    
    @objc func sizeForFooter(section:Int) -> CGSize {
        return .zero
    }
    
    
    @objc func dequeueViewForSupplementaryElementOf(kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            return collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ENCollectionViewPresenterHeaderDefault, for: indexPath) ?? UICollectionReusableView()
        }
        else {
            return collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ENCollectionViewPresenterFooterDefault, for: indexPath) ?? UICollectionReusableView()
        }
        
        
        
    }
    
    
    @objc func didSelectedItem(at indexPath: IndexPath) {
        //Need Override
    }
    
    @objc func didDeSelectedItem(at indexPath: IndexPath) {
        //Need Override
    }
}



extension ENCollectionViewPresenter: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        runTopButtonHideTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        topButtonHideTimer?.invalidate()
        topButtonHideTimer = nil
        topButton?.isHidden = !(scrollView.contentOffset.y > UIScreen.main.bounds.height)
        
        
        guard willPaging else { return }
        
        
        var minRow = 0
        
        for indexPath in collectionView?.indexPathsForVisibleItems ?? [] {
            if indexPath.row > minRow {
                minRow = indexPath.row
            }
        }
        
        if (minRow >= (dataSource.count - 7)) && page > 0 {
            loadData()
        }
    }
    
    
    func runTopButtonHideTimer() {
        topButtonHideTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { [weak self] (t) in
            guard let self else { return }
            self.topButton?.isHidden = true
        })
    }
}




//MARK:- UICollectionView Delegate

extension ENCollectionViewPresenter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(section: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueCell(for: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetForSectionAt(section: section)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return dequeueViewForSupplementaryElementOf(kind: kind, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return sizeForHeader(section: section)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return sizeForFooter(section: section)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectedItem(at: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.didDeSelectedItem(at: indexPath)
    }
    
}
