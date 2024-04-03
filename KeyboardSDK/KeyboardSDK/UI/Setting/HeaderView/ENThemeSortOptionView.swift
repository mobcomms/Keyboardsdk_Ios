//
//  ENThemeSortOptionView.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/06/24.
//

import UIKit


protocol ENThemeSortOptionViewDelegate: AnyObject {
    
    func enThemeSortOptionView(sortOptionView:ENThemeSortOptionView, sortBy isFamous:Bool)
}




class ENThemeSortOptionView: UIView {
    
    static let ID = "ENThemeSortOptionView"
    static let needHeight:CGFloat = 225.0
    
    static func create() -> ENThemeSortOptionView {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENThemeSortOptionView", owner: self, options: nil)
        let tempView = nibViews?.first as! ENThemeSortOptionView
        
        return tempView
    }
    
    
    @IBOutlet weak var sortByRecentButton: ENSortButtonView!
    @IBOutlet weak var sortByFamousButton: ENSortButtonView!
    
    weak var delegate:ENThemeSortOptionViewDelegate? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutInit()
    }
    
    func layoutInit() {
        sortByRecentButton.isUserInteractionEnabled = true
        sortByRecentButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGestureForSortButton(gesture:))))
        
        sortByFamousButton.isUserInteractionEnabled = true
        sortByFamousButton.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGestureForSortButton(gesture:))))
    }
    
    
    
    func updateSortButtonState(isFamousSelected:Bool) {
        sortByFamousButton.isSelected = isFamousSelected
        sortByRecentButton.isSelected = !isFamousSelected
    }
    
    
    @objc func excuteTapGestureForSortButton(gesture:UITapGestureRecognizer) {
        
        switch gesture.view {
        case sortByRecentButton:
            sortByFamousButton.isSelected = false
            sortByRecentButton.isSelected = true
            delegate?.enThemeSortOptionView(sortOptionView: self, sortBy: false)
            break
            
        case sortByFamousButton:
            sortByFamousButton.isSelected = true
            sortByRecentButton.isSelected = false
            delegate?.enThemeSortOptionView(sortOptionView: self, sortBy: true)
            break
            
        default:
            break
        }
        
        
        
    }
    
}
