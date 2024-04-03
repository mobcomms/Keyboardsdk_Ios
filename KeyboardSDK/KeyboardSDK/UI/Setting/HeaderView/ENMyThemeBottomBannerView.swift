//
//  ENMyThemeBottomBannerView.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/05.
//

import UIKit


protocol ENMyThemeBottomBannerViewDelegate: AnyObject {
    func enThemeCategoryHeaderView(headerView:ENMyThemeBottomBannerView, bannerSelected banner:ENThemeBannerListModel?)
}

class ENMyThemeBottomBannerView: UIView {
    
    static let ID = "ENMyThemeBottomBannerView"
    static let needHeight:CGFloat = ((270.0 * (UIScreen.main.bounds.width / 1080.0)) + 12)
    
    static func create() -> ENMyThemeBottomBannerView {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENMyThemeBottomBannerView", owner: self, options: nil)
        let tempView = nibViews?.first as! ENMyThemeBottomBannerView
        
        return tempView
    }
    
    
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: ENPageControlAleppo!
    
    @IBOutlet weak var pageControlBackgroundView: UIView!
    
    weak var delegate: ENMyThemeBottomBannerViewDelegate?
    
    
    var bannerList:[ENThemeBannerListModel] = [] {
        didSet {
            stopAutoScrollBanner()
            
            bannerCollectionView.reloadData()
            bannerCollectionView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 1, height: 1), animated: false)
            
            pageControl.progress = 0
            pageControl.numberOfPages = bannerList.count
            
            runAutoScrollBanner()
        }
    }
    
    var bannerAutoScrollTimer:Timer? = nil
    var bannerCurrentIndex:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutInit()
    }
    
    func layoutInit() {
        bannerCollectionView.register(UINib(nibName: "ENThemeBannerCollectionViewCell", bundle: Bundle.frameworkBundle),
                                      forCellWithReuseIdentifier: ENThemeBannerCollectionViewCell.ID)
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.contentInset = UIEdgeInsets.zero
        
        pageControlBackgroundView.layer.applyRounding(cornerRadius: 9.0, borderColor: .clear, borderWidth: 0.0, masksToBounds: true)
    }
}





//MARK:- UICollectionView's Delegate

extension ENMyThemeBottomBannerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: ENMyThemeBottomBannerView.needHeight - 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellForBanner(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < bannerList.count {
            delegate?.enThemeCategoryHeaderView(headerView: self, bannerSelected: bannerList[indexPath.row])
        }
    }
}






//MARK:- UIScrollView Delegate

extension ENMyThemeBottomBannerView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScrollBanner()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == bannerCollectionView {
            let visibles = bannerCollectionView.visibleCells
            
            var moveIndex:Int = 0
            visibles.forEach { cell in
                if let indexPath = bannerCollectionView.indexPath(for: cell), indexPath.row != Int(pageControl.progress) {
                    moveIndex = indexPath.row
                }
            }
            
            pageControl.progress = Double(moveIndex)
            bannerCurrentIndex = moveIndex
            
            runAutoScrollBanner()
        }
    }
}




//MARK:- for Banner
extension ENMyThemeBottomBannerView {
    
    func runAutoScrollBanner() {
        guard bannerList.count > 0 else { return }
        
        bannerAutoScrollTimer?.invalidate()
        bannerAutoScrollTimer = nil
        
        bannerAutoScrollTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { t in
            self.bannerCurrentIndex += 1
            if self.bannerCurrentIndex >= self.bannerList.count {
                self.bannerCurrentIndex = 0
            }
            
            self.bannerCollectionView.scrollToItem(at: IndexPath.init(row: self.bannerCurrentIndex, section: 0), at: .centeredHorizontally, animated: true)
            self.pageControl.progress = Double(self.bannerCurrentIndex)
        }
    }
    
    
    func stopAutoScrollBanner() {
        bannerAutoScrollTimer?.invalidate()
        bannerCurrentIndex = 0
    }
    
    func cellForBanner(indexPath:IndexPath) -> UICollectionViewCell {
        let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: ENThemeBannerCollectionViewCell.ID, for: indexPath) as? ENThemeBannerCollectionViewCell
        
        if indexPath.row < bannerList.count {
            let banner = bannerList[indexPath.row]
            cell?.bannerImageView.loadImageAsync(with: banner.img_path)
        }
        
        return cell ?? UICollectionViewCell()
    }
    
}
