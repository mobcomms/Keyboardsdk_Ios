//
//  ENToolbarSelectViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/11.
//

import Foundation
import KeyboardSDKCore

class ENToolbarSelectViewController: UIViewController, ENViewPrsenter {
    public static func create() -> ENToolbarSelectViewController {
        let vc = ENToolbarSelectViewController.init(nibName: "ENToolbarSelectViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    @IBOutlet weak var viewOpacity: UIView!
    @IBOutlet weak var viewWrapper: UIView!
    @IBOutlet weak var viewPaging: UIView!
    @IBOutlet weak var imgPagingCheck: UIImageView!
    @IBOutlet weak var viewScroll: UIView!
    @IBOutlet weak var imgScrollCheck: UIImageView!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    weak var eNMainViewControllerDelegate: ENMainViewControllerDelegate?
    
    var selectValue: Int = ENSettingManager.shared.toolbarStyle.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWrapper.popupEffect()
        
        settingImageCheck()
        
        let pagingTap = UITapGestureRecognizer(target: self, action: #selector(pagingTapGesture(_:)))
        let scrollTap = UITapGestureRecognizer(target: self, action: #selector(scrollTapGesture(_:)))
        
        viewPaging.addGestureRecognizer(pagingTap)
        viewScroll.addGestureRecognizer(scrollTap)
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(opacityViewHandler(_:)))
        viewOpacity.addGestureRecognizer(dismissTap)
        
        btnConfirm.layer.cornerRadius = 12
        btnConfirm.addTarget(self, action: #selector(btnConfirmHandler(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func settingImageCheck() {
        if selectValue == 1 {
            imgPagingCheck.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            imgScrollCheck.image = UIImage.init(named: "sound_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)
        } else if selectValue == 2 {
            imgPagingCheck.image = UIImage.init(named: "sound_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)
            imgScrollCheck.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
        } else {
            imgPagingCheck.image = UIImage.init(named: "sound_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            imgScrollCheck.image = UIImage.init(named: "sound_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)
        }
    }
    
    @objc func pagingTapGesture(_ sender: UITapGestureRecognizer) {
        selectValue = ENToolbarStyle.paging.rawValue
        settingImageCheck()
    }
    
    @objc func scrollTapGesture(_ sender: UITapGestureRecognizer) {
        selectValue = ENToolbarStyle.scroll.rawValue
        settingImageCheck()
    }
    
    @objc func btnConfirmHandler(_ sender: UIButton) {
        if selectValue == 1 {
            ENSettingManager.shared.toolbarStyle = .paging
        } else if selectValue == 2 {
            ENSettingManager.shared.toolbarStyle = .scroll
        } else {
            ENSettingManager.shared.toolbarStyle = .paging
        }
        
        if let delegates = eNMainViewControllerDelegate {
            enDismiss(completion: {
                delegates.toolbarTableViewReloadDelegate()
            })
        } else {
            enDismiss()
        }
    }
    
    @objc func opacityViewHandler(_ sender: UITapGestureRecognizer) {
        enDismiss(completion: { [weak self] in
            guard let self else { return }
            if let delegates = self.eNMainViewControllerDelegate {
                delegates.toolbarTableViewReloadDelegate()
            }
        })
    }
}
