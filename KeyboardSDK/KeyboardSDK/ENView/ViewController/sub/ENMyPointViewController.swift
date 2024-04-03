//
//  ENMyPointViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/18.
//

import Foundation
import KeyboardSDKCore

struct ENMyPointStruct {
    var pointType: String
    var pointDate: String
    var point: String
    var bestPoint: String?
}

class ENMyPointViewController: UIViewController, ENViewPrsenter {
    public static func create() -> ENMyPointViewController {
        let vc = ENMyPointViewController.init(nibName: "ENMyPointViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var myPointTableView: UITableView!
    @IBOutlet weak var btnDetailPoint: UIButton!
    @IBOutlet weak var lblNoData: UILabel!
    
    var tableViewData:[ENMyPointStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDataSetting()
        
        if tableViewData.isEmpty {
            myPointTableView.isHidden = true
            lblNoData.isHidden = false
        } else {
            myPointTableView.isHidden = false
            lblNoData.isHidden = true
            
            registerCell()
            
            myPointTableView.delegate = self
            myPointTableView.dataSource = self
        
            myPointTableView.reloadData()
        }
        
        btnBack.addTarget(self, action: #selector(btnBackHandler(_:)), for: .touchUpInside)
        
        btnDetailPoint.layer.cornerRadius = 12
        btnDetailPoint.addTarget(self, action: #selector(btnDetailPointHandler(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func btnBackHandler(_ sender: UIButton) {
        enDismiss()
    }
    
    @objc func btnDetailPointHandler(_ sender: UIButton) {
        let vc = ENPointDetailViewController.create()
        enPresent(vc, animated: true)
    }
    
    private func tableViewDataSetting() {
        tableViewData = [
            ENMyPointStruct(pointType: "TOTAL", pointDate: "", point: "12345"),
            ENMyPointStruct(pointType: "TODAY", pointDate: "", point: "32", bestPoint: "214"),
            ENMyPointStruct(pointType: "MONTH", pointDate: "9", point: "189", bestPoint: "434"),
            ENMyPointStruct(pointType: "MONTH", pointDate: "8", point: "214", bestPoint: "230"),
            ENMyPointStruct(pointType: "MONTH", pointDate: "7", point: "93", bestPoint: "301"),
            ENMyPointStruct(pointType: "MONTH", pointDate: "6", point: "372", bestPoint: "399"),
        ]
    }
    
    private func registerCell() {
        myPointTableView.register(UINib.init(nibName: "ENPointCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENPointCell.ID)
        myPointTableView.register(UINib.init(nibName: "ENPointBarCell", bundle: Bundle.frameworkBundle), forCellReuseIdentifier: ENPointBarCell.ID)
    }
    
    func numberComma(num: Int) -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let result: String = numberFormatter.string(for: num)!
        return result
    }
    
}

extension ENMyPointViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let target = tableViewData[indexPath.row]
        
        var tempCell: UITableViewCell? = nil
        
        switch target.pointType {
        case "TOTAL":
            let cell = tableView.dequeueReusableCell(withIdentifier: ENPointCell.ID, for: indexPath) as! ENPointCell
            
            let targetPointDateInt = Int(target.pointDate) ?? 0
            cell.lblCellTitle.text = "\(numberComma(num: targetPointDateInt))일 동안 받은 포인트"
            
            let targetPointInt = Int(target.point) ?? 0
            cell.lblCellPoint.text = "\(numberComma(num: targetPointInt))"
            
            tempCell = cell
            break
        case "TODAY":
            let cell = tableView.dequeueReusableCell(withIdentifier: ENPointBarCell.ID, for: indexPath) as! ENPointBarCell
            cell.lblCellTitle.text = "오늘 받은 포인트"
            
            let targetPointInt = Int(target.point) ?? 0
            cell.lblCellPoint.text = "\(numberComma(num: targetPointInt))"
            
            let targetBestPointInt = Int(target.bestPoint ?? "0") ?? 0
            cell.lblSubPoint.text = "1등 \(numberComma(num: targetBestPointInt))P"
            
            let progress = Float(1 * targetPointInt) / Float(targetBestPointInt)
//            print("프로그레스 : \(progress)")
            cell.pointBar.progress = progress
            
            tempCell = cell
            break
        case "MONTH":
            let cell = tableView.dequeueReusableCell(withIdentifier: ENPointBarCell.ID, for: indexPath) as! ENPointBarCell
            cell.lblCellTitle.text = "\(target.pointDate)월에 받은 포인트"
            
            let targetPointInt = Int(target.point) ?? 0
            cell.lblCellPoint.text = "\(numberComma(num: targetPointInt))"
            
            let targetBestPointInt = Int(target.bestPoint ?? "0") ?? 0
            cell.lblSubPoint.text = "1등 \(numberComma(num: targetBestPointInt))P"
            
            let progress = Float(1 * targetPointInt) / Float(targetBestPointInt)
            cell.pointBar.progress = progress
            
            tempCell = cell
            break
        default:
            break
        }
        
        tempCell?.backgroundColor = .white
        tempCell?.layer.borderWidth = 1.0
        tempCell?.layer.borderColor = UIColor.white.cgColor
        
        return tempCell ?? tableView.dequeueReusableCell(withIdentifier: ENPointCell.ID, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 137
        } else {
            return 202
        }
    }
}
