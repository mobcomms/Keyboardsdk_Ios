//
//  ENMainViewController+TableViewDelegate.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/30.
//

import Foundation
import KeyboardSDKCore

extension ENMainViewController: UITableViewDelegate, UITableViewDataSource {
    /// 섹션 지정
    public func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == defaultSettingTable {
            return defaultSettingMenus.count
        } else if tableView == toolbarSettingTable {
            return toolbarSettingMenus.count
        }
        
        return defaultSettingMenus.count
    }
    
    /// 로우 지정
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == defaultSettingTable {
            return defaultSettingMenus[section].count
        } else if tableView == toolbarSettingTable {
            return toolbarSettingMenus[section].count
        }
        
        return defaultSettingMenus[section].count
    }
    
    /// 로우에 들어갈 셀 그리기
    /// - 테이블 뷰가 여러개 이기 때문에 나눠서 그려줌
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == defaultSettingTable {
            // 기본 설정 테이블 일 때
            
            // 로우가 이상하게 들어왔을 때 guard 문
            guard indexPath.row < defaultSettingMenus[indexPath.section].count else {
                return tableView.dequeueReusableCell(withIdentifier: ENDefaultBackgroundCell.ID, for: indexPath)
            }
            
            // 로우에 대한 해당 데이터 값 가져오기
            let menu = defaultSettingMenus[indexPath.section][indexPath.row]
            // temp cell 생성
            var retCell: UITableViewCell? = nil
            
            // 데이터 값에 따라 Cell 을 뿌려줌
            switch menu.displayName {
            case "키보드 입력방식":
                let cell = tableView.dequeueReusableCell(withIdentifier: ENDefaultBackgroundCell.ID, for: indexPath) as! ENDefaultBackgroundCell
                cell.lblTitle.text = menu.displayName
                cell.imgTitle.image = UIImage.init(named: "cell_keyboard_img", in: Bundle.frameworkBundle, compatibleWith: nil)
                cell.lblValue.text = ENSettingManager.shared.keyboardType == .qwerty ? "쿼티" : "천지인"
                retCell = cell
                break
            case "키보드 높이":
                let cell = tableView.dequeueReusableCell(withIdentifier: ENDefaultBackgroundCell.ID, for: indexPath) as! ENDefaultBackgroundCell
                cell.lblTitle.text = menu.displayName
                cell.imgTitle.image = UIImage.init(named: "cell_key_height", in: Bundle.frameworkBundle, compatibleWith: nil)
                cell.lblValue.text = "\(100 + Int(ENSettingManager.shared.keyboardHeightRate - 20))%"
                
                retCell = cell
                break
            case "진동 세기":
                let cell = tableView.dequeueReusableCell(withIdentifier: ENDefaultBackgroundCell.ID, for: indexPath) as! ENDefaultBackgroundCell
                cell.lblTitle.text = menu.displayName
                cell.imgTitle.image = UIImage.init(named: "cell_vibrator", in: Bundle.frameworkBundle, compatibleWith: nil)
                
                switch ENSettingManager.shared.hapticPower {
                case 0:
                    cell.lblValue.text = "없음"
                    break
                case 1:
                    cell.lblValue.text = "약함"
                    break
                case 2:
                    cell.lblValue.text = "강함"
                    break
                case 3:
                    cell.lblValue.text = "매우 강함"
                    break
                default:
                    break
                }
                
                retCell = cell
                break
            case "자주 쓰는 메모":
                let cell = tableView.dequeueReusableCell(withIdentifier: ENDefaultNormalCell.ID, for: indexPath) as! ENDefaultNormalCell
                cell.lblTitle.text = menu.displayName
                cell.imgTitle.image = UIImage.init(named: "cell_memo", in: Bundle.frameworkBundle, compatibleWith: nil)
                cell.lblValue.text = "\(ENSettingManager.shared.userMemo.count)"

                retCell = cell
                break
            case "나만의 이모티콘":
                let cell = tableView.dequeueReusableCell(withIdentifier: ENDefaultNormalCell.ID, for: indexPath) as! ENDefaultNormalCell
                cell.lblTitle.text = menu.displayName
                cell.imgTitle.image = UIImage.init(named: "cell_my_emoji", in: Bundle.frameworkBundle, compatibleWith: nil)
                cell.lblValue.text = "0"
                
                retCell = cell
                break
            case "입력키 크게 보기":
                let cell = tableView.dequeueReusableCell(withIdentifier: ENDefaultSwitchCell.ID, for: indexPath) as! ENDefaultSwitchCell
                cell.lblTitle.text = menu.displayName
                cell.imgTitle.image = UIImage.init(named: "cell_input_text", in: Bundle.frameworkBundle, compatibleWith: nil)
                cell.switchComp.isOn = ENSettingManager.shared.isKeyboardButtonValuePreviewShow
                cell.indexPath = indexPath
                
                retCell = cell
                break
            case "키보드 소리":
                let cell = tableView.dequeueReusableCell(withIdentifier: ENDefaultSoundCell.ID, for: indexPath) as! ENDefaultSoundCell
                cell.lblTitle.text = menu.displayName
                cell.imgTitle.image = UIImage.init(named: "cell_sound", in: Bundle.frameworkBundle, compatibleWith: nil)
                switch ENSettingManager.shared.soundID {
                case 0:
                    cell.lblValue.text = "기본"
                    break
                case 1:
                    cell.lblValue.text = "뽀롱 (물방울 소리)"
                    break
                case 2:
                    cell.lblValue.text = "뺙뺙 (짹짹이 소리)"
                    break
                case 3:
                    cell.lblValue.text = "탁탁 (옛날 타자기 소리)"
                    break
                case 4:
                    cell.lblValue.text = "무음"
                    break
                default:
                    break
                }
                
                retCell = cell
                break
            default:
                break
            }
            
            // Cell 의 기본 설정
            retCell?.backgroundColor = .white
            retCell?.layer.borderWidth = 1.0
            retCell?.layer.borderColor = UIColor.white.cgColor
            
            // retCell 이 있으면 그대로 내보냄, 없으면 기본으로 내보냄
            return retCell ?? tableView.dequeueReusableCell(withIdentifier: ENDefaultBackgroundCell.ID, for: indexPath)
            
        } else if tableView == toolbarSettingTable {
            // 툴바 테이블 일 때
            
            // 로우가 이상한 값이 들어왔을 때의 guard 문
            guard indexPath.row < toolbarSettingMenus[indexPath.section].count else {
                return tableView.dequeueReusableCell(withIdentifier: ENToolbarBackgroundCell.ID, for: indexPath)
            }
            
            // temp cell 생성
            var retCell: UITableViewCell? = nil
            
            // 로우에 대한 데이터 값으로 Cell 뿌려줌
            if let menu = toolbarSettingMenus[indexPath.section][indexPath.row] as? ENToolbarSettingModel {
                switch menu.displayName {
                case "EMPTY_AREA":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarBackgroundCell.ID, for: indexPath) as! ENToolbarBackgroundCell
                    cell.lblTitle.text = menu.displayName
                    cell.imgTitle.image = UIImage.init(named: "cell_keyboard_img", in: Bundle.frameworkBundle, compatibleWith: nil)
                    
                    retCell = cell
                    break
                case "툴바 타입":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarBackgroundCell.ID, for: indexPath) as! ENToolbarBackgroundCell
                    cell.lblTitle.text = menu.displayName
                    cell.imgTitle.image = UIImage.init(named: "cell_toolbar_type", in: Bundle.frameworkBundle, compatibleWith: nil)
                    cell.lblValue.text = menu.value as? String ?? ""
                    
                    retCell = cell
                    break
                default:
                    break
                }
            } else if let toolbarItem = toolbarSettingMenus[indexPath.section][indexPath.row] as? ENToolbarItem {
                switch toolbarItem.displayName {
                case "모비컴즈":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarNormalCell.ID, for: indexPath) as! ENToolbarNormalCell
                    cell.lblTitle.text = toolbarItem.displayName
                    cell.imgTitle.image = UIImage.init(named: toolbarItem.imgName, in: Bundle.frameworkBundle, compatibleWith: nil)
                    cell.imgStar.isHidden = false

                    let check = toolbarItem.isUse
                    
                    cell.btnCheck.image = checkImgSetting(isCheck: check)
                    cell.isCheck = check

                    retCell = cell
                    break
                case "이모지":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarNormalCell.ID, for: indexPath) as! ENToolbarNormalCell
                    cell.lblTitle.text = toolbarItem.displayName
                    cell.imgTitle.image = UIImage.init(named: toolbarItem.imgName, in: Bundle.frameworkBundle, compatibleWith: nil)
                    cell.imgStar.isHidden = true

                    let check = toolbarItem.isUse

                    cell.btnCheck.image = checkImgSetting(isCheck: check)
                    cell.isCheck = check

                    retCell = cell
                    break
                case "이모티콘":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarNormalCell.ID, for: indexPath) as! ENToolbarNormalCell
                    cell.lblTitle.text = toolbarItem.displayName
                    cell.imgTitle.image = UIImage.init(named: toolbarItem.imgName, in: Bundle.frameworkBundle, compatibleWith: nil)
                    cell.imgStar.isHidden = true

                    let check = toolbarItem.isUse

                    cell.btnCheck.image = checkImgSetting(isCheck: check)
                    cell.isCheck = check

                    retCell = cell
                    break
                case "자주쓰는 메모":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarNormalCell.ID, for: indexPath) as! ENToolbarNormalCell
                    cell.lblTitle.text = toolbarItem.displayName
                    cell.imgTitle.image = UIImage.init(named: toolbarItem.imgName, in: Bundle.frameworkBundle, compatibleWith: nil)
                    cell.imgStar.isHidden = true

                    let check = toolbarItem.isUse

                    cell.btnCheck.image = checkImgSetting(isCheck: check)
                    cell.isCheck = check

                    retCell = cell
                    break
                case "클립보드":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarNormalCell.ID, for: indexPath) as! ENToolbarNormalCell
                    cell.lblTitle.text = toolbarItem.displayName
                    cell.imgTitle.image = UIImage.init(named: toolbarItem.imgName, in: Bundle.frameworkBundle, compatibleWith: nil)
                    cell.imgStar.isHidden = true

                    let check = toolbarItem.isUse

                    cell.btnCheck.image = checkImgSetting(isCheck: check)
                    cell.isCheck = check

                    retCell = cell
                    break
                case "쿠팡 바로가기":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarNormalCell.ID, for: indexPath) as! ENToolbarNormalCell
                    cell.lblTitle.text = toolbarItem.displayName
                    cell.imgTitle.image = UIImage.init(named: toolbarItem.imgName, in: Bundle.frameworkBundle, compatibleWith: nil)
                    cell.imgStar.isHidden = true

                    let check = toolbarItem.isUse

                    cell.btnCheck.image = checkImgSetting(isCheck: check)
                    cell.isCheck = check

                    retCell = cell
                    break
                case "오퍼월":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarNormalCell.ID, for: indexPath) as! ENToolbarNormalCell
                    cell.lblTitle.text = toolbarItem.displayName
                    cell.imgTitle.image = UIImage.init(named: toolbarItem.imgName, in: Bundle.frameworkBundle, compatibleWith: nil)
                    cell.imgStar.isHidden = true

                    let check = toolbarItem.isUse

                    cell.btnCheck.image = checkImgSetting(isCheck: check)
                    cell.isCheck = check

                    retCell = cell
                    break
                case "더치페이":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarNormalCell.ID, for: indexPath) as! ENToolbarNormalCell
                    cell.lblTitle.text = toolbarItem.displayName
                    cell.imgTitle.image = UIImage.init(named: toolbarItem.imgName, in: Bundle.frameworkBundle, compatibleWith: nil)
                    cell.imgStar.isHidden = true

                    let check = toolbarItem.isUse

                    cell.btnCheck.image = checkImgSetting(isCheck: check)
                    cell.isCheck = check

                    retCell = cell
                    break
                case "핫이슈":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarNormalCell.ID, for: indexPath) as! ENToolbarNormalCell
                    cell.lblTitle.text = toolbarItem.displayName
                    cell.imgTitle.image = UIImage.init(named: toolbarItem.imgName, in: Bundle.frameworkBundle, compatibleWith: nil)
                    cell.imgStar.isHidden = true

                    let check = toolbarItem.isUse

                    cell.btnCheck.image = checkImgSetting(isCheck: check)
                    cell.isCheck = check

                    retCell = cell
                    break
                case "커서이동/좌":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarNormalCell.ID, for: indexPath) as! ENToolbarNormalCell
                    cell.lblTitle.text = toolbarItem.displayName
                    cell.imgTitle.image = UIImage.init(named: toolbarItem.imgName, in: Bundle.frameworkBundle, compatibleWith: nil)
                    cell.imgStar.isHidden = true

                    let check = toolbarItem.isUse

                    cell.btnCheck.image = checkImgSetting(isCheck: check)
                    cell.isCheck = check

                    retCell = cell
                    break
                case "커서이동/우":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarNormalCell.ID, for: indexPath) as! ENToolbarNormalCell
                    cell.lblTitle.text = toolbarItem.displayName
                    cell.imgTitle.image = UIImage.init(named: toolbarItem.imgName, in: Bundle.frameworkBundle, compatibleWith: nil)
                    cell.imgStar.isHidden = true

                    let check = toolbarItem.isUse

                    cell.btnCheck.image = checkImgSetting(isCheck: check)
                    cell.isCheck = check

                    retCell = cell
                    break
                case "설정":
                    let cell = tableView.dequeueReusableCell(withIdentifier: ENToolbarNormalCell.ID, for: indexPath) as! ENToolbarNormalCell
                    cell.lblTitle.text = toolbarItem.displayName
                    cell.imgTitle.image = UIImage.init(named: toolbarItem.imgName, in: Bundle.frameworkBundle, compatibleWith: nil)
                    cell.imgStar.isHidden = true

                    let check = toolbarItem.isUse

                    cell.btnCheck.image = checkImgSetting(isCheck: check)
                    cell.isCheck = check

                    retCell = cell
                    break
                default:
                    break
                }
            }
            
            // 위와 같으니 생략
            retCell?.backgroundColor = .white
            retCell?.layer.borderWidth = 1.0
            retCell?.layer.borderColor = UIColor.white.cgColor
            
            // 위와 같으니 생략
            return retCell ?? tableView.dequeueReusableCell(withIdentifier: ENToolbarNormalCell.ID, for: indexPath)

        } else {
            // 위와 같으니 생략
            return tableView.dequeueReusableCell(withIdentifier: ENDefaultBackgroundCell.ID, for: indexPath)
        }
    }
    
    /// 셀 눌렀을 때
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == defaultSettingTable {
            guard indexPath.row < defaultSettingMenus[indexPath.section].count else { return }
            
            let menu = defaultSettingMenus[indexPath.section][indexPath.row]
            
            switch menu.displayName {
            case "키보드 입력방식":
                let vc = ENKeyboardSelectViewController.create()
                vc.eNMainViewControllerDelegate = self
                self.enPresent(vc, animated: true)
                return
                
            case "키보드 높이":
                let vc = ENKeyboardHeightViewController.create()
                vc.eNMainViewControllerDelegate = self
                self.enPresent(vc, animated: true)
                return
                
            case "진동 세기":
                let vc = ENKeyboardVibrateViewController.create()
                vc.eNMainViewControllerDelegate = self
                self.present(vc, animated: true)
                return
                
            case "자주 쓰는 메모":
                let vc = ENMemoDetailViewController.create()
                vc.eNMainViewControllerDelegate = self
                self.enPresent(vc, animated: true)
                return
            case "나만의 이모티콘":
                return
            case "키보드 소리":
                let vc = ENKeyboardSoundViewController.create()
                vc.eNMainViewControllerDelegate = self
                self.present(vc, animated: true)
                return
                
            default:
                return
            }
        } else if tableView == toolbarSettingTable {
            guard indexPath.row < toolbarSettingMenus[indexPath.section].count else { return }
            
            if let menu = toolbarSettingMenus[indexPath.section][indexPath.row] as? ENToolbarSettingModel {
                switch menu.displayName {
                case "툴바 타입":
                    let vc = ENToolbarSelectViewController.create()
                    vc.eNMainViewControllerDelegate = self
                    self.present(vc, animated: true)
                    break
                default:
                    break
                }
            } else if let toolbarItem = toolbarSettingMenus[indexPath.section][indexPath.row] as? ENToolbarItem {
//                print("뭐 눌리나... \(toolbarItem.displayName)")
                switch toolbarItem.displayName {
                case "모비컴즈":
                    notifyToolbarItemsForIsUse(index: indexPath.row)
                    break
                case "이모지":
                    notifyToolbarItemsForIsUse(index: indexPath.row)
                    break
                case "이모티콘":
                    notifyToolbarItemsForIsUse(index: indexPath.row)
                    break
                case "자주쓰는 메모":
                    notifyToolbarItemsForIsUse(index: indexPath.row)
                    break
                case "클립보드":
                    notifyToolbarItemsForIsUse(index: indexPath.row)
                    break
                case "쿠팡 바로가기":
                    notifyToolbarItemsForIsUse(index: indexPath.row)
                    break
                case "오퍼월":
                    notifyToolbarItemsForIsUse(index: indexPath.row)
                    break
                case "더치페이":
                    notifyToolbarItemsForIsUse(index: indexPath.row)
                    break
                case "핫이슈":
                    notifyToolbarItemsForIsUse(index: indexPath.row)
                    break
                case "커서이동/좌":
                    notifyToolbarItemsForIsUse(index: indexPath.row)
                    break
                case "커서이동/우":
                    notifyToolbarItemsForIsUse(index: indexPath.row)
                    break
                case "설정":
                    break
                default:
                    break
                }
                
                toolbarSettingReloadData(isToolbarReload: true)
            }
        }
    }
    
    // 셀 높이 지정
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    // 헤더 지정
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var rootHeader: UIView? = nil
    
        let titleLable = UILabel(frame: CGRect.init(origin: CGPoint.init(x: 26.0, y: 17.0), size: CGSize.init(width: tableView.frame.width-10.0, height: 40.0)))
        titleLable.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        titleLable.textColor = UIColor.init(white: 0.12, alpha: 1.0)
        
        titleLable.backgroundColor = .clear
    
        if tableView == defaultSettingTable {
            if section < defaultSettingTitle.count {
                titleLable.text = defaultSettingTitle[section]
            }
        } else if tableView == toolbarSettingTable {
            if section < toolbarSettingTitle.count {
                titleLable.text = toolbarSettingTitle[section]
                if toolbarSettingTitle[section] == "BACKGROUND_CELL_AREA" {
                    titleLable.isHidden = true
                }
//                print("여기온다...")
                
                rootHeader = UIView(frame: CGRect.init(origin: .zero, size: CGSize.init(width: tableView.frame.width, height: 100.0)))
            }
        } else {
            if section < defaultSettingTitle.count {
                titleLable.text = defaultSettingTitle[section]
            }
        }
        
        if rootHeader == nil {
            rootHeader = UIView(frame: CGRect.init(origin: .zero, size: CGSize.init(width: tableView.frame.width, height: 60.0)))
        }
        
        rootHeader?.addSubview(titleLable)
        
        rootHeader?.backgroundColor = .white
        
        rootHeader?.layer.maskedCorners = [ .layerMaxXMinYCorner, .layerMinXMinYCorner]
        rootHeader?.layer.masksToBounds = true
        
        return rootHeader
    }
    
    // 푸터 지정
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let rootFooter = UIView(frame: CGRect.init(origin: .zero, size: CGSize.init(width: tableView.frame.width, height: 15.0)))
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
    
    // 섹션의 헤더 높이 지정
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == toolbarSettingTable {
            if section < toolbarSettingTitle.count {
                if toolbarSettingTitle[section] == "BACKGROUND_CELL_AREA" {
                    return 100.0
                }
            }
        }
        return 60.0
    }
    
    // 섹션의 푸터 높이 지정
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.backgroundColor = .clear
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as? UITableViewHeaderFooterView
        footer?.backgroundColor = .clear
    }
    
    /// 셀 이동이 가능 하게 할지 여부 판단
    /// 툴바 테이블에서만 뭔가의 조치가 필요했음.
    /// 맨 마지막의 설정 메뉴는 고정이여야 함.
    /// 그래서 맨 마지막의 설정 메뉴인지 확인 후 움직일지 안움직일지 판단.
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == toolbarSettingTable {
            if let _ = toolbarSettingMenus[indexPath.section][indexPath.row] as? ENToolbarItem {
                if indexPath.row == ENSettingManager.shared.toolbarItems.count - 1 {
                    return false
                }
                return true
            }
        }
        return false
    }
    
    /// 셀 움직일 때
    /// 셀이 움직일때 데이터 값도 바꿔주고 테이블도 리로드 시킴
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var tableData = ENSettingManager.shared.toolbarItems
        let moveCell = tableData[sourceIndexPath.row]
        
        tableData.remove(at: sourceIndexPath.row)
        tableData.insert(moveCell, at: destinationIndexPath.row)
        
        ENSettingManager.shared.toolbarItems = tableData
        
        toolbarSettingReloadData(isToolbarReload: true)
    }
    
    /// 해당 타겟 셀의 움직임 조작
    /// 타겟 셀이 움직이지만 맨 아래의 설정 메뉴와는 교체가 되면 안됨.
    /// 그래서 마지막인지 체크 후 움직임 조작함.
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.section != 1 {
            return sourceIndexPath
        } else {
            if proposedDestinationIndexPath.row == ENSettingManager.shared.toolbarItems.count - 1 {
                return sourceIndexPath
            } else {
                if sourceIndexPath.row == ENSettingManager.shared.toolbarItems.count - 1 {
                    return sourceIndexPath
                } else {
                    return proposedDestinationIndexPath
                }
            }
        }
    }
    
    /// 툴바 테이블의 체크 이미지 리턴 함수
    func checkImgSetting(isCheck: Bool) -> UIImage? {
        if isCheck {
            let img = UIImage.init(named: "cell_toolbar_check", in: Bundle.frameworkBundle, compatibleWith: nil)
            return img
        } else {
            let img = UIImage.init(named: "cell_toolbar_uncheck", in: Bundle.frameworkBundle, compatibleWith: nil)
            return img
        }
    }
    
    /// 툴바 순서 조정
    /// - 저장 된 값을 바꿔줌
    func notifyToolbarItemsForIsUse(index: Int) {
        var toolbarItems = ENSettingManager.shared.toolbarItems

        if toolbarItems.indices.contains(index) {
            toolbarItems[index].isUse = !toolbarItems[index].isUse
        }
        
        ENSettingManager.shared.toolbarItems = toolbarItems
    
    }
}

/// 드래그 딜리게이트
extension ENMainViewController: UITableViewDragDelegate {
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.row == 0 {
            return []
        } else {
            return [UIDragItem(itemProvider: NSItemProvider())]
        }
    }
}

/// 드롭 딜리게이트
extension ENMainViewController: UITableViewDropDelegate {
    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
    
    public func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
}
