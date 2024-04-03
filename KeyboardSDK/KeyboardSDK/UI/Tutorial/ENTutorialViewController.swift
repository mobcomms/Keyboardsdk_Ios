//
//  ENTutorialViewController.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/05/24.
//

import UIKit
import KeyboardSDKCore

public class ENTutorialViewController: UIViewController, ENViewPrsenter {

    public static func create() -> ENTutorialViewController {
        let vc = ENTutorialViewController.init(nibName: "ENTutorialViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    public static func showTutorialIfNeed(parent:UIViewController) {
        if !DHUtils.isKeyboardExtensionEnabled() {
            let vc = ENTutorialViewController.create()
            parent.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var pageControl: ENPageControlAji!
    @IBOutlet weak var pageScrollView: UIScrollView!
    
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewSecond: UIView!
    @IBOutlet weak var viewFinish: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    
    private var page:Int = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        skipButton.isHidden = false
        pageControl.numberOfPages = 3
        page = 0
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func checkCurrentPageStatus() {
        
        switch page {
        case 0:
            skipButton.isHidden = false
            nextButton.setTitle("다음", for: .normal)
            break
            
        case 1:
            skipButton.isHidden = false
            nextButton.setTitle("다음", for: .normal)
            break
            
        default:
            skipButton.isHidden = true
            nextButton.setTitle("완료", for: .normal)
            break
        }
    }
    
    func movePage(_ page:Int, animate:Bool = true) {
        let pageWidth = Int(pageScrollView.frame.width)
        pageScrollView.scrollRectToVisible(CGRect.init(x: pageWidth * page, y: 0, width: pageWidth, height: 100), animated: animate)
        pageControl.progress = Double(page)
        
        checkCurrentPageStatus()
    }
    
    
    
    @IBAction func skipButtonClicked(_ sender: Any) {
        ENSettingManager.shared.isFirstUser = false
        enDismiss()
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if page == 2 {
            ENSettingManager.shared.isFirstUser = false
            enDismiss()
            return
        }
        
        page += 1
        
        if page < 0 { page = 0 }
        if page > 2 { page = 2 }
        
        movePage(page)
    }
    
    @IBAction func firstStepGoSettingButtonClicked(_ sender: Any) {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            open(url: settingsURL)
        }
    }
    
    @IBAction func secondStepGoSettingButtonClicked(_ sender: Any) {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            open(url: settingsURL)
        }
    }
    
}
