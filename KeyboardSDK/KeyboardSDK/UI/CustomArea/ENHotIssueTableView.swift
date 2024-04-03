//
//  ENHotIssueTableView.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/20.
//

import Foundation
import KeyboardSDKCore

struct NewsData {
    var newsType: String
    var newsTitle: String
    var imageName: String
    var newsUrl: String
}

protocol ENHotIssueDelegate: AnyObject {
    func openUrl(url: URL)
}

class ENHotIssueTableView: UIView {
    lazy var hotIssueTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    weak var delegate: ENHotIssueDelegate? = nil
    
    var tableViewData = [
        NewsData(newsType: "연예 • 연예가화제", newsTitle: "비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유 비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유", imageName: "news_test_img", newsUrl: "https://www.naver.com"),
        NewsData(newsType: "연예 • 연예가화제", newsTitle: "비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유 비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유", imageName: "news_test_img", newsUrl: "https://www.naver.com"),
        NewsData(newsType: "연예 • 연예가화제", newsTitle: "비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유 비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유", imageName: "news_test_img", newsUrl: "https://www.naver.com"),
        NewsData(newsType: "연예 • 연예가화제", newsTitle: "비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유 비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유", imageName: "news_test_img", newsUrl: "https://www.naver.com"),
        NewsData(newsType: "연예 • 연예가화제", newsTitle: "비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유 비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유", imageName: "news_test_img", newsUrl: "https://www.naver.com"),
        NewsData(newsType: "연예 • 연예가화제", newsTitle: "비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유 비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유", imageName: "news_test_img", newsUrl: "https://www.naver.com"),
        NewsData(newsType: "연예 • 연예가화제", newsTitle: "비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유 비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유", imageName: "news_test_img", newsUrl: "https://www.naver.com"),
        NewsData(newsType: "연예 • 연예가화제", newsTitle: "비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유 비싸기도 비싼데 출연도 쉽지 않다 연예인들까지 줄 선 이유", imageName: "news_test_img", newsUrl: "https://www.naver.com")
    ]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setConfigureTableView()
        setTableViewCell()
        setTableViewDelegate()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfigureTableView()
        setTableViewCell()
        setTableViewDelegate()
    }
    
    func setConfigureTableView() {
//        print("setConfigureTableView")
        self.overrideUserInterfaceStyle = .light
        
        self.addSubview(hotIssueTableView)
        
        hotIssueTableView.translatesAutoresizingMaskIntoConstraints = false
        hotIssueTableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        hotIssueTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        hotIssueTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        hotIssueTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        hotIssueTableView.separatorStyle = .singleLine
        hotIssueTableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        hotIssueTableView.separatorColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
    }
    
    func setTableViewCell() {
//        print("setTableViewCell")
        hotIssueTableView.register(ENHotIssueTableViewCell.classForCoder(), forCellReuseIdentifier: ENHotIssueTableViewCell.ID)
    }
    
    func setTableViewDelegate() {
//        print("setTableViewDelegate")
        hotIssueTableView.delegate = self
        hotIssueTableView.dataSource = self
    }
}

extension ENHotIssueTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ENHotIssueTableViewCell.ID, for: indexPath) as! ENHotIssueTableViewCell
        
        let data = tableViewData[indexPath.row]
        
        cell.lblNewsType.text = data.newsType
        cell.lblNewsTitle.text = data.newsTitle
        cell.imgNews.image = UIImage.init(named: data.imageName, in: Bundle.frameworkBundle, compatibleWith: nil)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = tableViewData[indexPath.row]
//        print("url check : \(data.newsUrl)")
        
        if data.newsUrl != "" {
            guard let url = URL(string: data.newsUrl) else { return }
            if let del = delegate {
                del.openUrl(url: url)
            }
        }
    }
}
