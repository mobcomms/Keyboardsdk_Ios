//
//  ENSoundSelectViewController.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/05/31.
//

import UIKit
import KeyboardSDKCore


class ENSoundSelectViewController: UIViewController, ENViewPrsenter {

    public static func create() -> ENSoundSelectViewController {
        let vc = ENSoundSelectViewController.init(nibName: "ENSoundSelectViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var soundLists: [String] = []
    var selectedIndex:Int = 0
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib.init(nibName: "ENSettingRadioTableViewCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENSettingRadioTableViewCell.ID)
        
        selectedIndex = ENSettingManager.shared.soundID
        
//        UIContextualAction
        
        reloadData()
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    public func reloadData() {
        soundLists = [
            "버튼음 1",
            "버튼음 2",
            "버튼음 3",
            "버튼음 4",
            "버튼음 5"
        ]
        
        tableView.reloadData()
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        enDismiss()
    }
}



extension ENSoundSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundLists.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < soundLists.count else {
            return tableView.dequeueReusableCell(withIdentifier: ENSettingRadioTableViewCell.ID, for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ENSettingRadioTableViewCell.ID, for: indexPath) as! ENSettingRadioTableViewCell
        cell.labelTitle.text = soundLists[indexPath.row]
        cell.updateSelected(isSelected: selectedIndex == indexPath.row)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < soundLists.count else { return }
        ENSettingManager.shared.soundID = indexPath.row
        selectedIndex = ENSettingManager.shared.soundID
        
        ENKeyButtonEffectManager.shared.excuteSound(with: selectedIndex)
        
        tableView.reloadData()
    }
    
    
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}

