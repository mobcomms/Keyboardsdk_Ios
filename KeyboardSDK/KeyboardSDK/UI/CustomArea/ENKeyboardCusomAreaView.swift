//
//  ENKeyboardCusomAreaView.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/08.
//

import Foundation
import KeyboardSDKCore

public protocol ENKeyboardCustomAreaViewDelegate: AnyObject {
    /// 메인 페이지 열기
    func enKeyboardCusomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, openMainPage completion: (() -> Void)?)
    /// 이모지 화면으로 전환
    func enKeyboardCusomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, showEmojiView completion: (() -> Void)?)
    /// 외부 브라우저로 링크 이동
    func enKeyboardCusomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, showCoupangView completion: (() -> Void)?)
    /// 클립보드 화면으로 전환
    func enKeyboardCusomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, showCliplboard completion: (() -> Void)?)
    /// 자주쓰는 메모 화면으로 이동
    func enKeyboardCusomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, showUserMemo completion: (() -> Void)?)
    /// 더치페이 뷰로 전환
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, showDutchPay completion: (() -> Void)?)
    /// 핫이슈 뉴스 화면으로 전환
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, showHotIssue completion: (() -> Void)?)
    /// 더치페이 뷰 가리기
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, dutchPayHide completion: (() -> Void)?)
    /// 인원 수에 포커스
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, focusPerson completion: (() -> Void)?)
    /// 가격에 포커스
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, focusPrice completion: (() -> Void)?)
    /// 붙여넣기 할때 사용
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, text: String, pasteText completion: (() -> Void)?)
    /// 커서 이동 좌 / 우
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, cursorStyle: String, cursorMove: (() -> Void)?)
    
    /// 하나머니 앱으로 이동
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, hanaApp completion: (() -> Void)?)
    /// 하나머니 피피존 이동
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, hanaPPZone completion: (() -> Void)?)
    /// 하나머니 쿠팡 이동
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, hanaCoupang completion: (() -> Void)?)
    /// 하나머니 적립리스트
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, hanaPointList completion: (() -> Void)?)
    /// 하나머니 설정
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, hanaSetting completion: (() -> Void)?)
}
/// 커스텀 영역
///  - 키보드 위 툴바 부분을 세팅함.
///  - 여기에 사용 되는 기본적인 뷰는 wrapper 인 UIView
///  - 그 안에 기본적으로 사용되는 툴바인 ScrollView
///  - 광고나, 더치페이, 붙여넣기 뷰는 Constraint 로 보여줬다 가렸다가 함.
public class ENKeyboardCustomAreaView: UIView {
    // MARK: - 붙여넣기 뷰 !!!!!!!!!!
    lazy var viewPaste: UIView = {
        let views: UIView = UIView()
        views.backgroundColor = UIColor(red: 228/255, green: 231/255, blue: 236/255, alpha: 1)
        return views
    }()
    lazy var imgPasteTitle: UIImageView = {
        let img: UIImageView = UIImageView()
        img.image = UIImage.init(named: "cell_toolbar_clipboard", in: Bundle.frameworkBundle, compatibleWith: nil)
        
        return img
    }()
    
    lazy var lblPasteTitle: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var btnPaste: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        btn.setTitle("붙여넣기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        
        btn.backgroundColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1)
        
