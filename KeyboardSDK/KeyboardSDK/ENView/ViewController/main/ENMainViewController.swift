//
//  ENMainViewController.swift
//  KeyboardSDK
//
//  Created by enlinple on 2023/08/28.
//

import UIKit
import KeyboardSDKCore

struct ENDefaultSettingModel {
    var displayName: String
    var value: Any?
}
struct ENToolbarSettingModel {
    var displayName: String
    var isCheck: Bool?
    var value: Any?
}

/// 기본 설정 테이블 관련 딜리게이트
///  - defaultTableViewReloadDelegate : 기본 설정 테이블의 데이터를 리로드 함.
protocol ENMainViewControllerDelegate: AnyObject {
    func defaultTableViewReloadDelegate()
    func toolbarTableViewReloadDelegate()
}

public class ENMainViewController: UIViewController, ENViewPrsenter, UIScrollViewDelegate, ENMainViewControllerDelegate, ENTabContentPresenterDelegate, MyThemeManageProtocol {

    //MARK: - ENMainViewControllerDelegate 구현 부
    /// 기본 설정 페이지의 테이블 뷰를 리로드 할 때 사용
    func defaultTableViewReloadDelegate() {
        defaultSettingReloadData()
    }
    /// 툴바 페이지의 테이블 뷰를 리로드 할 때 사용
    func toolbarTableViewReloadDelegate() {
        toolbarSettingReloadData(isToolbarReload: true)
    }
    
