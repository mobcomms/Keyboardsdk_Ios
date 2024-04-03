//
//  ToolbarSettingViewController.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/28.
//

import Foundation
import KeyboardSDKCore

class ENToolbarSettingViewController: UIViewController, ENViewPrsenter {
    public static func create() -> ENToolbarSettingViewController {
        let vc = ENToolbarSettingViewController.init(nibName: "ENToolbarSettingViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    let toolbarHeight: CGFloat = 58.0
    let toolbarWidth: CGFloat = UIScreen.main.bounds.size.width
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    
    let scrollView: UIScrollView = UIScrollView()
    let stackView: UIStackView = UIStackView()
    
    var btnArray: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        btnBack.addTarget(self, action: #selector(btnBackHandler(_:)), for: .touchUpInside)
        
        createToolbarView()
        
        if !btnArray.isEmpty {
            
        } else {
            print("btnArray empty")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func createToolbarView() {
        if let getToolbarArray = UserDefaults.enKeyboardGroupStandard?.getToolbarArray() {
            for btnType in getToolbarArray {
                let button = createButton(title: "", senderTag: btnType)
                btnArray.append(button)
                stackView.addArrangedSubview(button)
            }
            
            let remainder = btnArray.count % 5
            if remainder != 0 {
                let result = 5 - remainder
                for _ in 0...(result - 1) {
                    let emptyView = createEmptyView()
                    stackView.addArrangedSubview(emptyView)
                }
            }
            
            scrollView.backgroundColor = .white
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.isPagingEnabled = true
            
            stackView.axis = .horizontal
            stackView.spacing = 0
            
            self.view.addSubview(scrollView)
            scrollView.addSubview(stackView)
            
            layoutConstraintSetting()
            
        } else {
            print("toolbar array empty")
        }
    }
    
    private func layoutConstraintSetting() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 0).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: toolbarHeight).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.0).isActive = true
        
        scrollView.contentSize = CGSize(width: toolbarWidth, height: toolbarHeight)
    }
    
    private func createButton(title: String, senderTag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        
        button.adjustsImageWhenHighlighted = false
        
        button.tag = senderTag
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: toolbarWidth / 5).isActive = true
        
        var img: UIImage? = nil

        switch senderTag {
        case ENButtonConstant.SETTING:
            img = UIImage.init(named: "aikbd_btn_keyboard_setting", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case ENButtonConstant.EMOJI:
            img = UIImage.init(named: "aikbd_btn_keyboard_emoticon", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case ENButtonConstant.AD:
            img = UIImage.init(named: "aikbd_btn_ad_icon_on", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case ENButtonConstant.CLIP_BOARD:
            img = UIImage.init(named: "aikbd_btn_keyboard_memo", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case ENButtonConstant.BOOK_MARK:
            img = UIImage.init(named: "aikbd_btn_keyboard_bookmark", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case ENButtonConstant.GAME:
            img = UIImage.init(named: "aikbd_btn_keyboard_memo_on", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        case ENButtonConstant.ADD_TYPE:
            img = UIImage.init(named: "aikbd_btn_keyboard_memo_on", in: Bundle.frameworkBundle, compatibleWith: nil)
            break
        default:
            break
        }
        
        button.setImage(img, for: .normal)
        
        return button
    }
    
    private func createEmptyView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: toolbarWidth / 5).isActive = true
        view.heightAnchor.constraint(equalToConstant: toolbarHeight).isActive = true
        
        view.backgroundColor = .clear
        
        return view
    }
    
    @objc func btnBackHandler(_ sender: UIButton) {
        enDismiss()
    }
    
}