        return btn
    }()
    
    lazy var btnPasteClose: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        btn.setTitle("", for: .normal)
        btn.backgroundColor = .clear
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(UIImage.init(named: "custom_view_ad_close", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
        return btn
    }()
    // MARK: - 붙여넣기 관련 뷰 끝
    
    // MARK: - 더치 페이 관련 뷰!!!!!!!!!!!!
    public lazy var dutchPayView: UIView = {
        let views: UIView = UIView()
        views.backgroundColor = .white
        return views
    }()
    
    public lazy var lblDutchPayTop: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15.0)
        lbl.textColor = UIColor(red: 114/255, green: 131/255, blue: 169/255, alpha: 1)
        lbl.text = "빈칸을 입력 해주세요."
        return lbl
    }()
    
    public lazy var btnPersonNumber: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setTitle("몇 명이서", for: .normal)
        button.setTitleColor(UIColor(red: 141/255, green: 141/255, blue: 141/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(red: 241/255, green: 244/255, blue: 245/255, alpha: 1)
        button.layer.cornerRadius = 5
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            button.configuration = configuration
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        return button
    }()
    
    public lazy var btnCalculatePay: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setTitle("얼마를 나누시나요?", for: .normal)
        button.setTitleColor(UIColor(red: 141/255, green: 141/255, blue: 141/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(red: 241/255, green: 244/255, blue: 245/255, alpha: 1)
        button.layer.cornerRadius = 5
        
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            button.configuration = configuration
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        return button
    }()
    
    public lazy var btnDutchPayClose: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.adjustsImageWhenHighlighted = false
        button.setImage(UIImage.init(named: "dutch_pay_close", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
        return button
    }()
    // MARK: - 더치페이 관련 뷰 끝
    
    // MARK: - 광고 관련 뷰!!!!!!!!!!!
    public lazy var viewAd: UIView = {
        let views: UIView = UIView()
        views.backgroundColor = UIColor(red: 228/255, green: 231/255, blue: 236/255, alpha: 1)
        return views
    }()
    
    public lazy var buttonAdClose: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.adjustsImageWhenHighlighted = false
        button.setImage(UIImage.init(named: "custom_view_ad_close", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
        return button
    }()
    
    public lazy var imgAdTitle: UIImageView = {
        let img: UIImageView = UIImageView(image: UIImage.init(named: "ad_news_title", in: Bundle.frameworkBundle, compatibleWith: nil))
        return img
    }()
    
    public lazy var lblNewsTitle: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    public lazy var lblPoint: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor(red: 248/255, green: 216/255, blue: 73/255, alpha: 1)
        lbl.layer.borderColor = UIColor(red: 205/255, green: 130/255, blue: 0/255, alpha: 1).cgColor
        lbl.layer.borderWidth = 2
        lbl.layer.cornerRadius = 32 / 2
        lbl.clipsToBounds = true
        
        return lbl
    }()
    // MARK: - 광고 관련 뷰 끝
    
    // MARK: - 툴바 관련 뷰 !!!!!!!!!!
    public lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.isPagingEnabled = true
        
        return scrollView;
    }()
    
    public lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0

        return stack
    }()
    // MARK: - 툴바 관련 뷰 끝
    
    /// 키보드 테마 사용을 위한 객체
    public var keyboardTheme: ENKeyboardTheme? = nil {
        didSet {
            updateUI()
        }
    }
    /// 키보드 테마 사용을 위한 모델 객체
    public var keyboardThemeModel: ENKeyboardThemeModel? = nil {
        didSet {
            updateUI()
        }
    }
    
    /// 버튼 객채들을 담을 Array
    var btnArray:[UIButton] = []
    
    var toolbarButtonWidthConstraint: [NSLayoutConstraint] = []
    
    /// 딜리게이트
    weak var delegate: ENKeyboardCustomAreaViewDelegate? = nil
    
    /// 광고를 보여주기 위한 타이머
    var timer: Timer?
    /// 광고를 노출하기 위한 인터벌 값
    let timeInterval: CGFloat = 10.0
    
    /// 광고 뷰의 Top Constraint
    var adViewTopConstraint: NSLayoutConstraint!
    /// 광고가 보여졌는지에 대한 Flag
    var isShowAd: Bool = false
    
    /// 더치페이 툴바의 Top Constraint
    var dutchPayTopConstraint: NSLayoutConstraint!
    
    /// 붙여넣기 툴바의 Top Constraint
    var pasteTopConstraint: NSLayoutConstraint!
    /// 붙여넣기의 기능을 사용할지에 대한 Flag
    var isPaste: Bool = false
    
    func ENKeyboardCustomAreaView() {
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initLayout()
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLayout()
    }
    
    /// 툴바 영역의 기본 세팅 함수
    func initLayout() {
        // 스타일 가져오기
        let toolbarStyle = ENSettingManager.shared.toolbarStyle
        // 툴바 아이템 가져오기
        let toolbarItems = ENSettingManager.shared.toolbarItems
        
        // 스타일에 따라 버튼 세팅하기
        if toolbarStyle == .paging {
            pagingButtonSetting(toolbarItems: toolbarItems)
            scrollView.isPagingEnabled = true
        } else if toolbarStyle == .scroll {
            scrollButtonSetting(toolbarItems: toolbarItems)
            scrollView.isPagingEnabled = false
        } else {
            pagingButtonSetting(toolbarItems: toolbarItems)
            scrollView.isPagingEnabled = true
        }
        
        // 버튼의 핸들러 연결
        setButtonHandler(item: btnArray)
        //버튼의 Width 값 세팅
        buttonWidthSetting(item: btnArray)
        // 스크롤 뷰 세팅
        setScrollViewSetting(item: btnArray)
        
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        // 뉴스나 광고를 사용하면 광고 뷰를 보여주게 함.
        if ENSettingManager.shared.useNewsAd || ENSettingManager.shared.useAd {
            settingAdView()
            startTimerForAd()
        }
        
        // 더치 페이 툴바 뷰 세팅
        settingDutchPayView()
        
        // UI 업데이트
        updateUI()
    
    }
    
    /// 더치 페이 툴바 뷰 삭제
    func removeAdViewAndDutchPayView() {
        for innerView in self.subviews {
            if innerView == viewAd {
                innerView.removeConstraints(innerView.constraints)
                innerView.removeFromSuperview()
            }
            
            if innerView == dutchPayView {
                innerView.removeConstraints(innerView.constraints)
                innerView.removeFromSuperview()
            }
        }
    }
    
    /// 툴바 버튼 생성
    func createButton(title: String, senderTag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .clear
        button.adjustsImageWhenHighlighted = false
        
        button.tag = senderTag
        
        return button
    }
    /// 툴바 버튼 중 비어있는 버튼을 생성
    func createEmptyView() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        button.adjustsImageWhenHighlighted = false
        
        button.tag = 999
        
        let img = UIImage.init(named: "cell_toolbar_empty", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width / 7).isActive = true
        button.heightAnchor.constraint(equalToConstant: 58).isActive = true
                
        button.setImage(img, for: .normal)
        
        return button
    }
    
    /// 더치 페이 툴바 뷰 UI 세팅
    func settingDutchPayView() {
        self.addSubview(dutchPayView)
        
        dutchPayView.translatesAutoresizingMaskIntoConstraints = false
        
        dutchPayView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        dutchPayView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        dutchPayTopConstraint = dutchPayView.bottomAnchor.constraint(equalTo: self.topAnchor)
        dutchPayTopConstraint.isActive = true
        dutchPayView.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
        
        dutchPayView.addSubview(btnDutchPayClose)
        
        btnDutchPayClose.translatesAutoresizingMaskIntoConstraints = false
        
        btnDutchPayClose.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        btnDutchPayClose.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        btnDutchPayClose.trailingAnchor.constraint(equalTo: dutchPayView.trailingAnchor, constant: -16).isActive = true
        btnDutchPayClose.centerYAnchor.constraint(equalTo: dutchPayView.centerYAnchor).isActive = true
        
        // add target for btnDutchPayClose
        btnDutchPayClose.addTarget(self, action: #selector(hideDutchPayToolbar(_:)), for: .touchUpInside)
        
        dutchPayView.addSubview(lblDutchPayTop)
        
        lblDutchPayTop.translatesAutoresizingMaskIntoConstraints = false
    
        lblDutchPayTop.leadingAnchor.constraint(equalTo: dutchPayView.leadingAnchor, constant: 16).isActive = true
        lblDutchPayTop.trailingAnchor.constraint(equalTo: dutchPayView.trailingAnchor).isActive = true
        lblDutchPayTop.topAnchor.constraint(equalTo: dutchPayView.topAnchor, constant: 12).isActive = true
        lblDutchPayTop.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        dutchPayView.addSubview(btnPersonNumber)
        
        btnPersonNumber.translatesAutoresizingMaskIntoConstraints = false
        
        btnPersonNumber.leadingAnchor.constraint(equalTo: dutchPayView.leadingAnchor, constant: 16).isActive = true
        btnPersonNumber.topAnchor.constraint(equalTo: lblDutchPayTop.bottomAnchor, constant: 6).isActive = true
        btnPersonNumber.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        btnPersonNumber.addTarget(self, action: #selector(btnPersonNumberHandler(_:)), for: .touchUpInside)
        // add target for btnPersonNumber
        
        dutchPayView.addSubview(btnCalculatePay)
        
        btnCalculatePay.translatesAutoresizingMaskIntoConstraints = false
        
        btnCalculatePay.leadingAnchor.constraint(equalTo: btnPersonNumber.trailingAnchor, constant: 7).isActive = true
        btnCalculatePay.topAnchor.constraint(equalTo: lblDutchPayTop.bottomAnchor, constant: 6).isActive = true
        btnCalculatePay.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        btnCalculatePay.addTarget(self, action: #selector(btnCalculatePayHandler(_:)), for: .touchUpInside)
        
        btnPersonNumber.layer.borderColor = CGColor(red: 2/255, green: 139/255, blue: 252/255, alpha: 1)
        btnPersonNumber.layer.borderWidth = 1
        
        btnCalculatePay.layer.borderWidth = 0
        
        dutchPayView.isHidden = true
    }
    
    /// 광고 뷰 UI 세팅
    func settingAdView() {
        self.addSubview(viewAd)
        
        viewAd.translatesAutoresizingMaskIntoConstraints = false
        
        viewAd.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        viewAd.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        adViewTopConstraint = viewAd.bottomAnchor.constraint(equalTo: self.topAnchor)
        adViewTopConstraint.isActive = true
        viewAd.heightAnchor.constraint(equalToConstant: ENSettingManager.shared.getKeyboardCustomHeight(isLandcape: false)).isActive = true
        
        viewAd.addSubview(buttonAdClose)

        buttonAdClose.translatesAutoresizingMaskIntoConstraints = false
        
        buttonAdClose.widthAnchor.constraint(equalToConstant: 20).isActive = true
        buttonAdClose.heightAnchor.constraint(equalToConstant: 20).isActive = true
        buttonAdClose.trailingAnchor.constraint(equalTo: viewAd.trailingAnchor, constant: -15).isActive = true
        buttonAdClose.centerYAnchor.constraint(equalTo: viewAd.centerYAnchor).isActive = true
        
        buttonAdClose.addTarget(self, action: #selector(buttonAdCloseHandler(_:)), for: .touchUpInside)
        
        viewAd.addSubview(imgAdTitle)
        
        imgAdTitle.translatesAutoresizingMaskIntoConstraints = false
        
        imgAdTitle.leadingAnchor.constraint(equalTo: viewAd.leadingAnchor, constant: 16).isActive = true
        imgAdTitle.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        imgAdTitle.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        imgAdTitle.centerYAnchor.constraint(equalTo: viewAd.centerYAnchor).isActive = true
        
        viewAd.addSubview(lblPoint)
        
        lblPoint.translatesAutoresizingMaskIntoConstraints = false
        
        lblPoint.widthAnchor.constraint(equalToConstant: 32).isActive = true
        lblPoint.heightAnchor.constraint(equalToConstant: 32).isActive = true
        lblPoint.trailingAnchor.constraint(equalTo: buttonAdClose.leadingAnchor, constant: -11).isActive = true
        lblPoint.centerYAnchor.constraint(equalTo: viewAd.centerYAnchor).isActive = true
        
        lblPoint.text = "1P"
        
        viewAd.addSubview(lblNewsTitle)
        
        lblNewsTitle.translatesAutoresizingMaskIntoConstraints = false
        
        lblNewsTitle.leadingAnchor.constraint(equalTo: imgAdTitle.trailingAnchor, constant: 8).isActive = true
        lblNewsTitle.trailingAnchor.constraint(equalTo: lblPoint.leadingAnchor, constant: -11).isActive = true
        lblNewsTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lblNewsTitle.centerYAnchor.constraint(equalTo: viewAd.centerYAnchor).isActive = true
        
        lblNewsTitle.text = "뉴스 및 광고가 노출됩니다."
        
    }
    /// 붙여넣기 툴바 뷰 UI 세팅
    func settingPasteView() {
        self.addSubview(viewPaste)
        
        viewPaste.translatesAutoresizingMaskIntoConstraints = false
        viewPaste.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        viewPaste.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        pasteTopConstraint = viewPaste.bottomAnchor.constraint(equalTo: self.topAnchor)
        pasteTopConstraint.isActive = true
        viewPaste.heightAnchor.constraint(equalToConstant: ENSettingManager.shared.getKeyboardCustomHeight(isLandcape: false)).isActive = true
        
        viewPaste.addSubview(imgPasteTitle)
        
        imgPasteTitle.translatesAutoresizingMaskIntoConstraints = false
        
        imgPasteTitle.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imgPasteTitle.topAnchor.constraint(equalTo: viewPaste.topAnchor, constant: 13).isActive = true
        imgPasteTitle.bottomAnchor.constraint(equalTo: viewPaste.bottomAnchor, constant:  -13).isActive = true
        imgPasteTitle.leadingAnchor.constraint(equalTo: viewPaste.leadingAnchor, constant: 16).isActive = true
        
        viewPaste.addSubview(lblPasteTitle)
        
        lblPasteTitle.translatesAutoresizingMaskIntoConstraints = false
        
        lblPasteTitle.leadingAnchor.constraint(equalTo: imgPasteTitle.trailingAnchor, constant: 8).isActive = true
        lblPasteTitle.topAnchor.constraint(equalTo: viewPaste.topAnchor, constant: 15).isActive = true
        lblPasteTitle.bottomAnchor.constraint(equalTo: viewPaste.bottomAnchor, constant: -15).isActive = true
        lblPasteTitle.trailingAnchor.constraint(equalTo: viewPaste.trailingAnchor, constant: -112).isActive = true
        
        viewPaste.addSubview(btnPaste)
        
        btnPaste.translatesAutoresizingMaskIntoConstraints = false
        
        btnPaste.widthAnchor.constraint(equalToConstant: 54).isActive = true
        btnPaste.topAnchor.constraint(equalTo: viewPaste.topAnchor, constant: 12.5).isActive = true
        btnPaste.bottomAnchor.constraint(equalTo: viewPaste.bottomAnchor, constant:  -12.5).isActive = true
        
        btnPaste.addTarget(self, action: #selector(btnPasteHandler(_:)), for: .touchUpInside)
        
        btnPaste.layer.cornerRadius = 12
        
        viewPaste.addSubview(btnPasteClose)
        
        btnPasteClose.translatesAutoresizingMaskIntoConstraints = false
        
        btnPasteClose.leadingAnchor.constraint(equalTo: btnPaste.trailingAnchor, constant: 11).isActive = true
        btnPasteClose.trailingAnchor.constraint(equalTo: viewPaste.trailingAnchor, constant: -16).isActive = true
        btnPasteClose.topAnchor.constraint(equalTo: viewPaste.topAnchor, constant: 15).isActive = true
        btnPasteClose.bottomAnchor.constraint(equalTo: viewPaste.bottomAnchor, constant: -15).isActive = true
        
        btnPasteClose.addTarget(self, action: #selector(btnPasteCloseHandler(_:)), for: .touchUpInside)
    }
    /// 붙여 넣기 핸들러
    @objc func btnPasteHandler(_ sender: UIButton) {
        if let pasteText = lblPasteTitle.text {
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, text: pasteText, pasteText: nil)
        }
    }
    /// 붙여 넣기 툴바 뷰 닫기 핸들러
    @objc func btnPasteCloseHandler(_ sender: UIButton) {
        hidePaste()
    }
    /// 붙여넣기 뷰를 보여준다.
    func showPaste(pasteText: String) {
        self.bringSubviewToFront(viewPaste)
        lblPasteTitle.text = pasteText
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            self.pasteTopConstraint.constant = 50.0
            self.layoutIfNeeded()
        }
    }
    /// 붙여넣기 뷰를 Hide 한다.
    func hidePaste() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            self.pasteTopConstraint.constant = -50.0
            self.layoutIfNeeded()
        }
    }
    
    /// 툴바 스타일 페이징에 맞는 툴바 버튼 세팅
    func pagingButtonSetting(toolbarItems: [ENToolbarItem]) {
        // 툴바 Array 에서 사용 중인 버튼 들만 stack view 에 추가
        for item in toolbarItems {
            if item.toolType == .clipboard {
                if item.isUse {
                    isPaste = true
                } else {
                    isPaste = false
                }
            }
            
            if item.isUse {
                let button = createButton(title: "", senderTag: item.toolType.rawValue)
                btnArray.append(button)
                stackView.addArrangedSubview(button)
            }
        }
        
        // 페이징은 뒤에 남은 버튼들을 빈 공간을 만들어야 함
        // 해당 부분은 남은 부분들을 빈 공간으로 채워주는 로직
        let remainder = btnArray.count % 7
        if remainder != 0 {
            let result = 7 - remainder
            for _ in 0...(result - 1) {
                let emptyView = createEmptyView()
                btnArray.append(emptyView)
                stackView.addArrangedSubview(emptyView)
            }
        }
    }
    
    /// 툴바 스타일 스크롤에 맞는 툴바 버튼 세팅
    func scrollButtonSetting(toolbarItems: [ENToolbarItem]) {
        for item in toolbarItems {
            if item.toolType == .clipboard {
                if item.isUse {
                    isPaste = true
                } else {
                    isPaste = false
                }
            }
            
            if item.isUse {
                // 하나머니 전용
                if item.toolbarType == "34" {
                    if ENSettingManager.shared.toolbarBrandUrl != "" {
                        let button = createButton(title: "", senderTag: item.toolType.rawValue)
                        btnArray.append(button)
                        stackView.addArrangedSubview(button)
                    }
                } else {
                    let button = createButton(title: "", senderTag: item.toolType.rawValue)
                    btnArray.append(button)
                    stackView.addArrangedSubview(button)
                }
            }
        }
    }
    /// 테마 폴더 가져오기
    func themeFolder(name:String, type: ENKeyboardThemeType) -> URL {
        var url = ENKeyboardSDKCore.shared.groupDirectoryURL
        
        if let _ = url {
            url!.appendPathComponent("theme")
            url!.appendPathComponent(name)
            
            return url!
        }
        else {
            return URL.init(string: "")!
        }
    }
    /// 광고 팝업 가리기 버튼 핸들러
    @objc func buttonAdCloseHandler(_ sender: UIButton) {
        hideAdView()
        startTimerForAd()
    }
    /// 툴바 버튼 바깥 영역 터치 핸들러
    @objc func buttonTouchUpOutSide(_ sender: UIButton) {
//        sender.backgroundColor = keyboardTheme?.themeColors.tab_off ?? .clear
        sender.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
    }
    /// 툴바 터치 다운 핸들러
    @objc func buttonTouchDown(_ sender: UIButton) {
//        sender.backgroundColor = keyboardTheme?.themeColors.tab_on ?? .clear
        sender.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
    }
    /// 툴바 터치 업 핸들러
    @objc func buttonTouchUpInSide(_ sender: UIButton) {
//        sender.backgroundColor = keyboardTheme?.themeColors.tab_off ?? .clear
        sender.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
        
        switch sender.tag {
        case ENToolbarType.mobicomz.rawValue:
//            delegate?.enKeyboardCusomAreaView(self, targetButton: sender, openSettingView: nil)
            break
        case ENToolbarType.emoji.rawValue:
            delegate?.enKeyboardCusomAreaView(self, targetButton: sender, showEmojiView: nil)
            break
        case ENToolbarType.emoticon.rawValue:
            break
        case ENToolbarType.userMemo.rawValue:
            delegate?.enKeyboardCusomAreaView(self, targetButton: sender, showUserMemo: nil)
            break
        case ENToolbarType.clipboard.rawValue:
            delegate?.enKeyboardCusomAreaView(self, targetButton: sender, showCliplboard: nil)
            break
        case ENToolbarType.coupang.rawValue:
            delegate?.enKeyboardCusomAreaView(self, targetButton: sender, showCoupangView: nil)
            break
        case ENToolbarType.offerwall.rawValue:
            break
        case ENToolbarType.dutchPay.rawValue:
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, showDutchPay: nil)
            break
        case ENToolbarType.hotIssue.rawValue:
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, showHotIssue: nil)
            break
        case ENToolbarType.cursorLeft.rawValue:
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, cursorStyle: "L", cursorMove: nil)
            break
        case ENToolbarType.cursorRight.rawValue:
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, cursorStyle: "R", cursorMove: nil)
            break
        case ENToolbarType.setting.rawValue:
            delegate?.enKeyboardCusomAreaView(self, targetButton: sender, openMainPage: nil)
            break
            
            
        case ENToolbarType.hanaEmoji.rawValue:
            delegate?.enKeyboardCusomAreaView(self, targetButton: sender, showEmojiView: nil)
            break
        case ENToolbarType.hanaApp.rawValue:
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, hanaApp: nil)
            break
        case ENToolbarType.hanaPPZone.rawValue:
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, hanaPPZone: nil)
            break
        case ENToolbarType.hanaCoupang.rawValue:
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, hanaCoupang: nil)
            break
        case ENToolbarType.hanaPointList.rawValue:
