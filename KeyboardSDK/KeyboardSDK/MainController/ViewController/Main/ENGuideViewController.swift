//
// ENGuideViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 11/22/23.
//

import Foundation
import KeyboardSDKCore

class ENGuideViewController: UIViewController, ENViewPrsenter, UIScrollViewDelegate {
    
    public static func create() -> ENGuideViewController {
        let vc = ENGuideViewController.init(nibName: "ENGuideViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var guideScrollView: UIScrollView!
    
    @IBOutlet weak var viewGuideFirst: UIView!
    @IBOutlet weak var constraintGuideFirstWidth: NSLayoutConstraint!
    @IBOutlet weak var viewGuildeSecond: UIView!
    @IBOutlet weak var constraintGuideSecondWidth: NSLayoutConstraint!
    @IBOutlet weak var viewGuideThird: UIView!
    @IBOutlet weak var constraintGuideThirdWidth: NSLayoutConstraint!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guideScrollView.delegate = self
        
        updateUI()
        
        btnConfirm.addTarget(self, action: #selector(btnConfirmHandler), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(btnCloseHandler), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func updateUI() {
        let widthSize = UIScreen.main.bounds.size.width
        viewGuideFirst.translatesAutoresizingMaskIntoConstraints = false
        viewGuideFirst.removeConstraint(constraintGuideFirstWidth)
        viewGuideFirst.widthAnchor.constraint(equalToConstant: widthSize).isActive = true
        
        viewGuildeSecond.translatesAutoresizingMaskIntoConstraints = false
        viewGuildeSecond.removeConstraint(constraintGuideSecondWidth)
        viewGuildeSecond.widthAnchor.constraint(equalToConstant: widthSize).isActive = true
        
        viewGuideThird.translatesAutoresizingMaskIntoConstraints = false
        viewGuideThird.removeConstraint(constraintGuideThirdWidth)
        viewGuideThird.widthAnchor.constraint(equalToConstant: widthSize).isActive = true
        
        btnConfirm.backgroundColor = UIColor(r: 94, g: 80, b: 80)
        btnConfirm.layer.cornerRadius = 8
        btnConfirm.layer.masksToBounds = false
        btnConfirm.layer.applySketchShadow(color: UIColor(red: 94/255, green: 80/255, blue: 80/255, alpha: 0.4), alpha: 1.0, x: 0, y: 4, blur: 16, spread: 0)
    }
    
    @objc func btnConfirmHandler() {
        let x = guideScrollView.contentOffset.x
        let w = guideScrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
                
        if currentPage == 2{
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                open(url: settingsURL)
            }
        } else {
            movePage(page: currentPage + 1) 
        }
    }
    
    @objc func btnCloseHandler() {
        ENSettingManager.shared.isFirstUser = false
        enDismiss()
    }
    
    /// 페이지 이동 함수
    ///  - 탭 버튼을 클릭했을 때 호출함.
    func movePage(page: Int) {
        let pageWidth = Int(UIScreen.main.bounds.size.width)
        guideScrollView.scrollRectToVisible(CGRect.init(x: pageWidth * page, y: 0, width: pageWidth, height: 100), animated: true)
        
        if page == 2 {
            ENSettingManager.shared.isFirstUser = false

            btnConfirm.setTitle("키보드 설정하러 가기", for: .normal)
        } else {
            btnConfirm.setTitle("다음", for: .normal)
        }
    }
}

extension ENGuideViewController {
    /// 스크롤 이벤트가 끝났을 때
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        
        if currentPage == 2 {
            btnConfirm.setTitle("키보드 설정하러 가기", for: .normal)
            ENSettingManager.shared.isFirstUser = false

        } else {
            btnConfirm.setTitle("다음", for: .normal)
        }
    }
}
