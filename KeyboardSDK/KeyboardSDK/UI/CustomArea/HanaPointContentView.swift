//
//  HanaPointContentView.swift
//  KeyboardSDK
//
//  Created by ximAir on 11/22/23.
//

import Foundation
import KeyboardSDKCore

protocol HanaPointContentViewDelegate: AnyObject {
    func returnKeyboard()
    func goToHanaLink(url: String)
}

class HanaPointContentView: UIView {
    weak var delegate: HanaPointContentViewDelegate? = nil
    
    lazy var topLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 66/255, blue: 72/255, alpha: 1)
        return view
    }()
    
    lazy var leftView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var leftTitle: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = UIColor(red: 191/255, green: 137/255, blue: 255/255, alpha: 1)
        lbl.textAlignment = .left
        lbl.text = "키보드 적립"
        lbl.font = .systemFont(ofSize: 15)
        lbl.backgroundColor = .clear
        return lbl
    }()
    lazy var todayLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)
        lbl.textAlignment = .left
        lbl.text = "오늘"
        lbl.font = .systemFont(ofSize: 12)
        lbl.backgroundColor = .clear
        return lbl
    }()
    lazy var currentMonthLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)
        lbl.textAlignment = .left
        lbl.text = "이번달"
        lbl.font = .systemFont(ofSize: 12)
        lbl.backgroundColor = .clear
        return lbl
    }()
    lazy var todayPoint: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.text = "-원"
        lbl.font = .systemFont(ofSize: 18)
        lbl.backgroundColor = .clear
        return lbl
    }()
    lazy var currentMonthPoint: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.text = "-원"
        lbl.font = .systemFont(ofSize: 18)
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    lazy var rightView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var rightTitleLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = UIColor(red: 19/255, green: 201/255, blue: 190/255, alpha: 1)
        lbl.textAlignment = .left
        lbl.text = "나의 하나머니"
        lbl.font = .systemFont(ofSize: 15)
        lbl.backgroundColor = .clear
        
        return lbl
    }()
    lazy var rightTitleImage: UIImageView = {
        let view: UIImageView = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage.init(named: "hanaCircleArrow", in: Bundle.frameworkBundle, compatibleWith: nil)
        return view
    }()
    lazy var currentPoint: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .right
        lbl.text = "-원"
        lbl.font = .systemFont(ofSize: 24, weight: .bold)
        lbl.backgroundColor = .clear
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
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
        
        loadPointData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingViewConstraint()
        
        loadPointData()
    }
    
    func loadPointData() {
        ENKeyboardAPIManeger.shared.getUserPoint() {[weak self] data, response, error in
            guard let self else { return }
            
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                #if DEBUG
                print("get_user_point: \(jsonString)")
                #endif
                
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(ENHanaPointContentViewModel.self, from: jsonData)
                        
                        if let resultData = data.data {
                            DispatchQueue.main.async {
                                self.settingPointView(todayPointString: resultData.today_point, monthPointString: resultData.month_point, hanaPointString: resultData.hana_point)
                            }
                        } else {
                            print("get_user_point result false : \(data.errstr ?? "nil")")
                            DispatchQueue.main.async {
                                if let str = data.errstr {
                                    if str == "" {
                                        self.settingInvalidPointView(errStr: "사용자 정보를 확인할 수 없어요. 하나머니 앱에서 인증해 주세요.")
                                    } else {
                                        self.settingInvalidPointView(errStr: str)
                                    }
                                } else {
                                    self.settingInvalidPointView(errStr: "사용자 정보를 확인할 수 없어요. 하나머니 앱에서 인증해 주세요.")
                                }
                            }
                        }

                    } catch {
                        print("get_user_point json parse error")
                        DispatchQueue.main.async {
                            self.settingInvalidPointView(errStr: "데이터 확인에 실패하였습니다. 다시 시도해 주세요.")
                        }
                    }
                    
                } else {
                    print("get_user_point json data error")
                    DispatchQueue.main.async {
                        self.settingInvalidPointView(errStr: "확인되지 않은 데이터 입니다. 다시 시도해 주세요.")
                    }
                }
                
            } else {
                print("get_user_point data & jsonString error")
                DispatchQueue.main.async {
                    self.settingInvalidPointView(errStr: "올바른 접근이 아닙니다. 다시 시도해 주세요.")
                }
            }
            
            if let err = error {
                print("get_user_point error : \(err.localizedDescription)")
                DispatchQueue.main.async {
                    self.settingInvalidPointView(errStr: "네트워크 에러입니다. 네트워크를 확인 후 다시 시도해 주세요.")
                }
            }
        }
    }
    
    func settingViewConstraint() {
        self.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
    }
    
    func settingPointView(todayPointString: String, monthPointString: String, hanaPointString: String) {
        for inner in self.subviews {
            inner.removeFromSuperview()
        }
        
        // 탑 라인 세팅
        self.addSubview(topLine)
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        // 왼쪽 view 세팅
        self.addSubview(leftView)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.widthAnchor.constraint(greaterThanOrEqualToConstant: 103).isActive = true
        leftView.heightAnchor.constraint(equalToConstant: 69).isActive = true
        leftView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22).isActive = true
        leftView.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 22).isActive = true
        
        leftView.addSubview(leftTitle)
        leftTitle.translatesAutoresizingMaskIntoConstraints = false
        leftTitle.leadingAnchor.constraint(equalTo: leftView.leadingAnchor).isActive = true
        leftTitle.trailingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
        leftTitle.topAnchor.constraint(equalTo: leftView.topAnchor).isActive = true
        
        leftView.addSubview(todayLabel)
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        todayLabel.leadingAnchor.constraint(equalTo: leftView.leadingAnchor).isActive = true
        todayLabel.widthAnchor.constraint(equalToConstant: 39).isActive = true
        todayLabel.topAnchor.constraint(equalTo: leftTitle.bottomAnchor, constant: 8).isActive = true
        
        leftView.addSubview(todayPoint)
        todayPoint.translatesAutoresizingMaskIntoConstraints = false
        todayPoint.widthAnchor.constraint(greaterThanOrEqualToConstant: 39).isActive = true
        todayPoint.leadingAnchor.constraint(equalTo: leftView.leadingAnchor).isActive = true
        todayPoint.topAnchor.constraint(equalTo: todayLabel.bottomAnchor).isActive = true
        todayPoint.text = "\(numberComma(input: todayPointString))원"

        leftView.addSubview(currentMonthLabel)
        currentMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        currentMonthLabel.leadingAnchor.constraint(equalTo: todayPoint.trailingAnchor, constant: 5).isActive = true

        currentMonthLabel.widthAnchor.constraint(equalToConstant: 49).isActive = true
        currentMonthLabel.topAnchor.constraint(equalTo: leftTitle.bottomAnchor, constant: 8).isActive = true
        
        leftView.addSubview(currentMonthPoint)
        currentMonthPoint.translatesAutoresizingMaskIntoConstraints = false
        currentMonthPoint.leadingAnchor.constraint(equalTo: currentMonthLabel.leadingAnchor).isActive = true
        currentMonthPoint.widthAnchor.constraint(greaterThanOrEqualToConstant: 49).isActive = true
        currentMonthPoint.trailingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
