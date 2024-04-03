//
//  ENKeyboardCusomAreaView.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2021/07/08.
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
    /// 붙여넣기 할때 사용
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, text: String, pasteText completion: (() -> Void)?)
    ///  앱으로 이동
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, moveApp completion: (() -> Void)?)
    ///  피피존 이동
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, movePPZone completion: (() -> Void)?)
    ///  쿠팡 이동
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, moveCoupang completion: (() -> Void)?)
    ///  적립리스트
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, movePointList completion: (() -> Void)?)
    ///  설정
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, moveSetting completion: (() -> Void)?)
    ///  캐시딜
    func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, moveCashDeal completion: (() -> Void)?)
}
/// 커스텀 영역
///  - 키보드 위 툴바 부분을 세팅함.
///  - 여기에 사용 되는 기본적인 뷰는 wrapper 인 UIView
///  - 그 안에 기본적으로 사용되는 툴바인 ScrollView
///  - 광고나,, 붙여넣기 뷰는 Constraint 로 보여줬다 가렸다가 함.
public class ENKeyboardCustomAreaView: UIView {

    
    // MARK: - 툴바 관련 뷰 !!!!!!!!!!
    public lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = keyboardTheme?.themeColors.tab_off ?? .clear

        
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
        // 툴바 아이템 가져오기
        
        let toolbarItems = ENSettingManager.shared.toolbarItems
        scrollButtonSetting(toolbarItems: toolbarItems)
        scrollView.isPagingEnabled = false
        // 버튼의 핸들러 연결
        setButtonHandler(item: btnArray)
        //버튼의 Width 값 세팅
        buttonWidthSetting(item: btnArray)
        // 스크롤 뷰 세팅
        setScrollViewSetting(item: btnArray)
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
        // UI 업데이트
        updateUI()
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
    
    
    
       
    
    /// 툴바 스타일 스크롤에 맞는 툴바 버튼 세팅
    func scrollButtonSetting(toolbarItems: [ENToolbarItem]) {
        for item in toolbarItems {
         
            if item.isUse {
                if item.toolbarType == "34" {
                    if ENSettingManager.shared.toolbarBrandUrl != "" {
                        let button = createButton(title: "", senderTag: item.toolType.rawValue)
                        button.setImage(UIImage.init(named: item.imgName, in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
                        button.backgroundColor = keyboardTheme?.themeColors.tab_off ?? .clear

                        btnArray.append(button)
                        stackView.addArrangedSubview(button)
                        if ENSettingManager.shared.toolbarBrandImageUrl.contains("http") {
                            DispatchQueue.main.async {
                                button.imageView?.loadImageAsync(with: ENSettingManager.shared.toolbarBrandImageUrl)
                            }
                        }
                                        
                    }
                } else {
                    let button = createButton(title: "", senderTag: item.toolType.rawValue)
                    button.setImage(UIImage.init(named: item.imgName, in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
                    button.backgroundColor = keyboardTheme?.themeColors.tab_off ?? .clear

                    btnArray.append(button)
                    stackView.addArrangedSubview(button)
                    if item.toolType.rawValue == ENToolbarType.keyboardPointList.rawValue{
                        updateRewardPointToolbar()
                    }

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
    /// 툴바 버튼 바깥 영역 터치 핸들러
    @objc func buttonTouchUpOutSide(_ sender: UIButton) {
        sender.backgroundColor = keyboardTheme?.themeColors.tab_off ?? .clear
    }
    /// 툴바 터치 다운 핸들러
    @objc func buttonTouchDown(_ sender: UIButton) {
        sender.backgroundColor = keyboardTheme?.themeColors.tab_on ?? .clear
    }
    /// 툴바 터치 업 핸들러
    @objc func buttonTouchUpInSide(_ sender: UIButton) {
        sender.backgroundColor = keyboardTheme?.themeColors.tab_off ?? .clear
        
        switch sender.tag {
            
            
        case ENToolbarType.keyboardEmoji.rawValue:
            delegate?.enKeyboardCusomAreaView(self, targetButton: sender, showEmojiView: nil)
            break
        case ENToolbarType.keyboardApp.rawValue:
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, moveApp: nil)
            break
        case ENToolbarType.keyboardPPZone.rawValue:
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, movePPZone: nil)
            break
        case ENToolbarType.keyboardCoupang.rawValue:
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, moveCoupang: nil)
            break
        case ENToolbarType.keyboardPointList.rawValue:
            if ENSettingManager.shared.readyForPoint != 0 {
                callPointAPI(targetBtn: sender)
            } else {
                delegate?.enKeyboardCustomAreaView(self, targetButton: sender, movePointList: nil)
            }
            break
        case ENToolbarType.keyboardSetting.rawValue:
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, moveSetting: nil)
            break
        case ENToolbarType.keyboardCashDeal.rawValue:
            delegate?.enKeyboardCustomAreaView(self, targetButton: sender, moveCashDeal: nil)
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
                                let totalPoint = ENSettingManager.shared.readyForPoint
                                ENSettingManager.shared.readyForPoint = data.total_point ?? 0
                                self.updateRewardPointToolbar()
                                if let super1 = self.superview {
                                    if let super2 = super1.superview {
                                        super2.showEnToast(message: "\(totalPoint)P 적립 완료!")
                                    }
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                if let del = self.delegate {
                                    del.enKeyboardCustomAreaView(self, targetButton: targetBtn, movePointList: nil)
                                }
                                
                                if let super1 = self.superview {
                                    if let super2 = super1.superview {
                                        super2.showEnToast(message: data.errstr ?? "사용자 정보를 확인할 수 없어요. 캐시워크 앱에서 인증해 주세요.")
                                    }
                                }
                            }
                        }
                    } catch {
                        print("send_point json parse error")
                        DispatchQueue.main.async {
                            if let del = self.delegate {
                                del.enKeyboardCustomAreaView(self, targetButton: targetBtn, movePointList: nil)
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
                            del.enKeyboardCustomAreaView(self, targetButton: targetBtn, movePointList: nil)
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
                        del.enKeyboardCustomAreaView(self, targetButton: targetBtn, movePointList: nil)
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
            ele.backgroundColor = tabColor

            if tabColor.isLight() {
                ele.imageView?.tintColor = .black
            } else {
                ele.imageView?.tintColor = .white
            }
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
    }
    
    func updateRewardPointToolbar() {
        for item in btnArray {
            var img: UIImage? = nil
            switch item.tag {
            case ENToolbarType.keyboardPointList.rawValue:
                if ENSettingManager.shared.readyForPoint != 0 {
                    img = UIImage.init(named: "cashwalkReadyPoint", in: Bundle.frameworkBundle, compatibleWith: nil)
                    
                    item.setTitle("+\(ENSettingManager.shared.readyForPoint)", for: .normal)
                    item.titleLabel?.font = .systemFont(ofSize: 11, weight: .regular)
                    item.setTitleColor(UIColor(red: 94/255, green: 80/255, blue: 80/255, alpha:1), for: .normal)
                    item.alignTextBelow()
                    
                } else {
                    img = UIImage.init(named: "cashwalk_toolbar_point_list", in: Bundle.frameworkBundle, compatibleWith: nil)
                    item.setTitle("", for: .normal)
                    item.resetEdgeInsets()
                }
                
                item.setImage(img, for: .normal)
                break
            default:
                break
            }
        }
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
    func resetEdgeInsets() {
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

struct ENSendPointModel: Codable {
    let Result: String
    let total_point: Int?
    let errcode: Int?
    let errstr: String?
}
