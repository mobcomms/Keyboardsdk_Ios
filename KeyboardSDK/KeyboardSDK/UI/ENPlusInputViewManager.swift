//
//  ENPlusInputViewManager.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/26.
//

import UIKit
import KeyboardSDKCore
import WebKit



/// 팬플러스에서 iOS 12.1을 사용하면서 발생하는 이슈에 대한 대응으로 만들어진 클래스
/// ViewController의 각 라이프 사이클에 맞춰 호출해야 하는 기능들을 정의한다.

public class ENPlusInputViewManager {
    /// 싱글톤
    public static let shared:ENPlusInputViewManager = ENPlusInputViewManager()
    
    /// inputViewController 생성
    public var inputViewController:UIInputViewController?
    
    /// 테마에 접근 할 수 있는 객체 생성
    var keyboardTheme: ENKeyboardTheme? = ENKeyboardTheme()
    /// 키보드 뷰 매니저 생성
    var keyboardViewManager: ENKeyboardViewManager?
    /// 커스텀 영역 생성
    var customAreaView:ENKeyboardCustomAreaView? = nil
    /// 키보드 프레임
    var keyboardFrame:CGRect = .zero
    /// 자주쓰는 메모 데이터 로드
    let userMemoData = ENSettingManager.shared.userMemo
    /// 더치페이 뷰 생성
    var dutchPayView: ENDutchpayView?
    /// 최 상단 알림 뷰
    var notifyView: ENNotifyView? = nil
    
    var hanaKeyboardContentSettingView: HanaKeyboardContentSettingView? = nil
    
    /// 나중에 서버에서 받아오기!
    var showAdForCount: Int = 5
    var prevOrentaion = true
    let enKeyboardSDK = ENKeyboardSDK.shared
    let enKeyboardSDKCore = ENKeyboardSDKCore.shared
    
    init(){
    }
    
    public func viewDidLoad() {
        
        /// 키보드 뷰 매니저 객체 생성
        keyboardViewManager = ENKeyboardViewManager.init(proxy: inputViewController?.textDocumentProxy, needsInputModeSwitchKey: inputViewController?.needsInputModeSwitchKey ?? true)
        /// 딜리게이트 전달
        keyboardViewManager?.delegate = self
        
        /// 커스텀 영역 생성
        customAreaView = ENKeyboardCustomAreaView(frame: .zero)
        /// 딜리게이트 전달
        customAreaView?.delegate = self
        
        /// 최 상단 알림 뷰 생성
        notifyView = ENNotifyView(frame: .zero)
        /// 딜리게이트 전달
        notifyView?.delegate = self
        
        /// 현재 테마 정보 가져오기
        let selectedTheme = ENKeyboardThemeManager.shared.getCurrentTheme()
        /// 테마 파일 정보 가져오기
        let themeFileInfo = selectedTheme.themeFileInfo()
        
        /// 커스텀 영역에 키보드 테마 전달
        customAreaView?.keyboardThemeModel = selectedTheme
        /// 테마 로드 후 테마 설정
        ENKeyboardThemeManager.shared.loadTheme(theme: themeFileInfo) {[weak self] theme in
            guard let self else { return }
            self.keyboardTheme = theme
            self.keyboardViewManager?.keyboardTheme = theme
            self.customAreaView?.keyboardTheme = theme
        }
        /// 전체적인 인터페이스 로드
        self.loadInterface()
        /// 키보드 매니저에 딜리게이트 전달
        keyboardViewManager?.keyboardManager?.delegate = self
        
        /// 광고 팝업 사용중 일 때 키보드가 생성 될때 마다 1증가
        if ENSettingManager.shared.useAd || ENSettingManager.shared.useNewsAd {
            ENSettingManager.shared.keyboardShowCount = ENSettingManager.shared.keyboardShowCount + 1
        }
        
    }
    
