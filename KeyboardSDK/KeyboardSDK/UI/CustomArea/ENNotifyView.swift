//
//  ENNotifyView.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/20.
//
import Foundation
import WebKit
import KeyboardSDKCore
import AdSupport
protocol ENNotifyViewDelegate: AnyObject {
    /// 최 상단 노티 뷰 가리기
    func adViewClose()
    func openOtherBrowser(url: String)
    func moveToNewsLink(url: String)
    func canOpenURL(url:String) -> Bool
}

/// 최 상단 공지 뷰
///  - 이 부분은 툴바 상단 부분에 보여지는 뷰
class ENNotifyView: UIView, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    var newsList: [NewsItem]?
    var currentNewsIndex = 0
    
    var newsTimer: Timer?
    
    lazy var newsView: UIView = {
        let inner: UIView = UIView()
        inner.backgroundColor = UIColor(red: 70/255, green: 79/255, blue: 84/255, alpha: 1)
        return inner
    }()
    
    lazy var btnNews: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        btn.setTitle("뉴스가 없습니다.", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.titleLabel?.textAlignment = .left
        btn.contentHorizontalAlignment = .left
        btn.backgroundColor = .clear
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    lazy var innerADView: UIView = {
        let inner: UIView = UIView()
        inner.backgroundColor = UIColor(red: 238/255, green: 231/255, blue: 238/255, alpha: 1)
        
        return inner
    }()
    
    var webView: WKWebView = WKWebView()
    lazy var leftView: UIView = {
        let leftView: UIView = UIView()
        leftView.backgroundColor = .white
        
        return leftView
    }()
    
    lazy var container: UIView = {
        let container: UIView = UIView()
        container.backgroundColor = .white
        
        return container
    }()
    
    lazy var btnClose: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        btn.setTitle("X", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .lightGray
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        return btn
    }()
    var btnCloseHeightConstraint: NSLayoutConstraint?
    
    lazy var lblPoint: UILabel = {
        let lbl: UILabel = UILabel()
        return lbl
    }()
    
    lazy var btnPoint: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        return btn
    }()
    
    weak var delegate: ENNotifyViewDelegate?
    var heightConstraint: NSLayoutConstraint?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    func initLayout() {
        // 현재 뷰 세팅
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // 뉴스 뷰 세팅
        self.addSubview(newsView)
        newsView.translatesAutoresizingMaskIntoConstraints = false
        newsView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        newsView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        newsView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        newsView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        newsView.addSubview(btnNews)
        btnNews.translatesAutoresizingMaskIntoConstraints = false
        btnNews.leadingAnchor.constraint(equalTo: newsView.leadingAnchor, constant: 13).isActive = true
        btnNews.trailingAnchor.constraint(equalTo: newsView.trailingAnchor, constant: -13).isActive = true
        btnNews.topAnchor.constraint(equalTo: newsView.topAnchor).isActive = true
        btnNews.bottomAnchor.constraint(equalTo: newsView.bottomAnchor).isActive = true
        
        btnNews.addTarget(self, action: #selector(btnNewshandler(_:)), for: .touchUpInside)
        
        // 광고 웹뷰 쪽 세팅
        self.addSubview(innerADView)
        innerADView.translatesAutoresizingMaskIntoConstraints = false
        innerADView.layer.addBorder([.top, .bottom], color: UIColor(red: 218/255, green: 219/255, blue: 224/255, alpha: 1), width: 1.0)
        innerADView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        innerADView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        innerADView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        heightConstraint = innerADView.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint?.isActive = true
        
        innerADView.addSubview(leftView)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        leftView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        leftView.topAnchor.constraint(equalTo: innerADView.topAnchor).isActive = true
        //        leftView.bottomAnchor.constraint(equalTo: innerADView.bottomAnchor).isActive = true
        leftView.trailingAnchor.constraint(equalTo: innerADView.trailingAnchor).isActive = true
        
        innerADView.addSubview(btnClose)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.widthAnchor.constraint(equalToConstant: 15).isActive = true
        btnClose.topAnchor.constraint(equalTo: leftView.topAnchor).isActive = true
        btnClose.trailingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
        btnCloseHeightConstraint = btnClose.heightAnchor.constraint(equalToConstant: 15)
        btnCloseHeightConstraint?.isActive = true
        
        innerADView.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        container.leadingAnchor.constraint(equalTo: innerADView.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: leftView.leadingAnchor).isActive = true
        container.topAnchor.constraint(equalTo: innerADView.topAnchor).isActive = true
        //        webView.bottomAnchor.constraint(equalTo: innerADView.bottomAnchor).isActive = true
        
        btnClose.addTarget(self, action: #selector(btnCloseHandler(_:)), for: .touchUpInside)
        
        
        
        loadNewsData()
        webViewSetting()
    }
    
    func loadNewsData() {
        ENKeyboardAPIManeger.shared.getNews {[weak self] data, response, error in
            guard let self = self else { return }
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(NewsArray.self, from: jsonData)
                        if !data.newsList.isEmpty {
                            newsList = data.newsList
                            if let list = newsList {
                                DispatchQueue.main.async {
                                    self.currentNewsIndex = 0
                                    self.btnNews.setTitle(list[self.currentNewsIndex].news_title, for: .normal)
                                    if self.newsTimer == nil {
                                        self.newsTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.updateNewsTitle), userInfo: nil, repeats: true)
                                    }
                                }
                            }
                        }
                    } catch {
                        print("new api error : \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    @objc func updateNewsTitle() {
        if let list = newsList {
            let itemCount = list.count
            
            if itemCount > 0 {
                UIView.transition(with: btnNews, duration: 0.2, options: .transitionFlipFromBottom, animations: { [weak self] in
                    guard let self = self else { return }
                    self.btnNews.setTitle(list[self.currentNewsIndex].news_title, for: .normal)
                })
                
                currentNewsIndex += 1
                
                if currentNewsIndex >= itemCount {
                    currentNewsIndex = 0
                }
            }
        }
    }
    
    @objc func btnNewshandler(_ sender: UIButton) {
        if let list = newsList {
            if currentNewsIndex < list.count {
                if let del = delegate {
                    if currentNewsIndex > 0 {
                        currentNewsIndex = currentNewsIndex - 1
                    }
                    
                    del.moveToNewsLink(url: list[currentNewsIndex].link_url)
                }
            }
        }
    }
    
    func loadBannerPoint() {
        
        ENKeyboardAPIManeger.shared.getBannerPoint(isMainBanner: true) {[weak self] data, response, error in
            guard let self = self else { return }
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
#if DEBUG
                print("data : \(jsonString)")
#endif
                
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(ENRewardCheckMainModel.self, from: jsonData)
                        DispatchQueue.main.async {
                            self.settingAdPoint(rewardFlag: data.reward, rewardPoint: data.reward_point)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.settingAdPoint(rewardFlag: "false", rewardPoint: "")
                        }
                        print("json parse error : \(error.localizedDescription)")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.settingAdPoint(rewardFlag: "false", rewardPoint: "")
                    }
                    print("invalid json data")
                }
            }
            
            if let error = error {
                
            }
        }
    }
    
    func settingAdPoint(rewardFlag: String, rewardPoint: String) {
        btnPoint.removeFromSuperview()
        if rewardFlag == "true" {
            btnPoint.setTitle("+\(rewardPoint)", for: .normal)
            btnPoint.setTitleColor(UIColor(red: 94/255, green: 80/255, blue: 80/255, alpha:1), for: .normal)
            btnPoint.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
            btnPoint.setBackgroundImage(UIImage.init(named: "cashwalkReadyPoint", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)

        } else {
            btnPoint.setBackgroundImage(UIImage.init(named: "cashwalkAdPointCheck", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
            btnPoint.backgroundColor = .clear
        }
        
        innerADView.addSubview(btnPoint)
        
        btnPoint.translatesAutoresizingMaskIntoConstraints = false
        btnPoint.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btnPoint.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnPoint.trailingAnchor.constraint(equalTo: btnClose.leadingAnchor, constant: -4).isActive = true

        btnPoint.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        
        if rewardFlag == "true" {
            btnPoint.layer.cornerRadius = 30 / 2
        }
    }
    func webViewSetting() {
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        webCfg.websiteDataStore = WKWebsiteDataStore.default()
        webCfg.preferences.javaScriptEnabled = true
        webCfg.preferences.javaScriptCanOpenWindowsAutomatically = true
        webCfg.selectionGranularity = .character
        webView = WKWebView(frame: container.bounds, configuration: webCfg)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        webView.isOpaque = false
        webView.backgroundColor = .white
        
        webView.scrollView.delegate = self
        loadWebview()
    }
    func loadWebview(){
        let url = URL(string:ENAPIConst.AD_Main_Banner)!
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)) // 캐싱 사용하지 않도록 설정
        loadBannerPoint()
    }
    func addWebView(){
        webView.frame =  CGRect.init(x: 0, y: 0, width: self.container.frame.width, height: self.container.frame.height)
        
        self.layoutIfNeeded()
        self.container.addSubview(self.webView)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    /// 상단 공지사항을 가로, 세로에 따라 위치 값을 조정한다.
    func updateNotifyView(isLand: Bool) {
        if isLand {
            self.heightConstraint?.constant = 0
            webView.removeFromSuperview()
            innerADView.removeFromSuperview()
            newsView.removeFromSuperview()
            newsTimer?.invalidate()
            newsTimer = nil
            self.removeFromSuperview()
        }else{
            initLayout()
            addWebView()

        }
    }
    
    @objc func btnCloseHandler(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.adViewClose()
        }
    }
    func callSendRewardPoint(url:String){
        ENKeyboardAPIManeger.shared.callSendRewardPoint(ENAPIConst.ZONE_ID_MAIN) {[weak self] data, response, error in
            guard let self = self else { return }
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(ENSendRewardZonePointModel.self, from: jsonData)
                        if data.Result == "true" {
                            ENSettingManager.shared.zoneToastMsg = data.message ?? "리워드 포인트 당첨!"
                            DispatchQueue.main.async {
                                self.btnPoint.setBackgroundImage(UIImage.init(named: "cashwalkAdPointCheck", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
                                self.btnPoint.backgroundColor = .clear
                                self.btnPoint.setTitle("", for: .normal)
                                self.btnPoint.layer.cornerRadius = 0
                                if url.hasPrefix("tel:"){
                                    self.loadWebview()
                                    if let supView = self.superview {
                                        if let supsupView = supView.superview {
                                            if ENSettingManager.shared.zoneToastMsg != ""{
                                                supsupView.showEnToast(message:ENSettingManager.shared.zoneToastMsg)
                                                ENSettingManager.shared.zoneToastMsg = ""
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            ENSettingManager.shared.zoneToastMsg = data.errstr ?? "사용자 정보를 확인할 수 없어요. 캐시워크 앱에서 인증해 주세요."
                            
                        }
                        
                    } catch {
                        print("json parse error")
                    }
                } else {
                    print("not invalid jsonData")
                }
            } else {
                print("not invalid data & jsonString")
            }
            
            if let err = error {
                
            }
        }
    }
}

extension ENNotifyView {
    // html a tag target
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if var urlString = navigationAction.request.url?.absoluteString, urlString.count > 0{
            if let delegates = self.delegate {
                ///딥링크 이동 이슈 대응
                ///canOpenURL 함수로 이동이 가능하면 포인트를 지급하도록
                ///이동이 불가능하면 토스트 메시지 노출 후 광고 다시 로드
                if delegates.canOpenURL(url: urlString) {
                    self.callSendRewardPoint(url: urlString)
                }else{
                    DispatchQueue.main.async {
                        self.loadWebview()
                        if let supView = self.superview {
                            if let supsupView = supView.superview {
                                supsupView.showEnToast(message: "다시 시도해주세요.")
                            }
                        }
                        
                    }
                }
            }
            
        }
        
        return nil
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        return
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

struct ENRewardCheckMainModel: Codable{
    let reward: String
    let reward_point: String
    let brand: String
    let brand_point: String
}

struct NewsItem: Codable {
    let news_title: String
    let link_url: String
    let news_img_url: String
    let object_id: String
    let site_name: String
    let root_domain: String
    let pub_date: String
    let category_code: String
}

struct NewsArray: Codable {
    let Result: String
    let newsList: [NewsItem]
}

struct ENSendRewardZonePointModel: Codable {
    let Result: String
    let message: String?
    let errcode: String?
    let errstr: String?
}
