//
//  ENMemoDetailViewController.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/31.
//

import Foundation
import KeyboardSDKCore

protocol ENMemoDetailViewDelegate: AnyObject {
    func addMemo(memo: String)
}

class ENMemoDetailViewController: UIViewController, ENViewPrsenter, ENMemoDetailViewDelegate {
    
    func addMemo(memo: String) {
        var tempArray = ENSettingManager.shared.userMemo
        tempArray.append(memo)
        
        ENSettingManager.shared.userMemo = tempArray
                
        self.memoTableViewReload()
    }
    
    public static func create() -> ENMemoDetailViewController {
        let vc = ENMemoDetailViewController.init(nibName: "ENMemoDetailViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var memoTableView: UITableView!
    @IBOutlet weak var viewAdd: UIView!
    
    weak var eNMainViewControllerDelegate: ENMainViewControllerDelegate?
    
    var tableData = ENSettingManager.shared.userMemo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingUI()
        
        settingTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func settingTableView() {
        memoTableView.delegate = self
        memoTableView.dataSource = self
        
        memoTableView.dragInteractionEnabled = true
        memoTableView.dragDelegate = self
        memoTableView.dropDelegate = self
        
        memoTableView.estimatedRowHeight = UITableView.automaticDimension
        
        memoTableView.register(UINib.init(nibName: "ENMemoDetailCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENMemoDetailCell.ID)
        
        memoTableView.reloadData()
    }
    
    func memoTableViewReload() {
        tableData = ENSettingManager.shared.userMemo
        
        memoTableView.reloadData()
    }
    
    private func settingUI() {
        btnBack.addTarget(self, action: #selector(btnBackHandler(_:)), for: .touchUpInside)
        
        let viewAddTap = UITapGestureRecognizer(target: self, action: #selector(viewAddHandler(_:)))
        viewAdd.addGestureRecognizer(viewAddTap)
        
        viewAdd.layer.cornerRadius = 20
    }
    
    @objc func viewAddHandler(_ sender: UITapGestureRecognizer) {
        let vc = ENMemoAddViewController.create()
        vc.eNMemoDetailViewDelegate = self
        self.present(vc, animated: true)
    }
    
    @objc func btnBackHandler(_ sender: UIButton) {
        enDismiss(completion: { [weak self] in
            guard let self else { return }
            if let delegates = self.eNMainViewControllerDelegate {
                delegates.defaultTableViewReloadDelegate()
            }
        })
    }
}

extension ENMemoDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ENMemoDetailCell.ID, for: indexPath) as! ENMemoDetailCell
        
        cell.lblTitle.text = tableData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            self.tableData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            ENSettingManager.shared.userMemo = self.tableData
            completion(true)
        }
        
        action.backgroundColor = .white
        action.image = UIImage.init(named: "cell_delete_img", in: Bundle.frameworkBundle, compatibleWith: nil)
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveCell = tableData[sourceIndexPath.row]
        
        tableData.remove(at: sourceIndexPath.row)
        tableData.insert(moveCell, at: destinationIndexPath.row)
        
        ENSettingManager.shared.userMemo = tableData
    }

}

extension ENMemoDetailViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension ENMemoDetailViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
}
