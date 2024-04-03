//
//  ENPointDetailViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/18.
//

import Foundation
import KeyboardSDKCore

struct ENPointDetailModel {
    var point: String
    var pointDate: String
    var pointDesc: String
    var pointType: String
}

class ENPointDetailViewController: UIViewController, ENViewPrsenter {
    public static func create() -> ENPointDetailViewController {
        let vc = ENPointDetailViewController.init(nibName: "ENPointDetailViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    
    var tableData: [ENPointDetailModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.addTarget(self, action: #selector(btnBackHandler(_:)), for: .touchUpInside)
        
        listTableView.rowHeight = 74
        
        tableData = [
            ENPointDetailModel(point: "5", pointDate: "2023.12.12 | 10:42:24", pointDesc: "광고 적립", pointType: "ADD"),
            ENPointDetailModel(point: "1", pointDate: "2023.12.12 | 10:32:24", pointDesc: "광고 적립", pointType: "ADD"),
            ENPointDetailModel(point: "22", pointDate: "2023.12.12 | 10:28:24", pointDesc: "광고 적립", pointType: "DELETE"),
            ENPointDetailModel(point: "51", pointDate: "2023.12.12 | 10:27:24", pointDesc: "광고 적립", pointType: "ADD"),
            ENPointDetailModel(point: "21", pointDate: "2023.12.12 | 10:26:24", pointDesc: "광고 적립", pointType: "ADD"),
            ENPointDetailModel(point: "30", pointDate: "2023.12.12 | 10:25:24", pointDesc: "광고 적립", pointType: "DELETE"),
            ENPointDetailModel(point: "1", pointDate: "2023.12.12 | 10:24:24", pointDesc: "광고 적립", pointType: "ADD"),
            ENPointDetailModel(point: "9", pointDate: "2023.12.12 | 10:23:24", pointDesc: "광고 적립", pointType: "ADD"),
            ENPointDetailModel(point: "10", pointDate: "2023.12.12 | 10:22:24", pointDesc: "광고 적립", pointType: "ADD")
        ]
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        listTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listTableView.register(UINib.init(nibName: "ENPointDetailCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENPointDetailCell.ID)
    }
    
    @objc func btnBackHandler(_ sender: UIButton) {
        enDismiss()
    }
    
}

extension ENPointDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let targetData = tableData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ENPointDetailCell.ID, for: indexPath) as! ENPointDetailCell
        cell.lblTitle.text = targetData.pointDesc
        cell.lblDate.text = targetData.pointDate
        
        if targetData.pointType == "ADD" {
            cell.lblPoint.text = "+ \(targetData.point)P"
        } else {
            cell.lblPoint.text = "- \(targetData.point)P"
        }
        
        return cell
    }
    
}
