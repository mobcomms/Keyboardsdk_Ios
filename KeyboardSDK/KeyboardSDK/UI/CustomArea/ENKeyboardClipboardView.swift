//
//  ENKeyboardClipboardView.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/20.
//

import Foundation
import KeyboardSDKCore


class ENClipBoardTableViewCell: UITableViewCell {
    
    static let ID: String = "ENClipBoardTableViewCell"
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func commonInit() {
        self.textLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        self.textLabel?.textColor = UIColor.init(r: 74, g: 74, b: 74)
        self.textLabel?.textAlignment = .left
        self.textLabel?.numberOfLines = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = .white
    }
    
}





protocol ENKeyboardClipboardViewDelegate: AnyObject {
    func restoreKeyboard(from clipBoardView:ENKeyboardClipboardView)
    func didSelectedClipboardItem(from clipBoardView:ENKeyboardClipboardView, selected clipboard: String)
    func needOpenAccess(from clipBoardView:ENKeyboardClipboardView)
}


public class ENKeyboardClipboardView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var infoMessageLabel: UILabel!
    
    
    @IBOutlet weak var returnKeyboardButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    
    weak var delegate: ENKeyboardClipboardViewDelegate? = nil
    
    var dataSource:[String] = []
    public static var lastAddedClipboardData:String = ""
    
    
    public var keyboardTheme: ENKeyboardTheme? = nil {
        didSet {
            updateUI()
        }
    }
    
    public var keyboardThemeModel: ENKeyboardThemeModel? = nil {
        didSet {
            updateUI()
        }
    }
    
    
    public static func create() -> ENKeyboardClipboardView {
        let nibViews = Bundle.frameworkBundle.loadNibNamed("ENKeyboardClipboardView", owner: self, options: nil)
        let tempView = nibViews?.first as! ENKeyboardClipboardView
        
        return tempView
    }
    
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    
    func commonInit() {
        tableView.register(ENClipBoardTableViewCell.self, forCellReuseIdentifier: ENClipBoardTableViewCell.ID)
        tableView.rowHeight = UITableView.automaticDimension
        
        infoMessageLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGesture(tap:))))
        infoMessageLabel.isUserInteractionEnabled = true
        
        
        if DHUtils.isOpenAccessGranted() {
            tableView.isHidden = false
            infoMessageLabel.isHidden = true
            
            loadClipBoardData()
            checkClipboardData()
        }
        else {
            infoMessageLabel.text = "전체 접근 권한이 필요합니다."
            tableView.isHidden = true
            infoMessageLabel.isHidden = false
        }
    }
    
    
    func updateUI() {
        let themeName = keyboardThemeModel?.name ?? "default"
        let isDefault = (themeName == "default")
        let folder = self.themeFolder(name: themeName, type: .custom)
        
        var backKeyboardImage:UIImage? = nil
        var refreshImage:UIImage? = nil
        
        func loadDefatulImage() {
            backKeyboardImage = UIImage.init(named: "aikbdBtnMemoKeyboard", in: Bundle.frameworkBundle, compatibleWith: nil)
            refreshImage = UIImage.init(named: "aikbdBtnMemoRefreshS", in: Bundle.frameworkBundle, compatibleWith: nil)
        }
        
        
        if isDefault {
            loadDefatulImage()
        }
        else {
            do {
                //TODO: 이미지 파일명 다시 확인해야 한다.  refresh버튼에 대해 추가 적용 필요...
                let backKeyboard = try Data(contentsOf: URL(fileURLWithPath: "\(folder.path)/aikbd_btn_memo_keyboard.png"))
//                let refresh = try Data(contentsOf: URL(fileURLWithPath: "\(folder.path)/aikbdBtnMemoRefreshS.png"))
                
                backKeyboardImage = UIImage.init(data: backKeyboard, scale: 3.0) ?? UIImage.init(named: "aikbdBtnMemoKeyboard", in: Bundle.frameworkBundle, compatibleWith: nil)
//                refreshImage = UIImage.init(data: refresh, scale: 3.0) ?? UIImage.init(named: "aikbdBtnMemoRefreshS", in: Bundle.frameworkBundle, compatibleWith: nil)
            }
            catch {
                loadDefatulImage()
            }
        }
        
        returnKeyboardButton.setImage(backKeyboardImage, for: .normal)
//        refreshButton.setImage(refreshImage, for: .normal)
    }
    
    
    func themeFolder(name:String, type: ENKeyboardThemeType) -> URL {
        var url = ENKeyboardSDKCore.shared.groupDirectoryURL
        
        if let _ = url {
            url!.appendPathComponent("theme")
            url!.appendPathComponent(name)
//            url!.appendPathComponent(type.rawValue)
            
            return url!
        }
        else {
            return URL.init(string: "")!
        }
    }
}




