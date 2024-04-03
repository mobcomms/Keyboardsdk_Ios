//
//  ENSubContentViewController.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/23.
//

import Foundation

public class ENSubContentView: UIView {
    public lazy var lblTest: UILabel = {
        let lblTest = UILabel()
        lblTest.text = "광고 & 뉴스 영역"
        lblTest.textColor = .white
        
        return lblTest
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLayout()
    }
    
    func initLayout() {
        self.backgroundColor = .darkGray
        self.addSubview(lblTest)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        lblTest.translatesAutoresizingMaskIntoConstraints = false
        lblTest.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lblTest.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        lblTest.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lblTest.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
}
