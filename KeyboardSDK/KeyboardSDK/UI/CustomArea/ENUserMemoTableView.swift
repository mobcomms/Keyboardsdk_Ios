//
//  ENUserMemoTableView.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/12.
//

import Foundation
import KeyboardSDKCore

protocol ENUserMemoTableViewDelegate: AnyObject {
    /// 자주 쓰는 메모 테이블에서 선택 했을 때 -> 텍스트 인서트 함
    func didSelectUserMemo(from userMemoView: ENUserMemoTableView, selected userMemo: String)
    /// 자주 쓰는 메모 테이블 없앨 때 키보드 초기화 하는 메소드
    func restoreKeyboard(from userMemoView: ENUserMemoTableView)
    /// 자주 쓰는 메모 테이블에서 편집하는 화면으로 이동 할 때
    func openUserMemoEdit(from userMemoView:ENUserMemoTableView, targetButton: UIButton, userMemoEdit completion: (() -> Void)?)
}

class ENUserMemoTableView: UIView {
    lazy var userMemoTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .white

        return tableView
    }()
    
    lazy var btnKeyboard: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.adjustsImageWhenHighlighted = false
        
        return button
    }()
    
    lazy var btnEdit: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.adjustsImageWhenHighlighted = false
        
        return button
    }()
    
    var userMemoData: [String] = ENSettingManager.shared.userMemo
    
    weak var delegate: ENUserMemoTableViewDelegate? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("ENKeyboardCustomAreaView init for coder")
        setConfigureTableView()
        setTableViewCell()
        setTableViewDelegate()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("ENKeyboardCustomAreaView init for frame")
        setConfigureTableView()
        setTableViewCell()
        setTableViewDelegate()
    }
    
    func setConfigureTableView() {
        
        self.overrideUserInterfaceStyle = .light
        
        self.addSubview(userMemoTableView)
        self.addSubview(btnKeyboard)
        self.addSubview(btnEdit)
        
        btnEdit.translatesAutoresizingMaskIntoConstraints = false
        btnEdit.widthAnchor.constraint(equalToConstant: 82.0).isActive = true
        btnEdit.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        btnEdit.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        btnEdit.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        btnEdit.addTarget(self, action: #selector(btnEditHandler(_:)), for: .touchUpInside)
        
        btnEdit.setImage(UIImage.init(named: "user_memo_edit", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
        
        btnKeyboard.translatesAutoresizingMaskIntoConstraints = false
        btnKeyboard.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        btnKeyboard.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        btnKeyboard.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        btnKeyboard.bottomAnchor.constraint(equalTo: btnEdit.topAnchor, constant: -6).isActive = true
        
        btnKeyboard.setImage(UIImage.init(named: "restore_keyboard", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
        
        btnKeyboard.addTarget(self, action: #selector(btnKeyboardHandler(_:)), for: .touchUpInside)
        
        userMemoTableView.translatesAutoresizingMaskIntoConstraints = false
        userMemoTableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        userMemoTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        userMemoTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        userMemoTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        userMemoTableView.separatorStyle = .singleLine
        userMemoTableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        userMemoTableView.separatorColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
    }
    
    func setTableViewCell() {
        userMemoTableView.register(ENUserMemoTableViewCell.classForCoder(), forCellReuseIdentifier: ENUserMemoTableViewCell.ID)
    }
    
    func setTableViewDelegate() {
        userMemoTableView.delegate = self
        userMemoTableView.dataSource = self
    }
    
    @objc func btnEditHandler(_ sender: UIButton) {
        delegate?.openUserMemoEdit(from: self, targetButton: sender, userMemoEdit: nil)
    }
    
    @objc func btnKeyboardHandler(_ sender: UIButton) {
        delegate?.restoreKeyboard(from: self)
    }
}

extension ENUserMemoTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMemoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ENUserMemoTableViewCell.ID, for: indexPath) as! ENUserMemoTableViewCell
        cell.userMemoLabel.text = userMemoData[indexPath.row]
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userMemoData.count > indexPath.row {
            delegate?.didSelectUserMemo(from: self, selected: userMemoData[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            userMemoData.remove(at: indexPath.row)
            
            ENSettingManager.shared.userMemo = userMemoData
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) {[weak self] (action, view, completion) in
            guard let self else { return }
            self.userMemoData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            ENSettingManager.shared.userMemo = self.userMemoData
            completion(true)
        }
        
        action.backgroundColor = .white
        action.image = UIImage.init(named: "cell_delete_img", in: Bundle.frameworkBundle, compatibleWith: nil)
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let rootFooter = UIView(frame: CGRect.init(origin: .zero, size: CGSize.init(width: tableView.frame.width, height: 0.0)))
        let footer = UIView(frame: CGRect.init(origin: .zero, size: CGSize.init(width: tableView.frame.width, height: 0.0)))
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

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 86.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as? UITableViewHeaderFooterView
        footer?.backgroundColor = .clear
    }
}
