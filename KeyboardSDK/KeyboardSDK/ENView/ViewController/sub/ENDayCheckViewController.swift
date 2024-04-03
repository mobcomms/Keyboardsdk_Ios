//
//  ENDayCheckViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/19.
//

import Foundation
import KeyboardSDKCore

class ENDayCheckViewController: UIViewController, ENViewPrsenter {
    
    public static func create() -> ENDayCheckViewController {
        let vc = ENDayCheckViewController.init(nibName: "ENDayCheckViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var imgDay1: UIImageView!
    @IBOutlet weak var imgDay2: UIImageView!
    @IBOutlet weak var imgDay3: UIImageView!
    @IBOutlet weak var imgDay4: UIImageView!
    @IBOutlet weak var imgDay5: UIImageView!
    @IBOutlet weak var imgDay6: UIImageView!
    @IBOutlet weak var imgDay7: UIImageView!
    
    @IBOutlet weak var imgDayCheckLogo: UIImageView!
    @IBOutlet weak var lblLogoDesc: UILabel!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBOutlet weak var viewAdWrapper: UIView!
    @IBOutlet weak var imgAd: UIImageView!
    @IBOutlet weak var imgAdLogo: UIImageView!
    @IBOutlet weak var lblGoodsTitle: UILabel!
    @IBOutlet weak var lblGoodsPrice: UILabel!
    
    /// 버튼의 타입
    /// - api 호출 후 출첵이 되었는지, 광고 영상 까지 봤는지, 출첵이 안되어있는지 판단 후 값을 지정
    /// - 0: 출석하기
    /// - 1: 출석은 OK , 동영상 광고 보기
    /// - 2: 출첵도 OK , 동영상 광고도 OK , 완료 상태
    var btnType: Int = 0
    /// 광고 보기 시 주어 질 포인트
    var videoPoint: Int = 0
    /// 며칠동안 출첵을 했는지에 대한 값
    var dayCheckOn: Int = 0
    /// 7일 간의 imageView 들의 Array
    /// - API 로 증가 될 수 있기 때문에 생성함
    var imgDayArray: [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewAdWrapper.layer.borderColor = CGColor(red: 237/255, green: 239/255, blue: 243/255, alpha: 1)
        viewAdWrapper.layer.borderWidth = 7
        viewAdWrapper.layer.cornerRadius = 10
        
        let viewAdWrapperTap = UITapGestureRecognizer(target: self, action: #selector(viewAdWrapperTapHandler(_:)))
        viewAdWrapper.addGestureRecognizer(viewAdWrapperTap)
        
        btnBack.addTarget(self, action: #selector(btnBackHandler(_:)), for: .touchUpInside)
        
        dayCheckOn = 3
        dayCheckImageSetting()
        
        btnType = 0
        videoPoint = 5
        
        btnConfirm.layer.cornerRadius = 12
        btnConfirm.addTarget(self, action: #selector(btnConfirmHandler(_:)), for: .touchUpInside)
        
        btnConfirmSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// 출석 체크 Image UI 세팅
    /// - imgDayArray 에 imageView 들을 넣어준다.
    /// - dayCheckOn 은 API 에서 받아 온 후 그에 따라 이미지를 ON 으로 바꿔준다.
    func dayCheckImageSetting() {
        imgDayArray.append(imgDay1)
        imgDayArray.append(imgDay2)
        imgDayArray.append(imgDay3)
        imgDayArray.append(imgDay4)
        imgDayArray.append(imgDay5)
        imgDayArray.append(imgDay6)
        imgDayArray.append(imgDay7)
        
        if dayCheckOn > 0 {
            for i in 0..<dayCheckOn {
                imgDayArray[i].image = UIImage.init(named: "day_check_on", in: Bundle.frameworkBundle, compatibleWith: nil)
            }
        }
    }
    
    /// 출석 하기 버튼 세팅
    /// - btnType 에 따라 버튼을 바꿔준다.
    func btnConfirmSetting() {
        switch btnType {
        case 0:
            btnConfirm.setTitle("출석 하기", for: .normal)
            btnConfirm.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            
            imgDayCheckLogo.image = UIImage.init(named: "day_check_logo_off", in: Bundle.frameworkBundle, compatibleWith: nil)
            lblLogoDesc.text = "아래 출석하기 버튼을 눌러주세요."
            lblLogoDesc.textColor = UIColor(red: 109/255, green: 109/255, blue: 109/255, alpha: 1)
            
            break
        case 1:
            btnConfirm.setTitle("동영상 광고 보고 \(videoPoint)P 적립", for: .normal)
            btnConfirm.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            
            // 7일차 출석 체크인지 확인 후에 포인트 바꾸기
            imgDayCheckLogo.image = UIImage.init(named: "day_check_logo_on", in: Bundle.frameworkBundle, compatibleWith: nil)
            if dayCheckOn == 7 {
                lblLogoDesc.text = "50P 받았어요."
            } else {
                lblLogoDesc.text = "5P 받았어요."
            }
            lblLogoDesc.textColor = UIColor(red: 109/255, green: 109/255, blue: 109/255, alpha: 1)
            break
        case 2:
            btnConfirm.setTitle("내일 다시 이용해 주세요.", for: .normal)
            btnConfirm.setTitleColor(UIColor(red: 109/255, green: 109/255, blue: 109/255, alpha: 1), for: .normal)
            btnConfirm.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            
            // 포인트 계산 후 포인트 바꾸기
            imgDayCheckLogo.image = UIImage.init(named: "day_check_logo_on", in: Bundle.frameworkBundle, compatibleWith: nil)
            if dayCheckOn == 7 {
                lblLogoDesc.text = "55P 받았어요."
            } else {
                lblLogoDesc.text = "10P 받았어요."
            }
            lblLogoDesc.textColor = UIColor(red: 109/255, green: 109/255, blue: 109/255, alpha: 1)
            break
        default:
            btnConfirm.setTitle("출석 하기", for: .normal)
            btnConfirm.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            
            imgDayCheckLogo.image = UIImage.init(named: "day_check_logo_off", in: Bundle.frameworkBundle, compatibleWith: nil)

            break
        }
    }
    
    /// 출석 하기 버튼 핸들러
    /// - API 보내야함!!!!!
    @objc func btnConfirmHandler(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            // 출석 하기 api
            sender.tag = 1
            
            btnConfirm.setTitle("동영상 광고 보고 \(videoPoint)P 적립", for: .normal)
            btnConfirm.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
            
            // 7일차 출석 체크인지 확인 후에 포인트 바꾸기
            UIView.transition(with: imgDayCheckLogo, duration: 0.3, options: .transitionFlipFromBottom , animations: { [weak self] in
                guard let self else { return }
                self.imgDayCheckLogo.image = UIImage.init(named: "day_check_logo_on", in: Bundle.frameworkBundle, compatibleWith: nil)
            })
            
            if dayCheckOn == 7 {
                lblLogoDesc.text = "50P 받았어요."
            } else {
                lblLogoDesc.text = "5P 받았어요."
            }
            lblLogoDesc.textColor = UIColor(red: 109/255, green: 109/255, blue: 109/255, alpha: 1)
            break
        case 1:
            // 동영상 보는 로직
            sender.tag = 2
            
            btnConfirm.setTitle("내일 다시 이용해 주세요.", for: .normal)
            btnConfirm.setTitleColor(UIColor(red: 109/255, green: 109/255, blue: 109/255, alpha: 1), for: .normal)
            btnConfirm.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
            
            // 포인트 계산 후 포인트 바꾸기
            if dayCheckOn == 7 {
                lblLogoDesc.text = "55P 받았어요."
            } else {
                lblLogoDesc.text = "10P 받았어요."
            }
            lblLogoDesc.textColor = UIColor(red: 109/255, green: 109/255, blue: 109/255, alpha: 1)
            break
        case 2:
            // 이미 다 사용 함
            showErrorMessage(message: "이미 완료하셨습니다.")
            break
        default:
            break
        }
    }
    
    @objc func viewAdWrapperTapHandler(_ sender: UITapGestureRecognizer) {
        
    }
    
    @objc func btnBackHandler(_ sender: UIButton) {
        enDismiss()
    }
}
