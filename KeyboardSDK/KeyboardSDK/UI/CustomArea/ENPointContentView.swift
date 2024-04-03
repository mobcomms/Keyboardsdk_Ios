//
//  ENPointContentView.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2024/02/15.
//

import Foundation
import KeyboardSDKCore

protocol ENPointContentViewDelegate: AnyObject {
    func returnKeyboard()
    func goToContentLink(url: String)
}

class ENPointContentView: UIView {
    weak var delegate: ENPointContentViewDelegate? = nil
    
    lazy var topLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.top_line
        return view
    }()
    
    lazy var leftView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear

        return view
    }()
    lazy var leftIcon: UIImageView = {
        let view: UIImageView = UIImageView()
        view.backgroundColor = .clear

        view.image = UIImage.init(named: "cashwalk_toolbar_point_list", in: Bundle.frameworkBundle, compatibleWith: nil)
        return view
    }()

    lazy var leftTitle: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.key_text
        lbl.textAlignment = .left
        lbl.text = "키보드 적립"
        lbl.font = .systemFont(ofSize: 18)
        lbl.backgroundColor = .clear
        return lbl
    }()
    lazy var todayLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.specialKeyTextColor
        lbl.textAlignment = .left
        lbl.text = "오늘"
        lbl.font = .systemFont(ofSize: 15, weight: .thin)
        lbl.backgroundColor = .clear
        return lbl
    }()
    lazy var currentMonthLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.specialKeyTextColor
        lbl.textAlignment = .left
        lbl.text = "이번달"
        lbl.font = .systemFont(ofSize: 15, weight: .thin)
        lbl.backgroundColor = .clear
        return lbl
    }()
    lazy var todayPoint: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.key_text
        lbl.textAlignment = .left
        lbl.text = "-캐시"
        lbl.font = .systemFont(ofSize: 21, weight: .semibold)
        lbl.backgroundColor = .clear
        return lbl
    }()
    lazy var currentMonthPoint: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.key_text
        lbl.textAlignment = .left
        lbl.text = "-캐시"
        lbl.font = .systemFont(ofSize: 21, weight: .semibold)
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
        lbl.textColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.key_text
        lbl.textAlignment = .left
        lbl.text = "나의 캐시워크"
        lbl.font = .systemFont(ofSize: 12)
        lbl.backgroundColor = .clear
        
        return lbl
    }()
    lazy var topRightArrow: UIImageView = {
        let view: UIImageView = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage.init(named: "btn_bottom_Arrow", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        view.tintColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.key_text

        return view
    }()

    lazy var currentPoint: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.key_text
        lbl.textAlignment = .right
        lbl.text = "-캐시"
        lbl.font = .systemFont(ofSize: 23, weight: .semibold)
        lbl.backgroundColor = .clear
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    lazy var bottomLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.top_line
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
        let image = UIImage.init(named: "ENBottomKeyboard", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        btn.setImage(image, for: .normal)
        btn.tintColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.key_text
        return btn
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
                print("get_user_point: \(jsonString)")

                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(ENPointContentViewModel.self, from: jsonData)
                        
                        if let resultData = data.data {
                            DispatchQueue.main.async {
                                self.settingPointView(todayPointString: resultData.today_point, monthPointString: resultData.month_point, allPointString: resultData.all_point)
                            }
                        } else {
                            DispatchQueue.main.async {
                                if let str = data.errstr {
                                    if str == "" {
                                        self.settingInvalidPointView(errStr: "사용자 정보를 확인할 수 없어요. 캐시워크 앱에서 인증해 주세요.")
                                    } else {
                                        self.settingInvalidPointView(errStr: str)
                                    }
                                } else {
                                    self.settingInvalidPointView(errStr: "사용자 정보를 확인할 수 없어요. 캐시워크 앱에서 인증해 주세요.")
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
        self.backgroundColor = .white

    }
    
    func settingPointView(todayPointString: String, monthPointString: String, allPointString: String) {
        for inner in self.subviews {
            inner.removeFromSuperview()
        }
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
        leftView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22).isActive = true
        leftView.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 15).isActive = true
        leftView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true

        
        leftView.addSubview(leftIcon)
        leftIcon.translatesAutoresizingMaskIntoConstraints = false
        leftIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        leftIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        leftIcon.leadingAnchor.constraint(equalTo: leftView.leadingAnchor).isActive = true
        leftIcon.topAnchor.constraint(equalTo: leftView.topAnchor).isActive = true

        
        leftView.addSubview(leftTitle)
        leftTitle.translatesAutoresizingMaskIntoConstraints = false
        leftTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        leftTitle.leadingAnchor.constraint(equalTo: leftIcon.trailingAnchor, constant: 5).isActive = true
        leftTitle.trailingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
        leftTitle.centerYAnchor.constraint(equalTo: leftIcon.centerYAnchor).isActive = true
        
        leftView.addSubview(todayLabel)
        todayLabel.translatesAutoresizingMaskIntoConstraints = false
        todayLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        todayLabel.widthAnchor.constraint(equalToConstant: 39).isActive = true
        todayLabel.leadingAnchor.constraint(equalTo: leftView.leadingAnchor).isActive = true
        todayLabel.topAnchor.constraint(equalTo: leftTitle.bottomAnchor, constant: 13).isActive = true

        leftView.addSubview(todayPoint)
        todayPoint.translatesAutoresizingMaskIntoConstraints = false
        todayPoint.heightAnchor.constraint(equalToConstant: 35).isActive = true
        todayPoint.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        todayPoint.leadingAnchor.constraint(equalTo: leftView.leadingAnchor).isActive = true
        todayPoint.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 5).isActive = true
        todayPoint.text = "\(numberComma(input: todayPointString))캐시"

        leftView.addSubview(currentMonthLabel)
        currentMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        currentMonthLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        currentMonthLabel.widthAnchor.constraint(equalToConstant: 49).isActive = true
        currentMonthLabel.leadingAnchor.constraint(equalTo: todayPoint.trailingAnchor, constant: 5).isActive = true
        currentMonthLabel.topAnchor.constraint(equalTo: leftTitle.bottomAnchor, constant: 13).isActive = true
        
        leftView.addSubview(currentMonthPoint)
        currentMonthPoint.translatesAutoresizingMaskIntoConstraints = false
        currentMonthPoint.heightAnchor.constraint(equalToConstant: 35).isActive = true
        currentMonthPoint.widthAnchor.constraint(greaterThanOrEqualToConstant: 49).isActive = true
        currentMonthPoint.leadingAnchor.constraint(equalTo: currentMonthLabel.leadingAnchor).isActive = true
        currentMonthPoint.trailingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
        currentMonthPoint.topAnchor.constraint(equalTo: currentMonthLabel.bottomAnchor, constant: 5).isActive = true
        currentMonthPoint.text = "\(numberComma(input: monthPointString))캐시"

        // 오른쪽 view 세팅
        self.addSubview(rightView)
        rightView.translatesAutoresizingMaskIntoConstraints = false
        rightView.widthAnchor.constraint(greaterThanOrEqualToConstant: 107).isActive = true
        rightView.leadingAnchor.constraint(greaterThanOrEqualTo: leftView.trailingAnchor, constant: 5).isActive = true
        rightView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22).isActive = true
        rightView.topAnchor.constraint(equalTo: leftView.topAnchor).isActive = true
        rightView.bottomAnchor.constraint(equalTo: leftView.bottomAnchor).isActive = true
        
        let rightViewTapGesture = ENTapGesture(target: self, action: #selector(tapHandller(_:)))
        rightViewTapGesture.title = "https://www.naver.com"
        rightView.addGestureRecognizer(rightViewTapGesture)
        
        
        rightView.addSubview(topRightArrow)
        topRightArrow.translatesAutoresizingMaskIntoConstraints = false
        topRightArrow.widthAnchor.constraint(equalToConstant: 5.88).isActive = true
        topRightArrow.heightAnchor.constraint(equalToConstant: 16).isActive = true
        topRightArrow.trailingAnchor.constraint(equalTo: rightView.trailingAnchor).isActive = true
        topRightArrow.topAnchor.constraint(equalTo: rightView.topAnchor, constant:9).isActive = true
        

        
        rightView.addSubview(rightTitleLabel)
        rightTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        rightTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        rightTitleLabel.trailingAnchor.constraint(equalTo: topRightArrow.leadingAnchor, constant: -2.5).isActive = true
        rightTitleLabel.topAnchor.constraint(equalTo: rightView.topAnchor, constant:7).isActive = true

        rightView.addSubview(currentPoint)
        currentPoint.translatesAutoresizingMaskIntoConstraints = false
        currentPoint.heightAnchor.constraint(equalToConstant: 40).isActive = true
        currentPoint.leadingAnchor.constraint(equalTo: rightView.leadingAnchor).isActive = true
        currentPoint.trailingAnchor.constraint(equalTo: rightView.trailingAnchor).isActive = true
        currentPoint.topAnchor.constraint(equalTo: rightTitleLabel.bottomAnchor, constant: 43).isActive = true
        currentPoint.text = "\(numberComma(input: allPointString))캐시"

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
        noPointLabel.textColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.key_text
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
        
        
        
    }
    
    @objc func bottomKeyboardHandler() {
        if let del = delegate {
            del.returnKeyboard()
        }
    }
    
    @objc func tapHandller(_ sender: ENTapGesture) {
        if let urlString = sender.title {
            if let del = delegate {
                del.goToContentLink(url: urlString)
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

struct ENPointContentInnerModel: Codable {
    let today_point: String
    let month_point: String
    let all_point: String
}

struct ENPointContentViewModel: Codable {
    let Result: String?
    let errcode: String?
    let errstr: String?
    let data: ENPointContentInnerModel?
}
