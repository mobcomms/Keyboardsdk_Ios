//
//  HanaContentView.swift
//  KeyboardSDK
//
//  Created by ximAir on 11/22/23.
//

import Foundation

protocol HanaContentViewDelegate: AnyObject {
    func returnKeyboard()
    func goToHanaLink(url: String)
}

class HanaContentView: UIView {
    weak var delegate: HanaContentViewDelegate? = nil
    
    lazy var topLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 66/255, blue: 72/255, alpha: 1)
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view: UIStackView = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()
    
    lazy var freeItem: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var freeImage: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.backgroundColor = .clear
        imgView.image = UIImage.init(named: "hanaFreeImage", in: Bundle.frameworkBundle, compatibleWith: nil)
        return imgView
    }()
    lazy var freeLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.text = "무료송금"
        lbl.font = .systemFont(ofSize: 13)
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    lazy var luckyItem: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var luckyImage: UIImageView = {
        let view: UIImageView = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage.init(named: "hanaLuckyImage", in: Bundle.frameworkBundle, compatibleWith: nil)
        return view
    }()
    lazy var luckyLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.text = "행운상자"
        lbl.font = .systemFont(ofSize: 13)
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    lazy var dayCheckItem: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var dayCheckImage: UIImageView = {
        let view: UIImageView = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage.init(named: "hanaDayCheckImage", in: Bundle.frameworkBundle, compatibleWith: nil)
        return view
    }()
    lazy var dayCheckLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.text = "출석체크"
        lbl.font = .systemFont(ofSize: 13)
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    lazy var clickItem: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var clickImage: UIImageView = {
        let view: UIImageView = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage.init(named: "hanaClickImage", in: Bundle.frameworkBundle, compatibleWith: nil)
        return view
    }()
    lazy var clickLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.text = "클릭머니쌓기"
        lbl.font = .systemFont(ofSize: 13)
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    lazy var bottomLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(red: 28/255, green: 31/255, blue: 33/255, alpha: 1)
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var bottomKeyboardButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.backgroundColor = .clear
        btn.setBackgroundImage(UIImage.init(named: "hanaBottomKeyboard", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
        return btn
    }()
    lazy var bottomRightView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var bottomRightIcon: UIImageView = {
        let view: UIImageView = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage.init(named: "hanaBottomIcon", in: Bundle.frameworkBundle, compatibleWith: nil)
        return view
    }()
    lazy var bottomRightLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.text = "하나머니 조회하기"
        lbl.font = .systemFont(ofSize: 13)
        lbl.backgroundColor = .clear
        return lbl
    }()
    lazy var bottomRightArrow: UIImageView = {
        let view: UIImageView = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage.init(named: "hanaBottomArrow", in: Bundle.frameworkBundle, compatibleWith: nil)
        return view
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        settingViewConstraint()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingViewConstraint()
    }
    
    func settingViewConstraint() {
        self.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)

        // 탑 라인 세팅
        self.addSubview(topLine)
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        // 스택 뷰 세팅
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22).isActive = true
        stackView.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 22).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        // 공통 크기 세팅
        let itemWidth: CGFloat = 70
        let itemHeight: CGFloat = 68
        let imageWidth: CGFloat = 53
        let imageHeight: CGFloat = 48
        
        // 무료송금 세팅
        stackView.addArrangedSubview(freeItem)
        freeItem.translatesAutoresizingMaskIntoConstraints = false
        freeItem.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
        freeItem.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
    
        freeItem.addSubview(freeImage)
        freeImage.translatesAutoresizingMaskIntoConstraints = false
        freeImage.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        freeImage.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        freeImage.topAnchor.constraint(equalTo: freeItem.topAnchor).isActive = true
        freeImage.leadingAnchor.constraint(equalTo: freeItem.leadingAnchor, constant: 8).isActive = true
        freeImage.trailingAnchor.constraint(equalTo: freeItem.trailingAnchor, constant: -8).isActive = true
        
        freeItem.addSubview(freeLabel)
        freeLabel.translatesAutoresizingMaskIntoConstraints = false
        freeLabel.topAnchor.constraint(equalTo: freeImage.bottomAnchor).isActive = true
        freeLabel.bottomAnchor.constraint(equalTo: freeItem.bottomAnchor).isActive = true
        freeLabel.leadingAnchor.constraint(equalTo: freeItem.leadingAnchor).isActive = true
        freeLabel.trailingAnchor.constraint(equalTo: freeItem.trailingAnchor).isActive = true
        
        // 행운상자 세팅
        stackView.addArrangedSubview(luckyItem)
        luckyItem.translatesAutoresizingMaskIntoConstraints = false
        luckyItem.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
        luckyItem.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        
        luckyItem.addSubview(luckyImage)
        luckyImage.translatesAutoresizingMaskIntoConstraints = false
        luckyImage.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        luckyImage.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        luckyImage.topAnchor.constraint(equalTo: luckyItem.topAnchor).isActive = true
        luckyImage.leadingAnchor.constraint(equalTo: luckyItem.leadingAnchor, constant: 8).isActive = true
        luckyImage.trailingAnchor.constraint(equalTo: luckyItem.trailingAnchor, constant: -8).isActive = true
        
        luckyItem.addSubview(luckyLabel)
        luckyLabel.translatesAutoresizingMaskIntoConstraints = false
        luckyLabel.topAnchor.constraint(equalTo: luckyImage.bottomAnchor).isActive = true
        luckyLabel.bottomAnchor.constraint(equalTo: luckyItem.bottomAnchor).isActive = true
        luckyLabel.leadingAnchor.constraint(equalTo: luckyItem.leadingAnchor).isActive = true
        luckyLabel.trailingAnchor.constraint(equalTo: luckyItem.trailingAnchor).isActive = true
        
        // 출석체크 세팅
        stackView.addArrangedSubview(dayCheckItem)
        dayCheckItem.translatesAutoresizingMaskIntoConstraints = false
        dayCheckItem.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
        dayCheckItem.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        
        dayCheckItem.addSubview(dayCheckImage)
        dayCheckImage.translatesAutoresizingMaskIntoConstraints = false
        dayCheckImage.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        dayCheckImage.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        dayCheckImage.topAnchor.constraint(equalTo: dayCheckItem.topAnchor).isActive = true
        dayCheckImage.leadingAnchor.constraint(equalTo: dayCheckItem.leadingAnchor, constant: 8).isActive = true
        dayCheckImage.trailingAnchor.constraint(equalTo: dayCheckItem.trailingAnchor, constant: -8).isActive = true
        
        dayCheckItem.addSubview(dayCheckLabel)
        dayCheckLabel.translatesAutoresizingMaskIntoConstraints = false
        dayCheckLabel.topAnchor.constraint(equalTo: dayCheckImage.bottomAnchor).isActive = true
        dayCheckLabel.bottomAnchor.constraint(equalTo: dayCheckItem.bottomAnchor).isActive = true
        dayCheckLabel.leadingAnchor.constraint(equalTo: dayCheckItem.leadingAnchor).isActive = true
        dayCheckLabel.trailingAnchor.constraint(equalTo: dayCheckItem.trailingAnchor).isActive = true
        
        // 클릭머니쌓기 세팅
        stackView.addArrangedSubview(clickItem)
        clickItem.translatesAutoresizingMaskIntoConstraints = false
        clickItem.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
        clickItem.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        
        clickItem.addSubview(clickImage)
        clickImage.translatesAutoresizingMaskIntoConstraints = false
        clickImage.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        clickImage.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        clickImage.topAnchor.constraint(equalTo: clickItem.topAnchor).isActive = true
        clickImage.leadingAnchor.constraint(equalTo: clickItem.leadingAnchor, constant: 8).isActive = true
        clickImage.trailingAnchor.constraint(equalTo: clickItem.trailingAnchor, constant: -8).isActive = true
        
        dayCheckItem.addSubview(clickLabel)
        clickLabel.translatesAutoresizingMaskIntoConstraints = false
        clickLabel.topAnchor.constraint(equalTo: clickImage.bottomAnchor).isActive = true
        clickLabel.bottomAnchor.constraint(equalTo: clickItem.bottomAnchor).isActive = true
        clickLabel.leadingAnchor.constraint(equalTo: clickItem.leadingAnchor).isActive = true
        clickLabel.trailingAnchor.constraint(equalTo: clickItem.trailingAnchor).isActive = true
        
        // 바텀 뷰 세팅
        self.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        bottomView.addSubview(bottomLine)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        bottomLine.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        bottomView.addSubview(bottomKeyboardButton)
        bottomKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        bottomKeyboardButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bottomKeyboardButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bottomKeyboardButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 18).isActive = true
        bottomKeyboardButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        bottomKeyboardButton.addTarget(self, action: #selector(bottomKeyboardHandler), for: .touchUpInside)
        
        bottomView.addSubview(bottomRightView)
        bottomRightView.translatesAutoresizingMaskIntoConstraints = false
        bottomRightView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        bottomRightView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bottomRightView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16).isActive = true
        bottomRightView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        
        let bottomRightViewTap = MyTapGesture(target: self, action: #selector(tapGestureHandler(_:)))
        bottomRightViewTap.title = "hanamembersAPP0030://callByHms?menu_no=100"
        bottomRightView.addGestureRecognizer(bottomRightViewTap)
        
        bottomRightView.addSubview(bottomRightIcon)
        bottomRightIcon.translatesAutoresizingMaskIntoConstraints = false
        bottomRightIcon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        bottomRightIcon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        bottomRightIcon.leadingAnchor.constraint(equalTo: bottomRightView.leadingAnchor).isActive = true
        bottomRightIcon.centerYAnchor.constraint(equalTo: bottomRightView.centerYAnchor).isActive = true
        
        bottomRightView.addSubview(bottomRightArrow)
        bottomRightArrow.translatesAutoresizingMaskIntoConstraints = false
        bottomRightArrow.widthAnchor.constraint(equalToConstant: 5.88).isActive = true
        bottomRightArrow.heightAnchor.constraint(equalToConstant: 16).isActive = true
        bottomRightArrow.trailingAnchor.constraint(equalTo: bottomRightView.trailingAnchor).isActive = true
        bottomRightArrow.centerYAnchor.constraint(equalTo: bottomRightView.centerYAnchor).isActive = true
        
        bottomRightView.addSubview(bottomRightLabel)
        bottomRightLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomRightLabel.leadingAnchor.constraint(equalTo: bottomRightIcon.trailingAnchor).isActive = true
        bottomRightLabel.trailingAnchor.constraint(equalTo: bottomRightArrow.leadingAnchor).isActive = true
        bottomRightLabel.topAnchor.constraint(equalTo: bottomRightView.topAnchor).isActive = true
        bottomRightLabel.bottomAnchor.constraint(equalTo: bottomRightView.bottomAnchor).isActive = true
        
        dataSetting()
    }
    
    func dataSetting() {
        ENKeyboardAPIManeger.shared.getTabDetail() {[weak self] data, response, error in
            guard let self else { return }
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                if let jsonData = jsonString.data(using: .utf8) {
                    #if DEBUG
                    print("jsonString: \(jsonString)")
                    #endif
                    
                    do {
                        let data = try JSONDecoder().decode(ENHanaContentAPIModel.self, from: jsonData)
                        #if DEBUG
                        print("saveKeyboardTypeAPI result : \(data.Result)")
                        #endif
                        
                        if data.Result == "true" {
                            for innerData in data.list {
                                DispatchQueue.main.async {
                                    switch innerData.name {
                                    case "무료송금":
                                        self.freeLabel.text = innerData.name
                                        self.freeImage.loadImageAsync(with: innerData.imageUrl)
                                        
                                        let freeItemTap = MyTapGesture(target: self, action: #selector(self.tapGestureHandler(_:)))
                                        freeItemTap.title = innerData.link
                                        self.freeItem.addGestureRecognizer(freeItemTap)
                                        break
                                    case "행운상자":
                                        self.luckyLabel.text = innerData.name
                                        self.luckyImage.loadImageAsync(with: innerData.imageUrl)
                                        
                                        let luckyItemTap = MyTapGesture(target: self, action: #selector(self.tapGestureHandler(_:)))
                                        luckyItemTap.title = innerData.link
                                        self.luckyItem.addGestureRecognizer(luckyItemTap)
                                        break
                                    case "출석체크":
                                        self.dayCheckLabel.text = innerData.name
                                        self.dayCheckImage.loadImageAsync(with: innerData.imageUrl)
                                        
                                        let dayCheckItemTap = MyTapGesture(target: self, action: #selector(self.tapGestureHandler(_:)))
                                        dayCheckItemTap.title = innerData.link
                                        self.dayCheckItem.addGestureRecognizer(dayCheckItemTap)
                                        break
                                    case "클릭머니쌓기":
                                        self.clickLabel.text = innerData.name
                                        self.clickImage.loadImageAsync(with: innerData.imageUrl)
                                        
                                        let clickItemTap = MyTapGesture(target: self, action: #selector(self.tapGestureHandler(_:)))
                                        clickItemTap.title = innerData.link
                                        self.clickItem.addGestureRecognizer(clickItemTap)
                                        break
                                    default:
                                        print("default")
                                    }
                                }
                            }
                        }
                        
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }
    
    @objc func bottomKeyboardHandler() {
        if let del = delegate {
            del.returnKeyboard()
        }
    }
    
    @objc func tapGestureHandler(_ sender: MyTapGesture) {
        if let urlString = sender.title {
            if let del = delegate {
                del.goToHanaLink(url: urlString)
            }
        }
    }
}

struct ENHanaContentAPIInnerModel: Codable {
    let link: String
    let name: String
    let imageUrl: String
}

struct ENHanaContentAPIModel: Codable {
    let Result: String
    let list: [ENHanaContentAPIInnerModel]
}

class MyTapGesture: UITapGestureRecognizer {
    var title: String?
}