//            if let title = sender.titleLabel?.text {
//                if title.contains("+") {
//                    callPointAPI()
//                }
//            }
            if ENSettingManager.shared.readyForHanaPoint != 0 {
                callPointAPI(targetBtn: sender)
            } else {
                delegate?.enKeyboardCustomAreaView(self, targetButton: sender, hanaPointList: nil)
            }
            break
        case ENToolbarType.hanaSetting.rawValue:
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, hanaSetting: nil)
            break
        default:
            break
        }
    }
    
    func callPointAPI(targetBtn: UIButton) {        
        ENKeyboardAPIManeger.shared.callSendPoint {[weak self] data, response, error in
            guard let self else { return }
            
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                #if DEBUG
                print("send_point : \(jsonString)")
                #endif
                
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(ENSendPointModel.self, from: jsonData)
                        
                        if data.Result == "true" {
                            DispatchQueue.main.async {
                                let totalPoint = ENSettingManager.shared.readyForHanaPoint
                                ENSettingManager.shared.readyForHanaPoint = data.total_point ?? 0
                                self.updateUI()
                                
                                if let super1 = self.superview {
                                    if let super2 = super1.superview {
                                        super2.showEnToast(message: "\(totalPoint)P 적립 완료!")
                                    }
                                }
                            }
                        } else {
//                            print("send_point error code : \(data.errcode ?? 0)")
//                            print("send_point error String : \(data.errstr ?? "errstr nil")")
                            DispatchQueue.main.async {
                                if let del = self.delegate {
                                    del.enKeyboardCustomAreaView(self, targetButton: targetBtn, hanaPointList: nil)
                                }
                                
                                if let super1 = self.superview {
                                    if let super2 = super1.superview {
                                        super2.showEnToast(message: data.errstr ?? "사용자 정보를 확인할 수 없어요. 하나머니 앱에서 인증해 주세요.")
                                    }
                                }
                            }
                        }
                    } catch {
                        print("send_point json parse error")
                        DispatchQueue.main.async {
                            if let del = self.delegate {
                                del.enKeyboardCustomAreaView(self, targetButton: targetBtn, hanaPointList: nil)
                            }
                            
                            if let super1 = self.superview {
                                if let super2 = super1.superview {
                                    super2.showEnToast(message: "데이터 확인에 실패하였습니다. 다시 시도해 주세요.")
                                }
                            }
                        }
                    }
                } else {
                    print("send_point invalid jsonData ")
                    DispatchQueue.main.async {
                        if let del = self.delegate {
                            del.enKeyboardCustomAreaView(self, targetButton: targetBtn, hanaPointList: nil)
                        }
                        
                        if let super1 = self.superview {
                            if let super2 = super1.superview {
                                super2.showEnToast(message: "확인되지 않은 데이터 입니다. 다시 시도해 주세요.")
                            }
                        }
                    }
                }
            } else {
                print("send_point invalid data & jsonString")
                DispatchQueue.main.async {
                    if let del = self.delegate {
                        del.enKeyboardCustomAreaView(self, targetButton: targetBtn, hanaPointList: nil)
                    }
                    
                    if let super1 = self.superview {
                        if let super2 = super1.superview {
                            super2.showEnToast(message: "올바른 접근이 아닙니다. 다시 시도해 주세요.")
                        }
                    }
                }
            }
        }
    }
    
    /// 툴바 버튼 UI 리셋
    public func resetButtonStatus() {
        for ele in btnArray {
            ele.isSelected = false
            
            let tabColor = keyboardTheme?.themeColors.tab_off ?? .clear
            
//            if tabColor.isLight() {
//                ele.imageView?.tintColor = .black
//            } else {
//                ele.imageView?.tintColor = .white
//            }
        }
    }
    
    /// 툴바 스크롤 뷰 Constraint 세팅
    public func setScrollViewConstraint() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.0).isActive = true
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 58)
    }
    
    /// 버튼들의 Width 값 설정
    func buttonWidthSetting(item: [UIButton]) {
        
        // let itemWidth = UIScreen.main.bounds.width / 7
        
        // 하나머니 전용
        var itemWidth = 0.0
        if ENSettingManager.shared.toolbarBrandUrl == "" {
            itemWidth = UIScreen.main.bounds.width / 5
        } else {
            itemWidth = UIScreen.main.bounds.width / 6
        }
        
        for ele in item {
            ele.translatesAutoresizingMaskIntoConstraints = false
            let constraint = ele.widthAnchor.constraint(equalToConstant: itemWidth)
            toolbarButtonWidthConstraint.append(constraint)
        }
        
        for const in toolbarButtonWidthConstraint {
            const.isActive = true
        }
    }
    
    /// 툴바 버튼의 width 크기를 재정의 한다.
    func buttonWidthUpdate(frame:CGRect) {
//        let itemWidth = UIScreen.main.bounds.width / 6
        
        // 하나머니 전용
        var itemWidth = 0.0
        if ENSettingManager.shared.toolbarBrandUrl == "" {
            itemWidth = frame.width / 5
        } else {
            itemWidth = frame.width / 6
        }

        for (index, _) in btnArray.enumerated() {
            btnArray[index].removeConstraint(toolbarButtonWidthConstraint[index])
        }
        
        toolbarButtonWidthConstraint.removeAll()
        
        for ele in btnArray {
            let constraint = ele.widthAnchor.constraint(equalToConstant: itemWidth)
            toolbarButtonWidthConstraint.append(constraint)
        }
        
        for const in toolbarButtonWidthConstraint {
            const.isActive = true
        }
    }
    
    /// 버튼들의 핸들러 연결
    func setButtonHandler(item: [UIButton]) {
        for ele in item {
            ele.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
            ele.addTarget(self, action: #selector(buttonTouchUpInSide(_:)), for: .touchUpInside)
            ele.addTarget(self, action: #selector(buttonTouchUpOutSide(_:)), for: .touchUpOutside)
        }
    }
    
    /// 스크롤 뷰의 터치 세팅
    func setScrollViewSetting(item: [UIButton]) {
        for ele in item {
            scrollView.touchesShouldCancel(in: ele)
        }
    }
    
    /// 테마에 맞게 커스텀 영역을 업데이트 한다.
    func updateUI() {
        if btnArray.isEmpty {
            initLayout()
        }
        
        let isPhoto = keyboardTheme?.isPhotoTheme ?? false
        let themeName = keyboardThemeModel?.name ?? "default"
        let isDefault = (themeName == "default")
        let folder = self.themeFolder(name: themeName, type: .custom)
        
        if !(isPhoto || isDefault) {
            for item in btnArray {
                item.backgroundColor = keyboardTheme?.themeColors.tab_off ?? .clear
                
                let tabColor = keyboardTheme?.themeColors.tab_off ?? .clear
                
//                if tabColor.isLight() {
//                    item.imageView?.tintColor = .black
//                } else {
//                    item.imageView?.tintColor = .white
//                }
            }
            
        } else {
            loadDefatulImage()
        }
        
        scrollView.backgroundColor = keyboardTheme?.themeColors.tab_off ?? .clear
        
        /// 기본 테마 이미지 설정
        func loadDefatulImage() {
            for item in btnArray {
                var img: UIImage? = nil
                switch item.tag {
                case ENToolbarType.mobicomz.rawValue:
                    // 이 부분은 이미지의 tint 컬러를 바꾸기 위해 설정함.
                    img = UIImage.init(named: "cell_toolbar_mobicomz", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    break
                case ENToolbarType.emoji.rawValue:
                    img = UIImage.init(named: "cell_toolbar_emoji", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    break
                case ENToolbarType.emoticon.rawValue:
                    img = UIImage.init(named: "cell_toolbar_emoticon", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    break
                case ENToolbarType.userMemo.rawValue:
                    img = UIImage.init(named: "cell_toolbar_memo", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    break
                case ENToolbarType.clipboard.rawValue:
                    img = UIImage.init(named: "cell_toolbar_clipboard", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    break
                case ENToolbarType.coupang.rawValue:
                    img = UIImage.init(named: "cell_toolbar_coupang", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    break
                case ENToolbarType.offerwall.rawValue:
                    img = UIImage.init(named: "cell_toolbar_opewarl", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    break
                case ENToolbarType.dutchPay.rawValue:
                    img = UIImage.init(named: "cell_toolbar_pay", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    break
                case ENToolbarType.hotIssue.rawValue:
                    img = UIImage.init(named: "cell_toolbar_hot", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    break
                case ENToolbarType.cursorLeft.rawValue:
                    img = UIImage.init(named: "cell_toolbar_left", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    break
                case ENToolbarType.cursorRight.rawValue:
                    img = UIImage.init(named: "cell_toolbar_right", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    break
                case ENToolbarType.setting.rawValue:
                    img = UIImage.init(named: "cell_toolbar_setting", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    break
                    
                    
                    
                case ENToolbarType.hanaEmoji.rawValue:
                    img = UIImage.init(named: "hana_toolbar_emoji", in: Bundle.frameworkBundle, compatibleWith: nil)
                    break
                case ENToolbarType.hanaApp.rawValue:
                    img = UIImage.init(named: "hana_toolbar_app", in: Bundle.frameworkBundle, compatibleWith: nil)
                    break
                case ENToolbarType.hanaPPZone.rawValue:
                    img = UIImage.init(named: "hana_toolbar_ppzone", in: Bundle.frameworkBundle, compatibleWith: nil)
                    break
                case ENToolbarType.hanaCoupang.rawValue:
                    img = UIImage.init(named: "hana_toolbar_coupang", in: Bundle.frameworkBundle, compatibleWith: nil)
                    break
                case ENToolbarType.hanaPointList.rawValue:
                    if ENSettingManager.shared.readyForHanaPoint != 0 {
                        img = UIImage.init(named: "hanaReadyPoint", in: Bundle.frameworkBundle, compatibleWith: nil)
                    } else {
                        img = UIImage.init(named: "hana_toolbar_point_list", in: Bundle.frameworkBundle, compatibleWith: nil)
                    }
                    break
                case ENToolbarType.hanaSetting.rawValue:
                    img = UIImage.init(named: "hana_toolbar_setting", in: Bundle.frameworkBundle, compatibleWith: nil)
                    break
                default:
                    img = UIImage.init(named: "cell_toolbar_empty", in: Bundle.frameworkBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                    break
                }
                
                item.setImage(img, for: .normal)
//                print("여기 와줘야해.... \(ENSettingManager.shared.readyForHanaPoint)")
                if ENSettingManager.shared.readyForHanaPoint != 0 {
//                    print("여기 와줘야해....")
                    if item.tag == ENToolbarType.hanaPointList.rawValue {
                        item.setTitle("+\(ENSettingManager.shared.readyForHanaPoint)", for: .normal)
                        item.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
                        item.setTitleColor(.white, for: .normal)
                        
                        item.alignTextBelow()
                    }
                }else{
                    if item.tag == ENToolbarType.hanaPointList.rawValue {
                        item.setTitle("", for: .normal)
                    }
                }
                
                if ENSettingManager.shared.toolbarBrandImageUrl.contains("http") {
                    if item.tag == ENToolbarType.hanaCoupang.rawValue {
                        DispatchQueue.main.async {
                            item.imageView?.loadImageAsync(with: ENSettingManager.shared.toolbarBrandImageUrl)
                        }
                    }
                }
                
                item.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
            }
        }
    }
    
    func updateRewardPointToolbar() {
        for item in btnArray {
            var img: UIImage? = nil
            switch item.tag {
            case ENToolbarType.hanaPointList.rawValue:
                if ENSettingManager.shared.readyForHanaPoint != 0 {
                    img = UIImage.init(named: "hanaReadyPoint", in: Bundle.frameworkBundle, compatibleWith: nil)
                    
                    item.setTitle("+\(ENSettingManager.shared.readyForHanaPoint)", for: .normal)
                    item.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
                    item.setTitleColor(.white, for: .normal)
                    
                    item.alignTextBelow()
                    
                } else {
                    img = UIImage.init(named: "hana_toolbar_point_list", in: Bundle.frameworkBundle, compatibleWith: nil)
                    item.setTitle("", for: .normal)

                }
                
                item.setImage(img, for: .normal)
                break
            default:
                break
            }
        }
    }
}

// MARK: - 타이머 관련 extension
extension ENKeyboardCustomAreaView {
    /// 광고 뷰의 노출 타이머 설정
    func startTimerForAd() {
        stopTimerForAd()
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    /// 광고 뷰의 노출 타이머 해제
    func stopTimerForAd() {
        timer?.invalidate()
    }
    
    /// 광고 뷰 보이기
    func showAdView() {
        if self.adViewTopConstraint.constant != 50.0 {
            self.bringSubviewToFront(viewAd)
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self else { return }
                self.adViewTopConstraint.constant = 50.0
                self.layoutIfNeeded()
            }
        }
    }
    
    /// 광고 뷰 가리기
    func hideAdView() {
        if self.adViewTopConstraint.constant == 50.0 {
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self else { return }
                self.adViewTopConstraint.constant = -50.0
                self.layoutIfNeeded()
            }
        }
    }
    
    @objc func timerFired() {
        showAdView()
    }
}

// MARK: - 더치페이 관련 extensions
extension ENKeyboardCustomAreaView {
    /// 더치 페이 툴바 뷰 보이기 핸들러
    @objc func showDutchPayToolbar(_ sender: UIButton) {
        showDutchPayToolbar()
    }
    /// 더치 페이 툴바 뷰 보이기
    func showDutchPayToolbar() {
        dutchPayView.isHidden = false
        self.bringSubviewToFront(dutchPayView)
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            self.dutchPayTopConstraint.constant = 90.0
            self.layoutIfNeeded()
        }
    }
    /// 더치 페이 툴바 뷰 UI 세팅
    func initDutchPay() {
        lblDutchPayTop.text = "빈칸을 입력 해주세요."
        lblDutchPayTop.textColor = UIColor(red: 114/255, green: 131/255, blue: 169/255, alpha: 1)
        
        
        btnPersonNumber.setTitle("몇 명이서", for: .normal)
        btnPersonNumber.setTitleColor(UIColor(red: 141/255, green: 141/255, blue: 141/255, alpha: 1), for: .normal)
        
        btnCalculatePay.setTitle("얼마를 나누시나요?", for: .normal)
        btnCalculatePay.setTitleColor(UIColor(red: 141/255, green: 141/255, blue: 141/255, alpha: 1), for: .normal)
        
        btnPersonNumber.layer.borderColor = CGColor(red: 2/255, green: 139/255, blue: 252/255, alpha: 1)
        btnPersonNumber.layer.borderWidth = 1
        
        btnCalculatePay.layer.borderWidth = 0
    }
    /// 더치 페이 툴바 뷰 가리기 핸들러
    @objc func hideDutchPayToolbar(_ sender: UIButton) {
        hideDutchPayToolbar()
        delegate?.enKeyboardCustomAreaView(self, targetButton: sender, dutchPayHide: nil)
    }
    /// 더치 페이 툴바 뷰 가리기
    func hideDutchPayToolbar() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            self.dutchPayTopConstraint.constant = -90.0
            self.layoutIfNeeded()
        }
    }
    /// 더치 페이 툴바 뷰에 인원 부분 포커스 하는 버튼 핸들러
    @objc func btnPersonNumberHandler(_ sender: UIButton) {
        delegate?.enKeyboardCustomAreaView(self, targetButton: sender, focusPerson: nil)
    }
    /// 더치 페이 툴바 뷰에 금액 부분 포커스 하는 버튼 핸들러
    @objc func btnCalculatePayHandler(_ sender: UIButton) {
        delegate?.enKeyboardCustomAreaView(self, targetButton: sender, focusPrice: nil)
    }
}

extension UIButton {
    func alignTextBelow(spacing: CGFloat = 0.0) {
        guard let image = self.imageView?.image else { return }
        guard let titleLabel = self.titleLabel else { return }
        guard let titleText = titleLabel.text else { return }
        
        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font as Any
        ])
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -image.size.width, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
    }
}

struct ENSendPointModel: Codable {
    let Result: String
    let total_point: Int?
    let errcode: Int?
    let errstr: String?
}