//MARK:- Actions

extension ENKeyboardClipboardView {
    
    
    @IBAction func restoreKeyboardButtonClicked() {
        delegate?.restoreKeyboard(from: self)
    }
    
    
    @IBAction func refreshClipboardButtonClicked() {
        checkClipboardData()
        loadClipBoardData()
    }
    
}


//MARK:- Clipboard Data Control
extension ENKeyboardClipboardView {
    
    @objc func checkClipboardData() {
        guard let clipboard = UIPasteboard.general.string else {
            return
        }
        
        let savedChangeCount = UserDefaults.standard.lastSavedClipboardChangeCount()
        let changeCount = UIPasteboard.general.changeCount
        if savedChangeCount != changeCount {        //(ENKeyboardClipboardView.lastAddedClipboardData != clipboard)
            ENKeyboardClipboardView.lastAddedClipboardData = clipboard
            
            dataSource.insert(clipboard, at: 0)
            self.saveClipboardData()
            UserDefaults.standard.saveLastSavedClipboardChangeCount(count: changeCount)
        }
    }
    
    @objc func excuteTapGesture(tap:UITapGestureRecognizer) {
        if tap.view == infoMessageLabel {
            if !DHUtils.isOpenAccessGranted() {
                delegate?.needOpenAccess(from: self)
            }
        }
    }
    
    func saveClipboardData() {
        UserDefaults.standard.saveClipboardData(clipboard: dataSource)
    }
    
    func loadClipBoardData() {
        dataSource = UserDefaults.standard.getSavedClipBoardData()
        if dataSource.count == 0 {
            showEmptyView()
        }
        else {
            tableView.isHidden = false
            infoMessageLabel.isHidden = true
            tableView.reloadData()
        }
    }
    
    func showEmptyView() {
        tableView.isHidden = true
        infoMessageLabel.isHidden = false
        infoMessageLabel.text = "가장 최근에 복사한 텍스트가\n여기에 나타납니다."
    }
    
}



//MARK:- TableView Delegate & DataSource

extension ENKeyboardClipboardView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ENClipBoardTableViewCell.ID)
        
        if dataSource.count > indexPath.row {
            cell?.textLabel?.text = dataSource[indexPath.row]
        }
        else {
            cell?.textLabel?.text = ""
        }
        
        return cell ?? UITableViewCell.init(style: .default, reuseIdentifier: "temp")
    }
 
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource.count > indexPath.row {
            delegate?.didSelectedClipboardItem(from: self, selected: dataSource[indexPath.row])
        }
    }
    
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            self.dataSource.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveClipboardData()
            
            if self.dataSource.count == 0 {
                self.showEmptyView()
            }
            
            self.showEnToast(message: "선택한 클립보드를 삭제하였습니다.",
                             font: UIFont.systemFont(ofSize: 13.0, weight: .regular),
                             backgroundColor: UIColor.init(r: 17, g: 17, b: 17, a: 255/2))
            completion(true)
        }
        delete.image = UIImage(named: "aikbdBtnMemoDeleteW", in: Bundle.frameworkBundle, compatibleWith: nil)
        delete.backgroundColor = UIColor.init(r: 255, g: 29, b: 29)

        let config = UISwipeActionsConfiguration(actions: [ delete ])
        config.performsFirstActionWithFullSwipe = false
        
        
        return config
    }
}
