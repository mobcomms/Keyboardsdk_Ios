//
//  ENThemeSearchEmptyView.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/07.
//

import UIKit

protocol ENThemeSearchEmptyViewDelegate: AnyObject {
    func search(By keyword:String, from view: ENThemeSearchEmptyView)
}


class ENThemeSearchEmptyView: UIView {
    
    static func create() -> ENThemeSearchEmptyView {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENThemeSearchEmptyView", owner: self, options: nil)
        let tempView = nibViews?.first as! ENThemeSearchEmptyView
        
        return tempView
    }
    
    @IBOutlet weak var recommandKeywordTagListView: ENTagListView!
    
    weak var delegate: ENThemeSearchEmptyViewDelegate? = nil
    
    var recommandKeywordList:[ENKeywordModel] = [] {
        didSet {
            self.updateRecommandKeywordList()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutInit()
    }
    
    func layoutInit() {
        
        recommandKeywordTagListView.textFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        recommandKeywordTagListView.delegate = self
        
        
        updateRecommandKeywordList()
    }
    
    
    private func updateRecommandKeywordList() {
        recommandKeywordTagListView.removeAllTags()
        recommandKeywordTagListView.addTags(recommandKeywordList.compactMap({ keyword in
            return keyword.word
        }))
    }
    
}



extension ENThemeSearchEmptyView: ENTagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: ENTagView, sender: ENTagListView) {
        delegate?.search(By: title, from: self)
    }
    
    
    func tagRemoveButtonPressed(_ title: String, tagView: ENTagView, sender: ENTagListView) {
    }
}