    /// 화면 회전 시 여기에 들어옴
    public func viewWillLayoutSubviews() {
        // 여기가 뷰의 크기가 바뀌면 들어오는 곳임
        var isPortrait = true
        guard let inputView = inputViewController else{return}
        isPortrait = inputView.preferredInterfaceOrientationForPresentation.isPortrait
        if isPortrait {
            if inputView.view.frame.width > inputView.view.frame.height && prevOrentaion
                || (inputViewController?.view.frame.width ?? 0) == keyboardFrame.width{
                return
            }
        }else{
            if (inputView.view.frame.width < inputView.view.frame.height && !prevOrentaion)
                || (inputViewController?.view.frame.width ?? 0) == keyboardFrame.width {
                return
            }
            
        }
        prevOrentaion = inputView.preferredInterfaceOrientationForPresentation.isPortrait
        
        keyboardFrame = inputViewController?.view.frame ?? .zero
        keyboardViewManager?.keyboardManager?.updateKeyboardFrame(frame: (inputViewController?.view.frame ?? .zero))
        //MARK: - 가로 모드, 세로 모드 대응하는 곳
        /// 가로 세로 값을 가져옴. 이 값은 상위 class 에서 지정해줘야 한다.
        /// ENInputViewController 에서 supportedInterfaceOrientations 이곳에서 지정해야 함
        /// 공지사항 뷰가 가로 일 때 가려지지만 세로로 변경 되면서 다시 보이진 않습니다.
        ///
        
        if let customAreaView = customAreaView{
            self.resetKeyboard(customAreaView)
        }
        if isPortrait {
            
            // 세로 일 때는 그냥 툴바 버튼 정도만 크기 업데이트 해준다.
            keyboardViewManager?.updateKeyboardHeight(isLand: false)
            customAreaView?.buttonWidthUpdate(frame: (inputViewController?.view.frame ?? .zero))
            if  notifyView?.heightConstraint?.constant == 0{
                self.loadInterface()
                notifyView?.updateNotifyView(isLand: false)
                
            }
            
            // 더치페이, 핫이슈 등 다른 콘텐츠 영역이 보여질 때 constraint 를 업데이트 한다.
            keyboardViewManager?.updateContentView()
            // 더치페이는 버튼의 높이를 변화 시켜야 하기 때문에 따로 한번 더 호출 함.
            if let manager = keyboardViewManager {
                if manager.isUseDutchPay {
                    dutchPayView?.updateButtonHeight(isLand: false)
                }
            }
        } else {
            // 똑같이 툴바 버튼 크기 업데이트 해줌.
            // 가로 일 때는 공지사항 뷰를 아주 가려버린다.
            keyboardViewManager?.isUseNotifyView = false
            keyboardViewManager?.updateKeyboardHeight(isLand: true)
            customAreaView?.buttonWidthUpdate(frame: (inputViewController?.view.frame ?? .zero))
            notifyView?.updateNotifyView(isLand: true)
            
            // 더치페이, 핫이슈 등 다른 콘텐츠 영역이 보여질 때 constraint 를 업데이트 한다.
            keyboardViewManager?.updateContentView()
            // 더치페이는 버튼의 높이를 변화 시켜야 하기 때문에 따로 한번 더 호출 함.
            if let manager = keyboardViewManager {
                if manager.isUseDutchPay {
                    dutchPayView?.updateButtonHeight(isLand: true)
                }
            }
            
            if let settingView = hanaKeyboardContentSettingView {
                settingView.btnClose.removeFromSuperview()
                settingView.webView.removeFromSuperview()
                settingView.innerADView.removeFromSuperview()
                settingView.removeFromSuperview()
            }
        }
    }
    
