//
//  ENUserMemoTableViewCell.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/12.
//

import Foundation

class ENUserMemoTableViewCell: UITableViewCell {
    static let ID: String = "ENUserMemoTableViewCell"
    var userMemoLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
        setUpLabel()
    }
    
    func setUpCell() {
        userMemoLabel = UILabel()
        contentView.addSubview(userMemoLabel)
        
        userMemoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userMemoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        userMemoLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        userMemoLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        userMemoLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    func setUpLabel() {
        userMemoLabel.textColor = .black
        userMemoLabel.font = UIFont.systemFont(ofSize: 14)
        userMemoLabel.textAlignment = .left
    }
}