//        leftView.trailingAnchor.constraint(equalTo: currentMonthPoint.trailingAnchor).isActive = true

        currentMonthPoint.topAnchor.constraint(equalTo: currentMonthLabel.bottomAnchor).isActive = true
        currentMonthPoint.text = "\(numberComma(input: monthPointString))원"

        // 오른쪽 view 세팅
        self.addSubview(rightView)
        rightView.translatesAutoresizingMaskIntoConstraints = false
        rightView.leadingAnchor.constraint(greaterThanOrEqualTo: leftView.trailingAnchor, constant: 5).isActive = true

        rightView.widthAnchor.constraint(greaterThanOrEqualToConstant: 107).isActive = true
        rightView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        rightView.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 22).isActive = true
        rightView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22).isActive = true
        
        let rightViewTapGesture = MyTapGesture(target: self, action: #selector(tapHandller(_:)))
        rightViewTapGesture.title = "hanamembersAPP0030://callByHms?menu_no=100"
        rightView.addGestureRecognizer(rightViewTapGesture)
        
        rightView.addSubview(rightTitleImage)
        rightTitleImage.translatesAutoresizingMaskIntoConstraints = false
        rightTitleImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        rightTitleImage.heightAnchor.constraint(equalToConstant: 18).isActive = true
        rightTitleImage.trailingAnchor.constraint(equalTo: rightView.trailingAnchor).isActive = true
        rightTitleImage.topAnchor.constraint(equalTo: rightView.topAnchor).isActive = true
        
        rightView.addSubview(rightTitleLabel)
        rightTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        rightTitleLabel.leadingAnchor.constraint(equalTo: rightView.leadingAnchor).isActive = true
        rightTitleLabel.topAnchor.constraint(equalTo: rightView.topAnchor).isActive = true
        rightTitleLabel.trailingAnchor.constraint(equalTo: rightTitleImage.leadingAnchor).isActive = true
        
        rightView.addSubview(currentPoint)
        currentPoint.translatesAutoresizingMaskIntoConstraints = false
        currentPoint.leadingAnchor.constraint(equalTo: rightView.leadingAnchor).isActive = true
        currentPoint.trailingAnchor.constraint(equalTo: rightView.trailingAnchor).isActive = true
        currentPoint.topAnchor.constraint(equalTo: rightTitleImage.bottomAnchor, constant: 15).isActive = true
        currentPoint.text = "\(numberComma(input: hanaPointString))원"

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
        
        let bottomRightViewTap = MyTapGesture(target: self, action: #selector(tapHandller(_:)))
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
    }
    
    func settingInvalidPointView(errStr: String?) {
        for inner in self.subviews {
            inner.removeFromSuperview()
        }
        
        // 탑 라인 세팅
        self.addSubview(topLine)
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topLine.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        let noPointLabel: UILabel = UILabel()
        noPointLabel.text = errStr
        noPointLabel.font = .systemFont(ofSize: 14, weight: .medium)
        noPointLabel.textColor = .white
        noPointLabel.backgroundColor = .clear
        noPointLabel.textAlignment = .center
        
        self.addSubview(noPointLabel)
        
        noPointLabel.translatesAutoresizingMaskIntoConstraints = false
        noPointLabel.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 15).isActive = true
        noPointLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        noPointLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
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
        
        let bottomRightViewTap = MyTapGesture(target: self, action: #selector(tapHandller(_:)))
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
        
        
    }
    
    @objc func bottomKeyboardHandler() {
        if let del = delegate {
            del.returnKeyboard()
        }
    }
    
    @objc func tapHandller(_ sender: MyTapGesture) {
        if let urlString = sender.title {
            if let del = delegate {
                del.goToHanaLink(url: urlString)
            }
        }
    }
    
    func numberComma(input: String) -> String {
        let numberFormatter = NumberFormatter()
           numberFormatter.numberStyle = .decimal
           
           if let intValue = Int(input) {
               return numberFormatter.string(from: NSNumber(value: intValue)) ?? input
           }
           
           return input
    }
}

struct ENHanaPointContentInnerModel: Codable {
    let today_point: String
    let month_point: String
    let hana_point: String
}

struct ENHanaPointContentViewModel: Codable {
    let Result: String?
    let errcode: String?
    let errstr: String?
    let data: ENHanaPointContentInnerModel?
}
