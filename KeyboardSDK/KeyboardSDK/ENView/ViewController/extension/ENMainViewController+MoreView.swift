//
//  ENMainViewController+MoreView.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/18.
//

import Foundation

extension ENMainViewController {
    /// 더보기 화면 UI 를 세팅하는 부분
    /// 아직 API 를 연동하지 않음
    /// 꼭 해줘야함!!!!!!!!
    func moreViewSettingUI() {
        moreViewWidthConstraint.constant = UIScreen.main.bounds.width
        
        viewMyPoint.layer.cornerRadius = 16
        
        /// 여기부터는 데이터 로드 후 세팅하면 됨. 필수임!!!!!!!
        
        lblMyPoint.text = "0 P"
        
        let viewMyPointTap = UITapGestureRecognizer(target: self, action: #selector(viewMyPointHandler(_:)))
        viewMyPoint.addGestureRecognizer(viewMyPointTap)
        
        let viewDayCheckTap = UITapGestureRecognizer(target: self, action: #selector(viewDayCheckHandler(_:)))
        viewDayCheck.addGestureRecognizer(viewDayCheckTap)
        
        let viewTypingTap = UITapGestureRecognizer(target: self, action: #selector(viewTypingHandler(_:)))
        viewTyping.addGestureRecognizer(viewTypingTap)
        
        let viewBonusTap = UITapGestureRecognizer(target: self, action: #selector(viewBonusHandler(_:)))
        viewBonus.addGestureRecognizer(viewBonusTap)
    }
    
    @objc func viewMyPointHandler(_ sender: UITapGestureRecognizer) {
        let vc = ENMyPointViewController.create()
        enPresent(vc, animated: true)
    }
    
    @objc func viewDayCheckHandler(_ sender: UITapGestureRecognizer) {
        let vc = ENDayCheckViewController.create()
        enPresent(vc, animated: true)
    }
    
    @objc func viewTypingHandler(_ sender: UITapGestureRecognizer) {
        let vc = ENTypingViewController.create()
        enPresent(vc, animated: true)
    }
    
    @objc func viewBonusHandler(_ sender: UITapGestureRecognizer) {
        let vc = ENBonusViewController.create()
        enPresent(vc, animated: true)
    }
}
