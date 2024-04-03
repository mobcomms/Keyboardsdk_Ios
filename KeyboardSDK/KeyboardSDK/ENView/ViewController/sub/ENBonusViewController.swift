//
//  ENBonusViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/18.
//

import Foundation
import KeyboardSDKCore

class ENBonusViewController: UIViewController, ENViewPrsenter {
    
    public static func create() -> ENBonusViewController {
        let vc = ENBonusViewController.init(nibName: "ENBonusViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    @IBOutlet weak var viewWrapperNewAd: UIView!
    @IBOutlet weak var viewWrapperAd: UIView!
    
    @IBOutlet weak var lblNewsPoint: UILabel!
    @IBOutlet weak var lblAdPoint: UILabel!
    
    @IBOutlet weak var switchNews: UISwitch!
    @IBOutlet weak var switchAd: UISwitch!
    
    weak var eNMainViewControllerDelegate: ENMainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchNews.isOn = ENSettingManager.shared.useNewsAd
        switchAd.isOn = ENSettingManager.shared.useAd
        
        wrapperViewBorderSetting(targetView: viewWrapperNewAd)
        wrapperViewBorderSetting(targetView: viewWrapperAd)
        
        pointBorderSetting(targetLabel: lblNewsPoint)
        pointBorderSetting(targetLabel: lblAdPoint)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func wrapperViewBorderSetting(targetView: UIView) {
        targetView.layer.borderWidth = 1
        targetView.layer.borderColor = CGColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
        targetView.layer.cornerRadius = targetView.frame.height / 2
    }
    
    func pointBorderSetting(targetLabel: UILabel) {
        targetLabel.layer.borderWidth = 2
        targetLabel.layer.borderColor = CGColor(red: 205/255, green: 130/255, blue: 0/255, alpha: 1)
        targetLabel.layer.cornerRadius = targetLabel.frame.width / 2
        targetLabel.clipsToBounds = true
    }
    
    @IBAction func switchNewsChangeHandler(_ sender: UISwitch) {
        ENSettingManager.shared.useNewsAd = sender.isOn
    }
    
    @IBAction func switchAdChangeHandler(_ sender: UISwitch) {
        ENSettingManager.shared.useAd = sender.isOn
    }
    
    @IBAction func btnBackHandler(_ sender: UIButton) {
        if let delegates = eNMainViewControllerDelegate {
            enDismiss(completion: {
                delegates.toolbarTableViewReloadDelegate()
            })
        } else {
            enDismiss()
        }
    }
}