    /// 해당 ViewController 생성
    public static func create() -> ENMainViewController {
        let vc = ENMainViewController.init(nibName: "ENMainViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    /// 기본 설정 테이블의 섹션 타이틀
    let defaultSettingTitle = [
        "키보드 설정",
        "사용자 설정",
        "상세 설정"
    ]
    /// 툴바 테이블의 섹션 타이틀
    let toolbarSettingTitle = [
        "BACKGROUND_CELL_AREA",
        "보너스 포인트 설정",
        "툴바 기능"
    ]
    
    /// 기본 설정 테이블의 데이터 Array
    var defaultSettingMenus: [Array<ENDefaultSettingModel>] = []
    /// 툴바 테이블의 데이터 Array
    var toolbarSettingMenus: [Array<Any>] = []
    /// 키보드에서 자주쓰는 메모 편집을 눌렀을 때 구분값으로 사용
    var isUserMemoEdit: Bool = false
    /// 메인 화면에서 키보드를 띄우기 위해 안보이는 TextField 를 생성
    @IBOutlet weak var textFieldTemp: UITextField!
    
    // MARK: - 상단 헤더뷰 관련 View
    /// 헤더 뷰
    @IBOutlet weak var headerView: UIView!
    /// 백버튼
    @IBOutlet weak var btnBack: UIButton!
    /// 키보드 show & hide 버튼
    @IBOutlet weak var btnKeyboard: UIButton!
    /// 헤더 타이틀
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: - 탭 스크롤의 버튼 관련 View
    /// 상단 탭 부분의 기본 설정
    @IBOutlet weak var btnDefaultSetting: UIButton!
    /// 상단 탭 부분의 툴바
    @IBOutlet weak var btnToolbarSetting: UIButton!
    /// 상단 탭 부분의 테마
    @IBOutlet weak var btnThemeSetting: UIButton!
    /// 상단 탭 부분의 더보기
    @IBOutlet weak var btnMoreSetting: UIButton!
    /// 구분선
    @IBOutlet weak var viewDivide: UIView!
    
    // MARK: - 테이블 View
    /// 메인 페이지의 전체 스크롤 뷰
    @IBOutlet weak var contentScrollView: UIScrollView!
    /// 기본 설정 테이블 뷰
    @IBOutlet weak var defaultSettingTable: UITableView!
    /// 툴바 테이블 뷰
    @IBOutlet weak var toolbarSettingTable: UITableView!
    /// 테마 콜렉션 뷰
    @IBOutlet weak var themeCollectionView: UICollectionView!
    // 더보기 화면은 그냥 View 이기 때문에 여기에 없고 아래에 있음
    
    // MARK: - 테마 View 관련 사용하는 변수
    /// 현재 테마를 보여주는 프레젠터
    var contentPresenter: ENTabContentPresenter?
    /// 다운로드 중 표시를 보여줄 프로그레스 뷰
    var downloadProgressView: UIViewController = UIViewController.init()
    /// 다운로드 중 표시를 보여줄 레이블
    var progressViewMessageLable:UILabel = UILabel()
    /// 다운로드 중 표시를 할 인디케이터
    var indicatorVeiw: ENActivityIndicatorView? = nil
    
    // MARK: - 메인 ScrollView 내부에 들어가는 View 의 Width Constraint
    /// 기본 설정 테이블 뷰의 Width Constraint
    @IBOutlet weak var defaultSettingWidthConstraint: NSLayoutConstraint!
    /// 툴바 테이블 뷰의 Width Constraint
    @IBOutlet weak var toolbarSettingWidthConstraint: NSLayoutConstraint!
    /// 테마 콜렉션 뷰의 Width Constraint
    @IBOutlet weak var themeViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - 툴바 관련 View
    /// 툴바를 보여줄 Wrapper 뷰
    @IBOutlet weak var viewToolbarWrapper: UIView!
    /// 툴바 안의 스크롤 뷰
    @IBOutlet weak var scrollViewToolbar: UIScrollView!
    /// 툴바 안의 스크롤 뷰 안의 스택 뷰
    @IBOutlet weak var stackViewToolbar: UIStackView!
    /// 툴바의 페이징 처리를 위한 PageControl
    @IBOutlet weak var pageControlToolbar: UIPageControl!
    
    // MARK: - 툴바 관련 변수
    /// 툴바의 아이콘 크기
    let settingToolbarTopIconWidth: CGFloat = 25.0
    
    ///
//    var isLoadedDefaultTable: Bool = false
//    var isLoadedToolbarTable: Bool = false
//    var isLoadedThemeTable: Bool = false
//    var isLoadedMoreTable: Bool = false
    
    // MARK: - 키보드 샘플 View 관련 변수
    /// 키보드 샘플 뷰
    @IBOutlet weak var keyboardSampleView: UIView!
    /// 키보드 샘플 뷰의 Height Constraint
    @IBOutlet weak var keyboardSampleViewHeightConstraint: NSLayoutConstraint!
    /// 전체 스크롤 뷰의 Bottom Constraint
    @IBOutlet weak var mainScrollViewBottomConstraint: NSLayoutConstraint!
    
    /// 키보드 매니저 세팅 | 샘플 뷰에 사용
    var keyboardViewManager: ENKeyboardViewManager?
    /// 커스텀 영역 생성 | 샘플 뷰에 사용
    var customAreaView: ENKeyboardCustomAreaView? = nil
    
    /// 테마 적용 및 닫기에 사용되는 스택 뷰
    @IBOutlet weak var viewThemeApply: UIStackView!
    /// 테마 적용 및 닫기 스택 뷰의 Height Constraint
    @IBOutlet weak var viewThemeStackViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - 더보기 화면 관련 UI
    /// 더보기 뷰
    @IBOutlet weak var viewMore: UIView!
    /// 나의 포인트 Wrapper 뷰
    @IBOutlet weak var viewMyPoint: UIView!
    /// 나의 포인트
    @IBOutlet weak var lblMyPoint: UILabel!
    /// 출석 체크 뷰
    @IBOutlet weak var viewDayCheck: UIView!
    /// 보너스 적립 기회 뷰
    @IBOutlet weak var viewBonus: UIView!
    /// 오늘의 타이핑 뷰
    @IBOutlet weak var viewTyping: UIView!
    /// 더보기 뷰의 Width Constraint
    @IBOutlet weak var moreViewWidthConstraint: NSLayoutConstraint!
    
    /// 테마뷰가 보이는지 에 대한 Flag
    var isShowingThemeView: Bool = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("몇번 눌렀나~ : \(ENSettingManager.shared.pressKeyboardCount)")
//        lblTitle.text = "\(ENSettingManager.shared.pressKeyboardCount)"
        
        /// 메인 화면에 처음 들어올 때 키볻를 내리기 위한 조치
        self.inputViewController?.resignFirstResponder()
        // 라이트 모드 고정
        overrideUserInterfaceStyle = .light
        
        // 헤더 버튼 핸들러 연결
        headerButtonHandlerSetting()
        // 탭 버튼 핸들러 연결
        tabButtonHandlerSetting()
        
        // 테이블 뷰 및 스크롤 뷰 딜리게이트 전달
        defaultSettingTable.delegate = self
        defaultSettingTable.dataSource = self
        toolbarSettingTable.delegate = self
        toolbarSettingTable.dataSource = self
        contentScrollView.delegate = self
        scrollViewToolbar.delegate = self
        
        // 메인에 들어가는 기본설정, 툴바, 테마, 더보기 UI 세팅 함수 호출
        defaultSettingTableSetting()
        toolbarSettingTableSetting()
        themeViewSettingUI()
        moreViewSettingUI()
        
        // 키보드 샘플 뷰 init 호출
        initKeyboardView()
        
        // 툴바 UI 세팅
        viewToolbarWrapper.layer.borderWidth = 1
        viewToolbarWrapper.layer.borderColor = UIColor(red: 24/255, green: 110/255, blue: 245/255, alpha: 1).cgColor
        viewToolbarWrapper.layer.cornerRadius = 30
        viewToolbarWrapper.isHidden = true
        
        // 툴바 데이터 리로드
        toolbarReload()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 키보드가 올라왔을 때 화면 처리
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUpNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDownNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 키보드에서 자주쓰는 메모 편집을 눌렀을 때 처리
        if isUserMemoEdit {
            let vc = ENMemoDetailViewController.create()
            vc.eNMainViewControllerDelegate = self
            self.enPresent(vc, animated: true)
        }
        
        // 처음 사용자인지가 true 이면 튜툐리얼을 보여준다.
        if ENSettingManager.shared.isFirstUser {
            let vc = ENTutorialViewController.create()
            self.enPresent(vc, animated: true)
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 키보드가 올라왔을 때 화면 처리 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    /// 헤더 뷰의 버튼 핸들러 연결
    /// - 백버튼, 키보드 show & hide 버튼
    func headerButtonHandlerSetting() {
        btnBack.addTarget(self, action: #selector(btnBackHandler(_:)), for: .touchUpInside)
        btnKeyboard.addTarget(self, action: #selector(btnKeyboardHandler(_:)), for: .touchUpInside)
    }
    
    /// 페이지 이동 함수
    ///  - 탭 버튼을 클릭했을 때 호출함.
    func movePage(page: Int) {
        let pageWidth = Int(UIScreen.main.bounds.size.width)
        contentScrollView.scrollRectToVisible(CGRect.init(x: pageWidth * page, y: 0, width: pageWidth, height: 100), animated: true)
        
        notifyChangePage(page: page)
    }
    
    /// 페이지 변화에 대한 noti 함수
    ///  - 탭 버튼을 클릭 후 페이지 전환에 noti 를 줌.
    ///  - 툴바의 유무
    func notifyChangePage(page: Int) {
        switch page {
        case 0:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showAndHideTopToolbarView(flag: false)
                self.isShowingThemeView = false
            }
            break
        case 1:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showAndHideTopToolbarView(flag: true)
                self.isShowingThemeView = false
            }
            break
        case 2:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showAndHideTopToolbarView(flag: false)
                self.isShowingThemeView = true
            }
            break
        case 3:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showAndHideTopToolbarView(flag: false)
                self.isShowingThemeView = false
            }
            break
        default:
            break
        }
        
        if self.keyboardSampleViewHeightConstraint.constant > 0 {
            self.hideKeyboardPreview()
            UIView.transition(with: self.btnKeyboard, duration: 0.2, options: .transitionFlipFromTop , animations: { [weak self] in
                guard let self else { return }
                self.btnKeyboard.setImage(UIImage.init(named: "header_keyboard_up", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
            })
        }
        
        if self.textFieldTemp.isFirstResponder {
            self.textFieldTemp.resignFirstResponder()
            
            UIView.transition(with: self.btnKeyboard, duration: 0.2, options: .transitionFlipFromTop , animations: { [weak self] in
                guard let self else { return }
                self.btnKeyboard.setImage(UIImage.init(named: "header_keyboard_up", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
            })
        }
        
    }
    
    /// 툴바의 Show & Hide 함수
    /// - Parameters:
    ///   - flag : true 는 Show, false 는 Hide
    func showAndHideTopToolbarView(flag: Bool) {
        if flag {
            UIView.transition(with: self.viewToolbarWrapper, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
                guard let self else { return }
                self.viewToolbarWrapper.isHidden = false
            })
        } else {
            UIView.transition(with: self.viewToolbarWrapper, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
                guard let self else { return }
                self.viewToolbarWrapper.isHidden = true
            })
        }
    }
    
    /// 탭 버튼 선택했을 때 UI 변경
    /// - Parameters:
    ///  - targetButton: 변경 될 UIButton
    func selectTabButton(targetButton: UIButton) {
        UIView.transition(with: targetButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            targetButton.layer.cornerRadius = 20
            targetButton.layer.borderColor = UIColor(red: 241/255, green: 244/255, blue: 245/255, alpha: 1).cgColor
            targetButton.layer.borderWidth = 1
            targetButton.backgroundColor = UIColor(red: 241/255, green: 244/255, blue: 245/255, alpha: 1)
        })
    }
    
    /// 탭 버튼 UI 초기화
    func resetTapButton() {
        btnDefaultSetting.layer.borderColor = UIColor.white.cgColor
        btnDefaultSetting.layer.borderWidth = 0
        btnDefaultSetting.backgroundColor = .white
        
        btnToolbarSetting.layer.borderColor = UIColor.white.cgColor
        btnToolbarSetting.layer.borderWidth = 0
        btnToolbarSetting.backgroundColor = .white
        
        btnThemeSetting.layer.borderColor = UIColor.white.cgColor
        btnThemeSetting.layer.borderWidth = 0
        btnThemeSetting.backgroundColor = .white
        
        btnMoreSetting.layer.borderColor = UIColor.white.cgColor
        btnMoreSetting.layer.borderWidth = 0
        btnMoreSetting.backgroundColor = .white
    }
    
    /// 탭 버튼 핸들러 연결
    /// - 기본 선택으로 selectTabButton(targetButton: btnDefaultSetting) 호출 함
    private func tabButtonHandlerSetting() {
        btnDefaultSetting.addTarget(self, action: #selector(tabButtonHandler(_:)), for: .touchUpInside)
        btnToolbarSetting.addTarget(self, action: #selector(tabButtonHandler(_:)), for: .touchUpInside)
        btnThemeSetting.addTarget(self, action: #selector(tabButtonHandler(_:)), for: .touchUpInside)
        btnMoreSetting.addTarget(self, action: #selector(tabButtonHandler(_:)), for: .touchUpInside)
        
        selectTabButton(targetButton: btnDefaultSetting)
    }

    // MARK: - selector 함수
    /// 키보드 올라 왔을 때 화면 조정
    @objc func keyboardUpNotification(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self else { return }
                self.keyboardSampleViewHeightConstraint.constant = ENSettingManager.shared.getKeyboardHeight(isLandcape: false)
            })
        }
    }
    /// 키보드 내려 갔을 때 화면 조정
    @objc func keyboardDownNotification(notification: NSNotification) {
        self.view.transform = .identity
    }
    
    /// 상단 탭 버튼 핸들러
    @objc func tabButtonHandler(_ sender: UIButton) {
        resetTapButton()
        selectTabButton(targetButton: sender)
        movePage(page: sender.tag)
    }
    
    /// 백버튼 핸들러
    @objc func btnBackHandler(_ sender: UIButton) {
        enDismiss()
    }
    
    /// 키보드 Show & Hide 핸들러
    /// 테마 쪽일 때는 테마가 적용 되는 샘플 뷰를 띄워야 하기 때문에 다르게 둠
    @objc func btnKeyboardHandler(_ sender: UIButton) {
        if isShowingThemeView {
            
            textFieldTemp.resignFirstResponder()
            
            if keyboardSampleViewHeightConstraint.constant != 0 {
                UIView.transition(with: self.btnKeyboard, duration: 0.2, options: .transitionFlipFromTop , animations: { [weak self] in
                    guard let self else { return }
                    self.btnKeyboard.setImage(UIImage.init(named: "header_keyboard_up", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
                })
                hideKeyboardPreview()
            } else {
                UIView.transition(with: self.btnKeyboard, duration: 0.2, options: .transitionFlipFromBottom , animations: { [weak self] in
                    guard let self else { return }
                    self.btnKeyboard.setImage(UIImage.init(named: "header_keyboard_down", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
                })
                showDefaultKeyboardPreview()
            }
        } else {
            
            keyboardSampleViewHeightConstraint.constant = 0
            
            if textFieldTemp.isFirstResponder {
                UIView.transition(with: self.btnKeyboard, duration: 0.2, options: .transitionFlipFromTop , animations: { [weak self] in
                    guard let self else { return }
                    self.btnKeyboard.setImage(UIImage.init(named: "header_keyboard_up", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
                })
                textFieldTemp.resignFirstResponder()
            } else {
                UIView.transition(with: self.btnKeyboard, duration: 0.2, options: .transitionFlipFromBottom , animations: { [weak self] in
                    guard let self else { return }
                    self.btnKeyboard.setImage(UIImage.init(named: "header_keyboard_down", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
                })
                textFieldTemp.becomeFirstResponder()
            }
        }
    }
    
    // 테마 적용 핸들러
    @IBAction func btnThemeApplyHandler(_ sender: UIButton) {
        var selectedTheme: ENKeyboardThemeModel? = nil
        if let presenter = (contentPresenter?.contentPresenter as? ENThemeRecommandPresenter) {
            selectedTheme = presenter.selectedTheme
        }
        
        if let presenter = (contentPresenter?.contentPresenter as? ENThemeCategoryPresenter) {
            selectedTheme = presenter.selectedTheme
        }
        
        if let presenter = (contentPresenter?.contentPresenter as? ENMyThemeContentViewPresenter) {
            selectedTheme = presenter.selectedTheme
        }
        
        if let theme = selectedTheme {
            self.showProgressView(with: "테마 적용중")
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] timer in
                guard let self else { return }
                
                timer.invalidate()
                
                ENSettingManager.shared.isUsePhotoTheme = false
//                self.isUsePhotoThemeForRestore = false
                
                ENKeyboardThemeManager.shared.saveSelectedThemeInfo(theme: theme)
                self.saveThemeAtMyTheme(theme: theme)
                
                if let presenter = (self.contentPresenter?.contentPresenter as? ENThemeRecommandPresenter) {
                    presenter.updateSelectedThemeDataTo(isOwn: true)
                }
                
                if let presenter = (self.contentPresenter?.contentPresenter as? ENThemeCategoryPresenter) {
                    presenter.updateSelectedThemeDataTo(isOwn: true)
                }
                
                self.hideProgressView(completion: {
                    self.hideKeyboardPreview()
                })
            }
        } else {
            hideKeyboardPreview()
        }
    }
    
    // 테마 닫기 핸들러
    @IBAction func btnThemeCloseHandler(_ sender: UIButton) {
//        ENSettingManager.shared.isUsePhotoTheme = isUsePhotoThemeForRestore
        hideKeyboardPreview()
    }
}
