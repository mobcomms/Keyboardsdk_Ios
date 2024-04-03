//
//  ENTypingViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/19.
//

import Foundation
import KeyboardSDKCore

class ENTypingViewController: UIViewController, ENViewPrsenter {
    public static func create() -> ENTypingViewController {
        let vc = ENTypingViewController.init(nibName: "ENTypingViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblTypingCount: UILabel!
    
    @IBOutlet weak var imgTyping1: UIImageView!
    @IBOutlet weak var lblTyping1: UILabel!
    
    @IBOutlet weak var imgTyping2: UIImageView!
    @IBOutlet weak var lblTyping2: UILabel!
    
    @IBOutlet weak var imgTyping3: UIImageView!
    @IBOutlet weak var lblTyping3: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBOutlet weak var viewAdWrapper: UIView!
    @IBOutlet weak var imgAd: UIImageView!
    @IBOutlet weak var imgAdLogo: UIImageView!
    @IBOutlet weak var lblGoodsTitle: UILabel!
    @IBOutlet weak var lblGoodsPrice: UILabel!
    
    /// 타이핑 조건 1
    var typingCondition1: Int = 1000
    /// 타이핑 조건 2
    var typingCondition2: Int = 2000
    /// 타이핑 조건 3
    var typingCondition3: Int = 3000
    
    /// 유저 타이핑 수 를 저장할 변수
    var userTypingCount: Int = 0
    /// 타이핑 조건 1 의 남은 타이핑 수
    /// - 음수이면 조건 달성
    /// - 양수이면 remainderCondition1 만큼 남음
    var remainderCondition1: Int = 0
    /// 타이핑 조건 2 의 남은 타이핑 수
    /// - 음수이면 조건 달성
    /// - 양수이면 remainderCondition2 만큼 남음
    var remainderCondition2: Int = 0
    /// 타이핑 조건 3 의 남은 타이핑 수
    /// - 음수이면 조건 달성
    /// - 양수이면 remainderCondition3 만큼 남음
    var remainderCondition3: Int = 0
    
    /// 타이핑 포인트 를 받았는지 유무 / 첫번째 조건
    var receivePointCondition1: Bool = false
    /// 타이핑 포인트 를 받았는지 유무 / 두번째 조건
    var receivePointCondition2: Bool = false
    /// 타이핑 포인트 를 받았는지 유무 / 세번째 조건
    var receivePointCondition3: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 나중에 api 로 타이핑 개수가 3개가 이상일 때 사용하면 될듯
//        let innerView = InnerView(frame: .zero)
//        self.view.addSubview(innerView)
//        stackView.addArrangedSubview(innerView)
//        innerView.setConstraint()
        
        viewAdWrapper.layer.borderColor = CGColor(red: 237/255, green: 239/255, blue: 243/255, alpha: 1)
        viewAdWrapper.layer.borderWidth = 7
        viewAdWrapper.layer.cornerRadius = 10
        
        let viewAdWrapperTap = UITapGestureRecognizer(target: self, action: #selector(viewAdWrapperTapHandler(_:)))
        viewAdWrapper.addGestureRecognizer(viewAdWrapperTap)
        
        // 백버튼 핸들러 연결
        btnBack.addTarget(self, action: #selector(btnBackHandler(_:)), for: .touchUpInside)
        // 유저 타이핑 수 가져오기
        userTypingCount = ENSettingManager.shared.pressKeyboardCount
        // 유저 타이핑 수 표시하기
        lblTypingCount.text = "\(numberComma(num: userTypingCount))"
        
        calculateTypingCount()
        
        typingOnOffSetting()
        
        btnConfirm.layer.cornerRadius = 12
        
        settingBtnConfirm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// 포인트 지급 버튼의 세팅
    /// - receivePointCondition1, receivePointCondition2, receivePointCondition3 의 값으로 1차 판단
    /// - remainderCondition1, remainderCondition2, remainderCondition3 의 값으로 2차 판단
    func settingBtnConfirm() {
        if receivePointCondition1 && receivePointCondition2 && receivePointCondition3 {
            // 다 받음
            btnConfirm.setTitle("내일 다시 이용해 주세요.", for: .normal)
            btnConfirm.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            btnConfirm.setTitleColor(UIColor(red: 109/255, green: 109/255, blue: 109/255, alpha: 1), for: .normal)
        } else if receivePointCondition1 && receivePointCondition2 {
            // 1번, 2번 받음
            if remainderCondition3 < 0 {
                btnConfirm.setTitle("\(numberComma(num: typingCondition3)) 타이핑 달성 5P 받기", for: .normal)
                btnConfirm.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
                btnConfirm.setTitleColor(.white, for: .normal)
            } else {
                btnConfirm.setTitle("\(numberComma(num: remainderCondition3)) 타이핑 후에 5P 받을 수 있어요.", for: .normal)
                btnConfirm.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
                btnConfirm.setTitleColor(.white, for: .normal)
                btnConfirm.isEnabled = false
            }
        } else if receivePointCondition1 {
            // 1번 받음
            if remainderCondition3 < 0 {
                // 여기가 음수 이면 3천번을 넘었다는 얘기
                btnConfirm.setTitle("\(numberComma(num: typingCondition3)) 타이핑 달성 10P 받기", for: .normal)
                btnConfirm.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
                btnConfirm.setTitleColor(.white, for: .normal)
            } else if remainderCondition2 < 0 {
                // 여기가 음수 이면 2천번을 넘었다는 얘기
                btnConfirm.setTitle("\(numberComma(num: typingCondition2)) 타이핑 달성 5P 받기", for: .normal)
                btnConfirm.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
                btnConfirm.setTitleColor(.white, for: .normal)
            } else {
                // 여기로 오면 2천 까지 타이핑 수가 모자르다는 얘기
                btnConfirm.setTitle("\(numberComma(num: remainderCondition2)) 타이핑 후에 5P 받을 수 있어요.", for: .normal)
                btnConfirm.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
                btnConfirm.setTitleColor(.white, for: .normal)
                btnConfirm.isEnabled = false
            }
        } else {
            // 다 안받음
            if remainderCondition3 < 0 {
                // 여기가 음수 이면 3천번을 넘었다는 얘기
                btnConfirm.setTitle("\(numberComma(num: typingCondition3)) 타이핑 달성 15P 받기", for: .normal)
                btnConfirm.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
                btnConfirm.setTitleColor(.white, for: .normal)
            } else if remainderCondition2 < 0 {
                // 여기가 음수 이면 2천번을 넘었다는 얘기
                btnConfirm.setTitle("\(numberComma(num: typingCondition2)) 타이핑 달성 10P 받기", for: .normal)
                btnConfirm.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
                btnConfirm.setTitleColor(.white, for: .normal)
            } else if remainderCondition1 < 0 {
                // 여기가 음수 이면 1천번을 넘었다는 얘기
                btnConfirm.setTitle("\(numberComma(num: typingCondition1)) 타이핑 달성 5P 받기", for: .normal)
                btnConfirm.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
                btnConfirm.setTitleColor(.white, for: .normal)
            } else {
                // 여기로 오면 1천 까지 타이핑 수가 모자르다는 얘기
                btnConfirm.setTitle("\(numberComma(num: remainderCondition1)) 타이핑 후에 5P 받을 수 있어요.", for: .normal)
                btnConfirm.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
                btnConfirm.setTitleColor(.white, for: .normal)
                btnConfirm.isEnabled = false
            }
        }
    }
    
    /// 조건에 따라 타이핑 수가 얼마나 남았는지 계산
    func calculateTypingCount() {
        // 몇 번 남았는지 계산
        remainderCondition1 = typingCondition1 - userTypingCount
        remainderCondition2 = typingCondition2 - userTypingCount
        remainderCondition3 = typingCondition3 - userTypingCount
    }
    
    /// 조건 달성 유무 표시
    func typingOnOffSetting() {
        if remainderCondition1 < 0 {
            typingOnUI(targetImg: imgTyping1, targetLabel: lblTyping1)
        } else {
            typingOffUI(targetImg: imgTyping1, targetLabel: lblTyping1, remainderCount: remainderCondition1)
        }
        
        if remainderCondition2 < 0 {
            typingOnUI(targetImg: imgTyping2, targetLabel: lblTyping2)
        } else {
            typingOffUI(targetImg: imgTyping2, targetLabel: lblTyping2, remainderCount: remainderCondition2)
        }
        
        if remainderCondition3 < 0 {
            typingOnUI(targetImg: imgTyping3, targetLabel: lblTyping3)
        } else {
            typingOffUI(targetImg: imgTyping3, targetLabel: lblTyping3, remainderCount: remainderCondition3)
        }
    }
    
    /// 조건 미달성 UI 로 변경
    func typingOffUI(targetImg: UIImageView, targetLabel: UILabel, remainderCount: Int) {
        targetImg.image = UIImage.init(named: "typing_off", in: Bundle.frameworkBundle, compatibleWith: nil)
        targetLabel.text = "\(numberComma(num: remainderCount)) 남음"
        targetLabel.textColor = UIColor(red: 141/255, green: 141/255, blue: 141/255, alpha: 1)
    }
    
    /// 조건 달성 UI 로 변경
    /// - Parameters:
    ///    - targetImg: - 타겟이 되는 imageView
    ///    - targetLabel: - 타겟이 되는 label
    func typingOnUI(targetImg: UIImageView, targetLabel: UILabel) {
        targetImg.image = UIImage.init(named: "typing_on", in: Bundle.frameworkBundle, compatibleWith: nil)
        targetLabel.text = "조건 달성"
        targetLabel.textColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
    }
    
    @objc func viewAdWrapperTapHandler(_ sender: UITapGestureRecognizer) {
        
    }
    
    @objc func btnBackHandler(_ sender: UIButton) {
        enDismiss()
    }
    
    func numberComma(num: Int) -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let result: String = numberFormatter.string(for: num)!
        return result
    }
    
    /// 타이핑 메인에 들어가는 Inner View
    /// - 타이핑 메인 Stack View 에 들어가는 InnerView
    /// - 나중에 API 로 조건들이 여러개가 증가 또는 감소 할 수 있기 때문에 생성해 놓음.
    /// - API 에 맞춰서 아래 View 를 생성 후 Stack View 에 넣으면 된다.
    class InnerView: UIView {
        lazy var imgTyping: UIImageView = {
            let img: UIImageView = UIImageView()
            img.image = UIImage.init(named: "typing_off", in: Bundle.frameworkBundle, compatibleWith: nil)
            return img
        }()
        lazy var lblCondition: UILabel = {
            let lbl: UILabel = UILabel()
            lbl.text = "4,000"
            lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            lbl.textColor = .black
            lbl.textAlignment = .center
            return lbl
        }()
        lazy var lblDesc: UILabel = {
            let lbl: UILabel = UILabel()
            lbl.text = "타이핑"
            lbl.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
            lbl.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
            lbl.textAlignment = .center
            return lbl
        }()
        lazy var lblTyping: UILabel = {
            let lbl: UILabel = UILabel()
            lbl.text = "남음!"
            lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            lbl.textColor = UIColor(red: 141/255, green: 141/255, blue: 141/255, alpha: 1)
            lbl.textAlignment = .center
            return lbl
        }()
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            initView()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            initView()
        }
        
        func initView() {
            self.addSubview(imgTyping)
            self.addSubview(lblCondition)
            self.addSubview(lblDesc)
            self.addSubview(lblTyping)
        }
        
        func setConstraint() {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.widthAnchor.constraint(equalToConstant: 80).isActive = true
            self.heightAnchor.constraint(equalToConstant: 145).isActive = true
            
            imgTyping.translatesAutoresizingMaskIntoConstraints = false
            imgTyping.widthAnchor.constraint(equalToConstant: 80).isActive = true
            imgTyping.heightAnchor.constraint(equalToConstant: 80).isActive = true
            imgTyping.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            imgTyping.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            imgTyping.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            
            lblCondition.translatesAutoresizingMaskIntoConstraints = false
            lblCondition.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            lblCondition.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            lblCondition.topAnchor.constraint(equalTo: imgTyping.bottomAnchor, constant: 0).isActive = true
            
            lblDesc.translatesAutoresizingMaskIntoConstraints = false
            lblDesc.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            lblDesc.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            lblDesc.topAnchor.constraint(equalTo: lblCondition.bottomAnchor, constant: 0).isActive = true
            
            lblTyping.translatesAutoresizingMaskIntoConstraints = false
            lblTyping.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            lblTyping.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            lblTyping.topAnchor.constraint(equalTo: lblDesc.bottomAnchor, constant: 0).isActive = true
        }
    }
    
}