    /// 이전에 작업 되있던거라 잘 모르겠지만 키보드가 보여질 때 프레임 조절 하는거 같음.
    func updateKeyboardFrame() {
        keyboardFrame = inputViewController?.view.frame ?? .zero
        keyboardViewManager?.keyboardManager?.updateKeyboardFrame(frame: (inputViewController?.view.frame ?? .zero))
        
        if (inputViewController?.view.frame.width ?? 0) > UIScreen.main.bounds.size.width || UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            keyboardViewManager?.updateKeyboardHeight(isLand: true)
        } else {
            keyboardViewManager?.updateKeyboardHeight(isLand: false)
        }
    }
    
    public func viewWillAppear(_ animated: Bool) {
        /// 키보드가 보여질 때 Constraint 업데이트
        keyboardViewManager?.updateConstraints()
        /// 키보드가 보여질 때 키 없데이트
        keyboardViewManager?.updateKeys()
    }
    
    public func viewDidAppear(_ animated: Bool) {
        /// 키보드가 보여진 횟수에 따라 광고 노출하는 부분
        if showAdForCount <= ENSettingManager.shared.keyboardShowCount {
            ENSettingManager.shared.keyboardShowCount = 0
            if let tempCustomView = customAreaView {
                if tempCustomView.adViewTopConstraint.constant != 50.0 {
                    customAreaView?.showAdView()
                }
            }
        }
        
        if let notiView = notifyView {
            //            //            print("여기는/... : \(notiView.webView.bounds)")
            //            notiView.webViewSetting()
            notiView.addWebView()
        }
        
        
        /// 하나머니에 적립될 키보드 적립 총 포인트
        loadUserTotalPoint()
        /// 광고이동으로 적립된 내역이 있는지 체크해서 토스트 메시지 띄워주기
        checkToastMsg()
    }
    
    public func viewWillDisappear(_ animated: Bool) {
        // 키보드가 사라질 때 광고 노출 가리고 타이머 해제 하기
        if ENSettingManager.shared.useNewsAd || ENSettingManager.shared.useAd {
            customAreaView?.hideAdView()
            customAreaView?.stopTimerForAd()
        }
        getBrandUtil()
        
        // 키보드 3회 카운팅 플래그 true 로 변경
        ENSettingManager.shared.usingKeyboardCntFlag = true
        
        //        exit(0)
        // 키보드 테마 해제
        //        keyboardTheme = nil
        //        inputViewController = nil
        //        keyboardViewManager = nil
        //        dutchPayView = nil
        //        customAreaView = nil
        notifyView?.newsTimer?.invalidate()
        notifyView?.newsTimer = nil
        notifyView = nil
        //        hanaKeyboardContentSettingView = nil
    }
    func getBrandUtil(){
        let now = DHUtils.getNowDateToString()
        if ENSettingManager.shared.brandUtilDay == "" || ENSettingManager.shared.brandUtilDay != now {
            ENSettingManager.shared.isFistUsingKeyboard = false
            ENSettingManager.shared.brandUtilDay = now
            ENKeyboardAPIManeger.shared.callBrandUtil() { data, response, error in
                if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                    if let jsonData = jsonString.data(using: .utf8) {
                        do {
                            let data = try JSONDecoder().decode(ENBrandUtilModel.self, from: jsonData)
                            
                            if data.brand_url != "" && data.brand_img_path != "" {
                                if data.brand_url.contains("^|^") && data.brand_img_path.contains("^|^") {
                                    let brandComponents = data.brand_url.components(separatedBy: "^|^")
                                    let brandImgComponents = data.brand_img_path.components(separatedBy: "^|^")
                                    
                                    if brandComponents[0] == brandImgComponents[0] {
                                        DispatchQueue.main.async {
                                            ENSettingManager.shared.toolbarBrandUrl = brandComponents[1]
                                            ENSettingManager.shared.toolbarBrandImageUrl = brandImgComponents[1]
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            ENSettingManager.shared.toolbarBrandUrl = ""
                                            ENSettingManager.shared.toolbarBrandImageUrl = ""
                                        }
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        ENSettingManager.shared.toolbarBrandUrl = ""
                                        ENSettingManager.shared.toolbarBrandImageUrl = ""
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    ENSettingManager.shared.toolbarBrandUrl = ""
                                    ENSettingManager.shared.toolbarBrandImageUrl = ""
                                }
                            }
                        } catch {
                            print("get_brand_util error : \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        setDayStats()
        
    }
    func setDayStats(){
        
        if !ENSettingManager.shared.isFistUsingKeyboard {
            ENKeyboardAPIManeger.shared.callDayStats() { data, response, error in
                if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                    if let jsonData = jsonString.data(using: .utf8) {
                        do {
                            let data = try JSONDecoder().decode(ENDayStatsModel.self, from: jsonData)
                            if data.Result == "true"{
                                
                                ENSettingManager.shared.isFistUsingKeyboard = true
                            }else{
                                
                            }
                            
                        } catch {
                        }
                    }
                }
            }
        }
        
    }
    /// 인터페이스 로드 / 원래 있던 부분
    func loadInterface() {
        inputViewController?.view = keyboardViewManager?.loadKeyboardView()
        inputViewController?.view.clipsToBounds = false
        
        // 커스텀 영역 세팅
        if let customAreaView = customAreaView {
            keyboardViewManager?.initCustomArea(with: customAreaView)
            customAreaView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            customAreaView.isUserInteractionEnabled = true
            customAreaView.sizeToFit()
            
            customAreaView.setScrollViewConstraint()
        }
        
        // 최 상단 공지 뷰 설정
        keyboardViewManager?.isUseNotifyView = true
        // 최 상단 공지 뷰 세팅
        if let notifyView = notifyView {
            keyboardViewManager?.initNotifyArea(with: notifyView)
            notifyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            notifyView.isUserInteractionEnabled = true
            notifyView.sizeToFit()
        }
        
        if let inputView = inputViewController {
            if !inputView.preferredInterfaceOrientationForPresentation.isLandscape {
                // 최 상단 공지 뷰 설정
                keyboardViewManager?.isUseNotifyView = true
                // 최 상단 공지 뷰 세팅
                if let notifyView = notifyView {
                    keyboardViewManager?.initNotifyArea(with: notifyView)
                    notifyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    notifyView.isUserInteractionEnabled = true
                    notifyView.sizeToFit()
                }
            } else {
                keyboardViewManager?.isUseNotifyView = false
            }
        }
        // 키보드 프레임 업데이트
        updateKeyboardFrame()
    }
    func checkToastMsg(){
        /// 토스트메시지  ENSettingManager.shared.zoneToastMsg 가 있으면 띄워줌
        DispatchQueue.main.async {
            if ENSettingManager.shared.zoneToastMsg != ""{
                self.inputViewController?.view.showEnToast(message: ENSettingManager.shared.zoneToastMsg)
                ENSettingManager.shared.zoneToastMsg = ""
            }
        }
    }
    
    func loadUserTotalPoint() {
        
        ENKeyboardAPIManeger.shared.getUserTotalPoint(){[weak self] data, response, error in
            guard let self = self else { return }
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                //                print("get_user_total_point : \(jsonString)")
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(ENCheckPointModel.self, from: jsonData)
                        ENSettingManager.shared.usingKeyboardCntFlag = true
                        
                        if data.Result == "true" {
                            DispatchQueue.main.async {
                                ENSettingManager.shared.readyForHanaPoint = data.total_point
                                if let custom = self.customAreaView {
                                    custom.updateRewardPointToolbar()
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                ENSettingManager.shared.readyForHanaPoint = 0
                                if let custom = self.customAreaView {
                                    custom.updateRewardPointToolbar()
                                }
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            ENSettingManager.shared.readyForHanaPoint = 0
                            if let custom = self.customAreaView {
                                custom.updateRewardPointToolbar()
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func textWillChange(_ textInput: UITextInput?) {
    }
    
    public func textDidChange(_ textInput: UITextInput?) {
    }
    // 최 상단 공지 뷰 닫기
    func adViewCloses() {
        //        print("여기 오냐")
        if let keyboardViewManager = keyboardViewManager {
            //            if keyboardViewManager.isUseNotifyView {
            //                keyboardViewManager.isUseNotifyView = false
            //                keyboardViewManager.updateNotifyViewConstraint()
            //                notifyView?.heightConstraint?.constant = 0
            //                notifyView?.btnClose.removeFromSuperview()
            //                notifyView?.webView.removeFromSuperview()
            //            }
            notifyView?.btnClose.removeFromSuperview()
            notifyView?.webView.removeFromSuperview()
            notifyView?.innerADView.removeFromSuperview()
        }
    }
    
}





// MARK: - ENKeyboardManagerDelegate
extension ENPlusInputViewManager: ENKeyboardManagerDelegate {
    public func textInputted(manager: ENKeyboardManager, text: String?) {
        let tempText = text ?? "nil"
        
        if tempText == "nil" {
            return
        }
        
        // 키보드 3회 카운팅 체크하기
        if ENSettingManager.shared.usingKeyboardCntFlag {
            // 카운팅 로직에 들어왔으니 바로 usingKeyboardCntFlag 값을 false 로 바꿔주기 (다시 들어오는것을 차단하기)
            ENSettingManager.shared.usingKeyboardCntFlag = false
            
            // 카운팅이 3인지 먼저 체크
            if ENSettingManager.shared.usingKeyboardCnt == 3 {
                // 포인트 api 호출
                ENKeyboardAPIManeger.shared.getUserCheckPoint { data, response, error in
                    if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                        
                        if let jsonData = jsonString.data(using: .utf8) {
                            do {
                                let data = try JSONDecoder().decode(ENCheckPointModel.self, from: jsonData)
                                if data.Result == "true" {
                                } else {
                                    print("get_user_chk_point data result false")
                                }
                                DispatchQueue.main.async { [weak self] in
                                    guard let self = self else { return }
                                    // 상단 툴바에 보여줄 포인트를 넣어준다.
                                    ENSettingManager.shared.readyForHanaPoint = data.total_point
                                    // 카운팅이 3이라 포인트 적립 확인을 했으니 카운팅을 0 으로 만들어 준다.
                                    ENSettingManager.shared.usingKeyboardCnt = 0
                                    // 상단 툴바의 UI 를 업데이트 한다.
                                    self.customAreaView?.updateRewardPointToolbar()
                                }
                                
                            } catch {
                                print("get_user_chk_point error : \(error.localizedDescription)")
                            }
                        }
                    }
                }
            } else {
                // 카운팅 증가
                ENSettingManager.shared.usingKeyboardCnt += 1
            }
            
        }
        
        if ENSettingManager.shared.useNewsAd || ENSettingManager.shared.useAd {
            customAreaView?.hideAdView()
            customAreaView?.startTimerForAd()
        }
    }
    
    public func handleInputModeList(manager: ENKeyboardManager) {
        inputViewController?.advanceToNextInputMode()
    }
    
    public func showEmojiView(manager: ENKeyboardManager) {
        self.keyboardViewManager?.showEmojiView()
    }
}

// MARK: - ENKeyboardCusomAreaViewDelegate
extension ENPlusInputViewManager: ENKeyboardCustomAreaViewDelegate {
    func resetKeyboard(_ customAreaView:ENKeyboardCustomAreaView) {
        customAreaView.resetButtonStatus()
        self.keyboardViewManager?.clearkeyboardAreaView()
    }
    
    public func enKeyboardCusomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, openMainPage completion: (() -> Void)?) {
        //        inputViewController?.open(url: URL(string: ENKeyboardSDKSchemeManager.enMainPage)!)
        inputViewController?.open(url: URL(string: ENKeyboardSDKSchemeManager.selfApp)!)
    }
    
    public func enKeyboardCusomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, showEmojiView completion: (() -> Void)?) {
        if targetButton.isSelected {
            self.keyboardViewManager?.dismissEmojiView()
            
            targetButton.isSelected = false
            //            targetButton.backgroundColor = keyboardTheme?.themeColors.tab_off
            
            targetButton.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
            
            //            if ((tabColor?.isLight()) != nil) {
            //                targetButton.imageView?.tintColor = .black
            //            } else {
            //                targetButton.imageView?.tintColor = .white
            //            }
            
        } else {
            self.resetKeyboard(customAreaView)
            self.keyboardViewManager?.showEmojiView()
            targetButton.isSelected = true
            //            targetButton.backgroundColor = keyboardTheme?.themeColors.tab_on
            targetButton.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
            //            targetButton.imageView?.tintColor = UIColor(red: 24/255, green: 110/225, blue: 245/255, alpha: 1)
        }
        
    }
    
    public func enKeyboardCusomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, showCoupangView completion: (() -> Void)?) {
        if let url = URL(string: "https://coupa.ng/b3kAjA") {
            inputViewController?.open(url: url)
        }
    }
    
    public func enKeyboardCusomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, showCliplboard completion: (() -> Void)?) {
        if targetButton.isSelected {
            self.keyboardViewManager?.restoreKeyboardViewFrom(customView: nil)
            targetButton.isSelected = false
            
            let tabColor = keyboardTheme?.themeColors.tab_off
            
            if ((tabColor?.isLight()) != nil) {
                targetButton.imageView?.tintColor = .black
            } else {
                targetButton.imageView?.tintColor = .white
            }
            
        } else {
            self.resetKeyboard(customAreaView)
            
            let clipboardView = ENKeyboardClipboardView.create()
            clipboardView.backgroundColor = .clear
            clipboardView.isUserInteractionEnabled = true
            clipboardView.delegate = self
            keyboardViewManager?.showCustomContents(customView: clipboardView)
            
            clipboardView.keyboardTheme = customAreaView.keyboardTheme
            clipboardView.keyboardThemeModel = customAreaView.keyboardThemeModel
            
            targetButton.isSelected = true
            targetButton.imageView?.tintColor = UIColor(red: 24/255, green: 110/225, blue: 245/255, alpha: 1)
        }
    }
    
    public func enKeyboardCusomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, showUserMemo completion: (() -> Void)?) {
        if targetButton.isSelected {
            self.keyboardViewManager?.restoreKeyboardViewFrom(customView: nil)
            
            targetButton.isSelected = false
            
            let tabColor = keyboardTheme?.themeColors.tab_off
            
            if ((tabColor?.isLight()) != nil) {
                targetButton.imageView?.tintColor = .black
            } else {
                targetButton.imageView?.tintColor = .white
            }
            
        } else {
            self.resetKeyboard(customAreaView)
            
            let userMemoTableView = ENUserMemoTableView()
            userMemoTableView.delegate = self
            keyboardViewManager?.showCustomContents(customView: userMemoTableView)
            
            targetButton.isSelected = true
            targetButton.imageView?.tintColor = UIColor(red: 24/255, green: 110/225, blue: 245/255, alpha: 1)
        }
    }
    
    public func enKeyboardCustomAreaView(_ customAreaView: ENKeyboardCustomAreaView, targetButton: UIButton, showHotIssue completion: (() -> Void)?) {
        if targetButton.isSelected {
            self.keyboardViewManager?.restoreKeyboardViewFrom(customView: nil)
            
            targetButton.isSelected = false
            
            let tabColor = keyboardTheme?.themeColors.tab_off
            
            if ((tabColor?.isLight()) != nil) {
                targetButton.imageView?.tintColor = .black
            } else {
                targetButton.imageView?.tintColor = .white
            }
            
        } else {
            self.resetKeyboard(customAreaView)
            
            let hotIssueTableView = ENHotIssueTableView()
            hotIssueTableView.delegate = self
            
            keyboardViewManager?.showCustomContents(customView: hotIssueTableView)
            
            targetButton.isSelected = true
            targetButton.imageView?.tintColor = UIColor(red: 24/255, green: 110/225, blue: 245/255, alpha: 1)
        }
    }
    
    public func enKeyboardCustomAreaView(_ customAreaView: ENKeyboardCustomAreaView, targetButton: UIButton, showDutchPay completion: (() -> Void)?) {
        if targetButton.isSelected {
            // 누를일이 없음...!
        } else {
            if ENSettingManager.shared.useNewsAd || ENSettingManager.shared.useAd {
                customAreaView.hideAdView()
                customAreaView.stopTimerForAd()
            }
            
            keyboardViewManager?.isUseDutchPay = true
            keyboardViewManager?.updateConstraints()
            self.customAreaView?.layoutIfNeeded()
            self.resetKeyboard(customAreaView)
            
            dutchPayView = ENDutchpayView()
            dutchPayView?.delegates = self
            keyboardViewManager?.showCustomContents(customView: dutchPayView)
            
            if let inputView = inputViewController {
                if inputView.preferredInterfaceOrientationForPresentation.isPortrait {
                    dutchPayView?.updateButtonHeight(isLand: false)
                } else {
                    dutchPayView?.updateButtonHeight(isLand: true)
                }
            }
            
            self.customAreaView?.showDutchPayToolbar()
            
            targetButton.isSelected = true
            targetButton.imageView?.tintColor = UIColor(red: 24/255, green: 110/225, blue: 245/255, alpha: 1)
        }
    }
    
    public func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, dutchPayHide completion: (() -> Void)?) {
        checkUseDutchPay()
        
        dutchPayView?.initDutchPayView()
        customAreaView.initDutchPay()
        
        self.keyboardViewManager?.restoreKeyboardViewFrom(customView: nil)
        
        targetButton.isSelected = false
        
        let tabColor = keyboardTheme?.themeColors.tab_off
        
        if ((tabColor?.isLight()) != nil) {
            targetButton.imageView?.tintColor = .black
        } else {
            targetButton.imageView?.tintColor = .white
        }
        
        if ENSettingManager.shared.useNewsAd || ENSettingManager.shared.useAd {
            customAreaView.startTimerForAd()
        }
    }
    
    public func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, focusPerson completion: (() -> Void)?) {
        dutchPayView?.isPerson = true
        dutchPayView?.isPrice = false
        
        customAreaView.btnPersonNumber.layer.borderColor = CGColor(red: 2/255, green: 139/255, blue: 252/255, alpha: 1)
        customAreaView.btnPersonNumber.layer.borderWidth = 1
        
        customAreaView.btnCalculatePay.layer.borderWidth = 0
    }
    
    public func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, focusPrice completion: (() -> Void)?) {
        dutchPayView?.isPerson = false
        dutchPayView?.isPrice = true
        
        customAreaView.btnCalculatePay.layer.borderColor = CGColor(red: 2/255, green: 139/255, blue: 252/255, alpha: 1)
        customAreaView.btnCalculatePay.layer.borderWidth = 1
        
        customAreaView.btnPersonNumber.layer.borderWidth = 0
    }
    
    public func enKeyboardCustomAreaView(_ customAreaView: ENKeyboardCustomAreaView, targetButton: UIButton, text: String, pasteText completion: (() -> Void)?) {
        inputViewController?.textDocumentProxy.insertText(text)
    }
    
    public func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, cursorStyle: String, cursorMove: (() -> Void)?) {
        switch cursorStyle {
        case "L":
            inputViewController?.textDocumentProxy.adjustTextPosition(byCharacterOffset: -1)
            break
        case "R":
            inputViewController?.textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
            break
        default:
            break
        }
    }
    
    public func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, hanaApp completion: (() -> Void)?) {
        print("하나머니 앱으로 이동해야 합니다. : \(targetButton.isSelected)")
        if targetButton.isSelected {
            self.keyboardViewManager?.restoreKeyboardViewFrom(customView: nil)
            
            targetButton.isSelected = false
            //            targetButton.backgroundColor = keyboardTheme?.themeColors.tab_off
            targetButton.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
            //            let tabColor = keyboardTheme?.themeColors.tab_off
            //
            //            if ((tabColor?.isLight()) != nil) {
            //                targetButton.imageView?.tintColor = .black
            //            } else {
            //                targetButton.imageView?.tintColor = .white
            //            }
            
        } else {
            self.resetKeyboard(customAreaView)
            
            let hanaContentView = HanaContentView()
            //            hanaKeyboardContentSettingView.delegate = self
            //            let hotIssueTableView = ENHotIssueTableView()
            //            hotIssueTableView.delegate = self
            hanaContentView.delegate = self
            keyboardViewManager?.showCustomContents(customView: hanaContentView)
            
            
            
            targetButton.isSelected = true
            //            targetButton.backgroundColor = keyboardTheme?.themeColors.tab_on
            targetButton.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
            //            targetButton.imageView?.tintColor = UIColor(red: 24/255, green: 110/225, blue: 245/255, alpha: 1)
        }
    }
    
    public func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, hanaPPZone completion: (() -> Void)?) {
        print("하나머니 PPZone 으로 이동해야 합니다.")
        inputViewController?.open(url: URL(string: ENKeyboardSDKSchemeManager.ppzone)!)
    }
    
    public func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, hanaCoupang completion: (() -> Void)?) {
        // api 호출 후든 어떻게든 쿠팡 링크로 이동합니다.
        if let url = URL(string: ENSettingManager.shared.toolbarBrandUrl) {
            inputViewController?.open(url: url)
        } else {
            let tempUrl = URL(string: "https://coupa.ng/b3kAjA")
            inputViewController?.open(url: tempUrl!)
        }
    }
    
    public func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, hanaPointList completion: (() -> Void)?) {
        print("하나머니 포인트 적립 내역으로 이동합니다.")
        if targetButton.isSelected {
            self.keyboardViewManager?.restoreKeyboardViewFrom(customView: nil)
            
            targetButton.isSelected = false
            targetButton.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
        } else {
            self.resetKeyboard(customAreaView)
            
            let hanaPointContentView = HanaPointContentView()
            hanaPointContentView.delegate = self
            keyboardViewManager?.showCustomContents(customView: hanaPointContentView)
            
            targetButton.isSelected = true
            targetButton.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
        }
    }
    
    public func enKeyboardCustomAreaView(_ customAreaView:ENKeyboardCustomAreaView, targetButton: UIButton, hanaSetting completion: (() -> Void)?) {
        if targetButton.isSelected {
            self.keyboardViewManager?.restoreKeyboardViewFrom(customView: nil)
            
            targetButton.isSelected = false
            targetButton.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
        } else {
            self.resetKeyboard(customAreaView)
            
            hanaKeyboardContentSettingView = HanaKeyboardContentSettingView()
            hanaKeyboardContentSettingView?.delegate = self
            
            keyboardViewManager?.showCustomContents(customView: hanaKeyboardContentSettingView)
            
            targetButton.isSelected = true
            targetButton.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
        }
    }
    
    @objc func hideView(recognizer: UITapGestureRecognizer) {
        if let sendedView = recognizer.view {
            keyboardViewManager?.restoreKeyboardViewFrom(customView: sendedView)
        }
    }
    
    func checkUseDutchPay() {
        let checkFlg = keyboardViewManager?.isUseDutchPay
        if let checkFlg = keyboardViewManager?.isUseDutchPay {
            if checkFlg {
                keyboardViewManager?.isUseDutchPay = false
                keyboardViewManager?.updateConstraints()
                self.customAreaView?.layoutIfNeeded()
            }
        }
    }
}



