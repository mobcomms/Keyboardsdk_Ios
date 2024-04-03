//
//  ENSettingViewController.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/05/20.
//

import UIKit
import KeyboardSDKCore

enum ENSettingMenuType: Int {
    case normal
    case switchButton
    case slider
}

struct ENSettingMenu {
    var displayName: String
    var type: ENSettingMenuType
    var value: Any?
}



public class ENSettingViewController: UIViewController, ENViewPrsenter {

    let settingTitles = [
        "테마",
        "키보드 설정",
        "툴바"
    ]
    var settingMenus: [Array<ENSettingMenu>] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    public static func create() -> ENSettingViewController {
        let vc = ENSettingViewController.init(nibName: "ENSettingViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    
    public override var shouldAutorotate: Bool {
        return false
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib.init(nibName: "ENSettingNormalTableViewCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENSettingNormalTableViewCell.ID)
        tableView.register(UINib.init(nibName: "ENSettingSwitchTableViewCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENSettingSwitchTableViewCell.ID)
        tableView.register(UINib.init(nibName: "ENSettingThemeTableViewCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENSettingThemeTableViewCell.ID)
        tableView.register(UINib.init(nibName: "ENSettingSlideTableViewCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENSettingSlideTableViewCell.ID)
        tableView.register(UINib.init(nibName: "ENSettingNoDescTableViewCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENSettingNoDescTableViewCell.ID)
        
        reloadData()
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public func reloadData() {
        if UserDefaults.enKeyboardGroupStandard?.getKeyboardType() == ENKeyboardType.tenkey {
            settingMenus = [
                [
                    ENSettingMenu.init(displayName: "테마 설정", type: .normal, value: ENSettingManager.shared.useTheme),
                    ENSettingMenu.init(displayName: "키보드 모드", type: .normal)
                ],
                [
                    ENSettingMenu.init(displayName: "키보드 높이", type: .slider, value: ENSettingManager.shared.keyboardHeightRate),
                    ENSettingMenu.init(displayName: "진동 설정", type: .switchButton, value: ENSettingManager.shared.useHaptic),
                    ENSettingMenu.init(displayName: "소리", type: .switchButton, value: ENSettingManager.shared.useSound),
                    ENSettingMenu.init(displayName: "소리변경", type: .normal, value: ENSettingManager.shared.soundID),
                ],
                [
                    ENSettingMenu.init(displayName: "툴바 설정", type: .normal)
                ]
            ]
        } else {
            settingMenus = [
                [
                    ENSettingMenu.init(displayName: "테마 설정", type: .normal, value: ENSettingManager.shared.useTheme),
                    ENSettingMenu.init(displayName: "키보드 모드", type: .normal)
                ],
                [
                    ENSettingMenu.init(displayName: "키보드 높이", type: .slider, value: ENSettingManager.shared.keyboardHeightRate),
                    ENSettingMenu.init(displayName: "자판 프리뷰", type: .switchButton, value: ENSettingManager.shared.isKeyboardButtonValuePreviewShow),
                    ENSettingMenu.init(displayName: "진동 설정", type: .switchButton, value: ENSettingManager.shared.useHaptic),
                    ENSettingMenu.init(displayName: "소리", type: .switchButton, value: ENSettingManager.shared.useSound),
                    ENSettingMenu.init(displayName: "소리변경", type: .normal, value: ENSettingManager.shared.soundID),
                ],
                [
                    ENSettingMenu.init(displayName: "툴바 설정", type: .normal)
                ]
            ]
        }
        print("====================================")
        tableView.reloadData()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        enDismiss()
    }
    
    private func keyboardModeHandler(cell: ENSettingNormalTableViewCell) {
        if UserDefaults.enKeyboardGroupStandard?.getKeyboardType() == ENKeyboardType.qwerty {
            cell.labelDescript.text = "천지인"
            UserDefaults.enKeyboardGroupStandard?.setKeyboardType(ENKeyboardType.tenkey)
        } else {
            cell.labelDescript.text = "쿼티"
            UserDefaults.enKeyboardGroupStandard?.setKeyboardType(ENKeyboardType.qwerty)
        }
        
        reloadData()
    }
    
    private func showThemeListViewController(theme:ENKeyboardThemeModel? = nil) {
        let vc = ENNewThemeManagerViewController.create()
        enPresent(vc, animated: true)       
    }
    
    private func showSoundSelectViewController() {
        let vc = ENSoundSelectViewController.create()
        enPresent(vc, animated: true)
    }
    
    private func showToolbarSettingViewController() {
        print("툴바 설정 클릭!!!")
        let vc = ENMainViewController.create()
        enPresent(vc, animated: true)
    }
}



extension ENSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return settingMenus.count
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingMenus[section].count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < settingMenus[indexPath.section].count else {
            return tableView.dequeueReusableCell(withIdentifier: ENSettingNormalTableViewCell.ID, for: indexPath)
        }
    
        let menu = settingMenus[indexPath.section][indexPath.row]
        print("section : \(indexPath.section) | indexPath: \(indexPath.row) | name : \(menu.displayName)")
        
        var retCell:UITableViewCell? = nil
        switch menu.displayName {
        case "테마 설정":
            let cell = tableView.dequeueReusableCell(withIdentifier: ENSettingNormalTableViewCell.ID, for: indexPath) as! ENSettingNormalTableViewCell
            cell.labelTitle.text = menu.displayName
            
            if ENSettingManager.shared.isUsePhotoTheme {
                cell.labelDescript.text = "포토테마 사용중"
            }
            else {
                let model = (menu.value as? ENKeyboardThemeModel)
                cell.labelDescript.text = model?.name ?? "uknown"
            }
            
            retCell = cell
            break
            
        case "키보드 모드":
            let cell = tableView.dequeueReusableCell(withIdentifier: ENSettingNormalTableViewCell.ID, for: indexPath) as! ENSettingNormalTableViewCell
            cell.labelTitle.text = menu.displayName
            
            if UserDefaults.enKeyboardGroupStandard?.getKeyboardType() == ENKeyboardType.qwerty {
                cell.labelDescript.text = "쿼티"
                UserDefaults.enKeyboardGroupStandard?.setKeyboardType(ENKeyboardType.qwerty)
            } else {
                cell.labelDescript.text = "천지인"
                UserDefaults.enKeyboardGroupStandard?.setKeyboardType(ENKeyboardType.tenkey)
            }
            
            retCell = cell
            break
            
        case "키보드 높이":
            let cell = tableView.dequeueReusableCell(withIdentifier: ENSettingSlideTableViewCell.ID, for: indexPath) as! ENSettingSlideTableViewCell
            let currentValue = (menu.value as? Float) ?? 0
            
            cell.labelTitle.text = menu.displayName
            cell.labelDescript.text = "\(100 + Int(currentValue - 20))%"
            cell.setValue(min: 0, max: 40, step: 1, current: currentValue)
            cell.delegate = self
            cell.indexPath = indexPath
            
            retCell = cell
            break
            
        case "자판 프리뷰", "진동 설정", "소리":
            let cell = tableView.dequeueReusableCell(withIdentifier: ENSettingSwitchTableViewCell.ID, for: indexPath) as! ENSettingSwitchTableViewCell
            
            cell.labelTitle.text = menu.displayName
            cell.buttonSwitch.isOn = (menu.value as? Bool) ?? false
            cell.delegate = self
            cell.indexPath = indexPath
            
            retCell = cell
            break
            
        case "소리변경":
            let cell = tableView.dequeueReusableCell(withIdentifier: ENSettingNoDescTableViewCell.ID, for: indexPath) as! ENSettingNoDescTableViewCell
            
            cell.lblTitle.text = menu.displayName
            
            retCell = cell
            break
        case "툴바 설정":
            let cell = tableView.dequeueReusableCell(withIdentifier: ENSettingNoDescTableViewCell.ID, for: indexPath) as! ENSettingNoDescTableViewCell
            
            cell.lblTitle.text = menu.displayName
            
            retCell = cell
            break
        default:
            break
        }
        
        retCell?.backgroundColor = .white
        retCell?.layer.borderWidth = 1.0
        retCell?.layer.borderColor = UIColor.white.cgColor
        
        return retCell ?? tableView.dequeueReusableCell(withIdentifier: ENSettingNormalTableViewCell.ID, for: indexPath)
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < settingMenus[indexPath.section].count else { return }
        
        let menu = settingMenus[indexPath.section][indexPath.row]
        switch menu.displayName {
        case "테마 설정":
            showThemeListViewController()
            return
            
        case "키보드 모드":
            guard let currentCell = tableView.cellForRow(at: indexPath) as? ENSettingNormalTableViewCell else {
                return
            }
            
            keyboardModeHandler(cell: currentCell)
            return
        case "소리변경":
            showSoundSelectViewController()
            return
        case "툴바 설정":
            showToolbarSettingViewController()
            return
        default:
            return
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rootHeader = UIView(frame: CGRect.init(origin: .zero, size: CGSize.init(width: tableView.frame.width, height: 40.0)))
        rootHeader.backgroundColor = .white
        
        let titleLable = UILabel(frame: CGRect.init(origin: CGPoint.init(x: 10.0, y: 0.0), size: CGSize.init(width: tableView.frame.width-10.0, height: 40.0)))
        titleLable.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        titleLable.textColor = UIColor.init(white: 0.12, alpha: 1.0)
        
        titleLable.backgroundColor = .clear
        
        rootHeader.addSubview(titleLable)
        
        if section < settingTitles.count {
            titleLable.text = settingTitles[section]
        }
        
        rootHeader.layer.borderWidth = 1.0
        rootHeader.layer.borderColor = UIColor.white.cgColor
        rootHeader.layer.cornerRadius = 5.0
        rootHeader.layer.maskedCorners = [ .layerMaxXMinYCorner, .layerMinXMinYCorner]
        rootHeader.layer.masksToBounds = true
        
        return rootHeader
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let rootFooter = UIView(frame: CGRect.init(origin: .zero, size: CGSize.init(width: tableView.frame.width, height: 20.0)))
        let footer = UIView(frame: CGRect.init(origin: .zero, size: CGSize.init(width: tableView.frame.width, height: 10.0)))
        footer.backgroundColor = .white
        rootFooter.backgroundColor = .clear
        
        rootFooter.addSubview(footer)
        
        footer.layer.borderWidth = 1.0
        footer.layer.borderColor = UIColor.white.cgColor
        footer.layer.cornerRadius = 5.0
        footer.layer.maskedCorners = [ .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        footer.layer.masksToBounds = true
        
        return rootFooter
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.backgroundColor = .clear
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as? UITableViewHeaderFooterView
        footer?.backgroundColor = .clear
    }
}



extension ENSettingViewController: ENSettingSwitchTableViewCellDelegate {
    
    func switchValueChange(cell: ENSettingSwitchTableViewCell, isOn: Bool) {
        if let indexPath = cell.indexPath {
            let menu = settingMenus[indexPath.section][indexPath.row]
            
            guard menu.value is Bool, (menu.value as! Bool) != isOn else {
                return
            }
            
            
            switch menu.displayName {
            case "자판 프리뷰":
                settingMenus[indexPath.section][indexPath.row].value = isOn
                ENSettingManager.shared.isKeyboardButtonValuePreviewShow = isOn
                break
                
            case "진동 설정":
                settingMenus[indexPath.section][indexPath.row].value = isOn
                ENSettingManager.shared.useHaptic = isOn
                if isOn {
                    showErrorMessage(message: "전체 접근 권한을 허용해 주어야\n키보드에서 진동기능이 활성화 됩니다.")
                }
                break
                
            case "소리":
                settingMenus[indexPath.section][indexPath.row].value = isOn
                ENSettingManager.shared.useSound = isOn
                break
                
            default :
                break
            }
        }
    }
}


extension ENSettingViewController: ENSettingThemeTableViewCellDelegate {
    
    func showThemeListWith(theme:ENKeyboardThemeModel?) {
        showThemeListViewController(theme: theme)
    }
    
}


extension ENSettingViewController: ENSettingSlideTableViewCellDelegate {
    
    func slideValueChanged(cell: ENSettingSlideTableViewCell, newValue: Float) {
        if let indexPath = cell.indexPath {
            
            let menu = settingMenus[indexPath.section][indexPath.row]
            
            switch menu.displayName {
            case "키보드 높이":
                ENSettingManager.shared.keyboardHeightRate = newValue
                cell.labelDescript.text = "\(100 + Int(newValue - 20))%"
                break
                
            default :
                break
            }
        }
    }
}
