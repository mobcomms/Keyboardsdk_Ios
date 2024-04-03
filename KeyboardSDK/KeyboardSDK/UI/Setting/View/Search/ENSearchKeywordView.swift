//
//  ENSearchKeywordView.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/06.
//

import UIKit
import KeyboardSDKCore

protocol ENSearchKeywordViewDelegate: AnyObject {
    func search(By keyword:String, keywordView: ENSearchKeywordView)
}


class ENSearchKeywordView: UIView {
    
    static func create() -> ENSearchKeywordView {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENSearchKeywordView", owner: self, options: nil)
        let tempView = nibViews?.first as! ENSearchKeywordView
        
        return tempView
    }
    
    @IBOutlet weak var recentKeywordTagListView: ENTagListView!
    @IBOutlet weak var realtimeKeywordTagListView: ENTagListView!
    
    @IBOutlet weak var deleteRecentButton: UIButton!
    
    @IBOutlet weak var recentKeywordRootView: UIView!
    @IBOutlet weak var recentKeywordHeight: NSLayoutConstraint!
    
    
    
    
    weak var delegate: ENSearchKeywordViewDelegate? = nil
    var keywordType:ENKeywordType = .theme
    
    var recentKeywordList:[ENKeywordModel] = [] {
        didSet {
            self.updateRecentKeywordList()
        }
    }
    
    var realtimeKeywordList:[ENKeywordModel] = [] {
        didSet {
            self.updateRealtimeKeywordList()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutInit()
    }
    
    func layoutInit() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        recentKeywordTagListView.textFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        recentKeywordTagListView.delegate = self
        
        realtimeKeywordTagListView.textFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        realtimeKeywordTagListView.delegate = self
        
        updateRecentKeywordListViewHide()
        
        updateRecentKeywordList()
        updateRealtimeKeywordList()
    }
    
    
    @IBAction func deleteRecentButtonClicked(_ sender: Any) {
        deleteRecentButton.isSelected.toggle()
        recentKeywordTagListView.enableRemoveButton = deleteRecentButton.isSelected
    }
    
    
    private func updateRecentKeywordList() {
        recentKeywordTagListView.removeAllTags()
        
        for index in 0..<recentKeywordList.count {
            let tag = recentKeywordList[index]
            if let word = tag.word, let idx = tag.idx {
                let tagView = recentKeywordTagListView.addTag(word)
                tagView.tag = Int(idx) ?? 0
            }
        }
        
        updateRecentKeywordListViewHide()
    }
    
    private func updateRealtimeKeywordList() {
        realtimeKeywordTagListView.removeAllTags()
        
        realtimeKeywordTagListView.addTags(realtimeKeywordList.compactMap({ model in
            return model.word
        }))
    }
    
}



extension ENSearchKeywordView: ENTagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: ENTagView, sender: ENTagListView) {
        if sender == recentKeywordTagListView && sender.enableRemoveButton {
            sender.removeTagView(tagView)
            removeTagItem(title, tagView: tagView)
        }
        else {
            delegate?.search(By: title, keywordView: self)
        }
    }
    
    
    func tagRemoveButtonPressed(_ title: String, tagView: ENTagView, sender: ENTagListView) {
        if sender == recentKeywordTagListView {
            sender.removeTagView(tagView)
            removeTagItem(title, tagView: tagView)
        }
    }
    
    func removeTagItem(_ title:String, tagView: ENTagView) {
        var idx = "\(tagView.tag)"
        if idx != "0" {
            let tag = recentKeywordList.first { model in
                return model.word == title
            }
            
            idx = tag?.idx ?? "0"
            
            if let tag = tag {
                recentKeywordList.removeAll { model in
                    return model.idx == tag.idx
                }
            }
        }
        
        updateRecentKeywordListViewHide()
        
        guard idx != "0" else { return }
        
        let request:DHNetwork = DHApi.removeSearchKeyword(word:title, userId: "test", type: keywordType)
        DHApiClient.shared.fetch(with: request) { (result: Result<Dictionary<String, String>, DHApiError>) in
            switch result {
            case .success(let retValue):
                DHLogger.log("\(retValue.debugDescription)")
                break
            case .failure(let error):
                DHLogger.log("\(error.localizedDescription)")
                break
                
            @unknown default:
                break
            }
        }
    }
    
    
    
    func updateRecentKeywordListViewHide() {
        if recentKeywordList.count > 0 {
            recentKeywordRootView?.isHidden = false
            recentKeywordHeight?.constant = 0.0
            recentKeywordHeight?.isActive = false
        }
        else {
            recentKeywordRootView?.isHidden = false
            if recentKeywordHeight == nil {
                recentKeywordHeight = recentKeywordRootView.heightAnchor.constraint(equalToConstant: 0.0)
            }
            recentKeywordHeight?.isActive = true
        }
        
//        recentKeywordRootView.updateConstraints()
        recentKeywordRootView.layoutIfNeeded()
    }
    
    
}