// MARK: - ENKeyboardViewManagerDelegate
extension ENPlusInputViewManager: ENKeyboardViewManagerDelegate {
    public func enKeyboardViewManager(_ delegate: ENKeyboardViewManager, restoreToKeyboard: Bool) {
        self.customAreaView?.resetButtonStatus()
    }
}


// MARK: - ENKeyboardClipboardViewDelegate
extension ENPlusInputViewManager: ENKeyboardClipboardViewDelegate {
    func restoreKeyboard(from clipBoardView: ENKeyboardClipboardView) {
        self.keyboardViewManager?.restoreKeyboardViewFrom(customView: nil)
    }
    
    func didSelectedClipboardItem(from clipBoardView: ENKeyboardClipboardView, selected clipboard: String) {
        inputViewController?.textDocumentProxy.insertText(clipboard)
    }
    
    func needOpenAccess(from clipBoardView: ENKeyboardClipboardView) {
        inputViewController?.open(url: URL(string: ENKeyboardSDKSchemeManager.fullAccessPage)!)
    }
}


extension ENPlusInputViewManager: ENUserMemoTableViewDelegate {
    func didSelectUserMemo(from userMemoView: ENUserMemoTableView, selected userMemo: String) {
        inputViewController?.textDocumentProxy.insertText(userMemo)
    }
    
