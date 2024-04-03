//
//  ENHotIssueTableViewCell.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/20.
//

import Foundation

class ENHotIssueTableViewCell: UITableViewCell {
    static let ID: String = "ENHotIssueTableViewCell"
    
    var lblNewsType: UILabel!
    var lblNewsTitle: UILabel!
    var imgNews: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
        setUpCell()
    }
    
    func setUpCell() {
//        print("setUpCell")
        contentView.addSubview(lblNewsType)
        contentView.addSubview(lblNewsTitle)
        contentView.addSubview(imgNews)
        
        imgNews.translatesAutoresizingMaskIntoConstraints = false
        imgNews.widthAnchor.constraint(equalToConstant: 37).isActive = true
        imgNews.heightAnchor.constraint(equalToConstant: 37).isActive = true
        imgNews.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        imgNews.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        lblNewsType.translatesAutoresizingMaskIntoConstraints = false
        lblNewsType.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        lblNewsType.trailingAnchor.constraint(equalTo: imgNews.leadingAnchor).isActive = true
        lblNewsType.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        lblNewsType.bottomAnchor.constraint(equalTo: lblNewsTitle.topAnchor, constant: 2).isActive = true
        
        lblNewsTitle.translatesAutoresizingMaskIntoConstraints = false
        lblNewsTitle.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        lblNewsTitle.trailingAnchor.constraint(equalTo: imgNews.leadingAnchor, constant: -8).isActive = true
        lblNewsTitle.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
    
    func setUpUI() {
//        print("setUpUI")
        lblNewsType = UILabel()
        lblNewsType.textColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
        lblNewsType.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        
        lblNewsTitle = UILabel()
        lblNewsTitle.textColor = .black
        lblNewsTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        imgNews = UIImageView()
        imgNews.backgroundColor = .clear
        imgNews.clipsToBounds = true
    }
}