    func restoreKeyboard(from userMemoView: ENUserMemoTableView) {
        self.keyboardViewManager?.restoreKeyboardViewFrom(customView: nil)
    }
    
    func openUserMemoEdit(from userMemoView:ENUserMemoTableView, targetButton: UIButton, userMemoEdit completion: (() -> Void)?) {
        inputViewController?.open(url: URL(string: ENKeyboardSDKSchemeManager.userMemoEdit)!)
    }
}

extension ENPlusInputViewManager: ENHotIssueDelegate {
    func openUrl(url: URL) {
        inputViewController?.open(url: url)
    }
}

extension ENPlusInputViewManager: ENDutchpayViewDelegate {
    // 여기서 "" || 0 넘어오는거 체크
    func sendPersonNumber(person: String) {
        customAreaView?.lblDutchPayTop.textColor = UIColor(red: 2/255, green: 139/255, blue: 252/255, alpha: 1)
        
        let personNum = Int(person == "" ? "0" : person) ?? 0
        var priceNum = 0
        if let price = dutchPayView?.price {
            priceNum = Int(price) ?? 0
        } else {
            priceNum = 0
        }
        
        if personNum == 0 {
            customAreaView?.lblDutchPayTop.text = "0 명당 0 원"
        } else {
            let result = priceNum/personNum
            customAreaView?.lblDutchPayTop.text = "1명당 \(numberComma(num: result)) 원"
        }
        
        if let targetButton = self.customAreaView?.btnPersonNumber {
            targetButton.setTitle("\(person) 명", for: .normal)
            targetButton.setTitleColor(.black, for: .normal)
        }
    }
    
    func sendPriceNumber(price: String) {
        customAreaView?.lblDutchPayTop.textColor = UIColor(red: 2/255, green: 139/255, blue: 252/255, alpha: 1)
        
        var personNum = 0
        if let person = dutchPayView?.person {
            personNum = Int(person) ?? 0
        } else {
            personNum = 0
        }
        
        let priceNum = Int(price) ?? 0
        
        if personNum == 0 {
            customAreaView?.lblDutchPayTop.text = "0 명당 0 원"
        } else {
            let result = priceNum/personNum
            customAreaView?.lblDutchPayTop.text = "1명당 \(numberComma(num: result)) 원"
        }
        
        if let targetButton = self.customAreaView?.btnCalculatePay {
            targetButton.setTitle("\(numberComma(num: priceNum)) 원", for: .normal)
            targetButton.setTitleColor(.black, for: .normal)
        }
        
    }
    
    func sendResult(person: String, price: String) {
        
    }
    
    func sendLeftHandler() {
        dutchPayView?.isPerson = true
        dutchPayView?.isPrice = false
        
        customAreaView?.btnPersonNumber.layer.borderColor = CGColor(red: 2/255, green: 139/255, blue: 252/255, alpha: 1)
        customAreaView?.btnPersonNumber.layer.borderWidth = 1
        
        customAreaView?.btnCalculatePay.layer.borderWidth = 0
    }
    
    func sendRightHandler() {
        dutchPayView?.isPerson = false
        dutchPayView?.isPrice = true
        
        customAreaView?.btnCalculatePay.layer.borderColor = CGColor(red: 2/255, green: 139/255, blue: 252/255, alpha: 1)
        customAreaView?.btnCalculatePay.layer.borderWidth = 1
        
        customAreaView?.btnPersonNumber.layer.borderWidth = 0
    }
    
    func numberComma(num: Int) -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let result: String = numberFormatter.string(for: num)!
        return result
    }
}

extension ENPlusInputViewManager: ENNotifyViewDelegate, HanaKeyboardContentSettingViewDelegate {
    
    func adViewClose() {
        adViewCloses()
    }
    
    func openOtherBrowser(url: String) {
        if let url = URL(string: url) {
            inputViewController?.open(url: url)
        }
    }
    func canOpenURL(url: String) -> Bool{
        if let url = URL(string: url) {
            return inputViewController?.openURL(url) ?? false
        }else{
            return false
        }
    }
    func moveToNewsLink(url: String) {
        if let url = URL(string: url) {
            inputViewController?.open(url: url)
        }
    }
    func openTheme() {
        print("테마 뷰를 엽니다.")
    }
    
    func openClipBoard() {
        if let clipboardData = UIPasteboard.general.string {
            let savedChangeCount = UserDefaults.standard.lastSavedClipboardChangeCount()
            let changeCout = UIPasteboard.general.changeCount
            
            if savedChangeCount != changeCout {
                var data = UserDefaults.standard.getSavedClipBoardData()
                data.insert(clipboardData, at: 0)
                
                UserDefaults.standard.saveClipboardData(clipboard: data)
                UserDefaults.standard.saveLastSavedClipboardChangeCount(count: changeCout)
                
            }
        }
        
        if let customAreaView = customAreaView {
            self.resetKeyboard(customAreaView)
            
            let clipboardView = HanaClipboardView()
            clipboardView.delegate = self
            keyboardViewManager?.showCustomContents(customView: clipboardView)
        }
    }
    
    func openSetting() {
        inputViewController?.open(url: URL(string: ENKeyboardSDKSchemeManager.hanaSetting)!)
    }
    
    func openInquiry() {
        inputViewController?.open(url: URL(string: ENKeyboardSDKSchemeManager.hanaInquiry)!)
    }
}

extension ENPlusInputViewManager: HanaContentViewDelegate, HanaPointContentViewDelegate, HanaClipboardViewDelegate {
    func returnKeyboard() {
        self.keyboardViewManager?.restoreKeyboardViewFrom(customView: nil)
    }
    
    func insertClipboardText(clipboard: String) {
        inputViewController?.textDocumentProxy.insertText(clipboard)
    }
    
    func goToHanaLink(url: String) {
        if let urls = URL(string: url) {
            inputViewController?.open(url: urls)
        }
    }
}

struct ENCheckPointModel: Codable{
    let Result: String
    let total_point: Int
}

struct ENBrandUtilModel: Codable{
    let brand_url: String
    let brand_img_path: String
}
struct ENDayStatsModel: Codable{
    let Result: String
}
