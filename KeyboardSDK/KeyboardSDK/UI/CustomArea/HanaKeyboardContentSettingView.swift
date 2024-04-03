//
//  HanaKeyboardContentSettingView.swift
//  KeyboardSDK
//
//  Created by ximAir on 10/26/23.
//

import Foundation
import WebKit
import KeyboardSDKCore

protocol HanaKeyboardContentSettingViewDelegate: AnyObject {
    func openTheme()
    func openClipBoard()
    func openSetting()
    func openInquiry()
    func openOtherBrowser(url: String)
    func canOpenURL(url:String) -> Bool

}

class HanaKeyboardContentSettingView: UIView, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    lazy var clipBoardView: UIView = {
        let innerView: UIView = UIView()
        innerView.backgroundColor = .clear
        return innerView
    }()
    
    lazy var settingView: UIView = {
        let innerView: UIView = UIView()
        innerView.backgroundColor = .clear
        return innerView
    }()
    
    lazy var imgClipBoard: UIImageView = {
        let img: UIImageView = UIImageView()
        img.image = UIImage.init(named: "hana_content_clipboard", in: Bundle.frameworkBundle, compatibleWith: nil)
        return img
    }()
    
    lazy var imgSetting: UIImageView = {
        let img: UIImageView = UIImageView()
        img.image = UIImage.init(named: "hana_content_setting", in: Bundle.frameworkBundle, compatibleWith: nil)
        return img
    }()

    lazy var lblClipBoard: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.text = "클립보드"
        lbl.font = .systemFont(ofSize: 12)
        return lbl
    }()
    
    lazy var lblSetting: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.text = "설정"
        lbl.font = .systemFont(ofSize: 12)
        return lbl
    }()
    
    lazy var inquiryView: UIView = {
        let innerView: UIView = UIView()
        innerView.backgroundColor = .clear
        return innerView
    }()
    lazy var imgInquiry: UIImageView = {
        let img: UIImageView = UIImageView()
        img.image = UIImage.init(named: "hana_inquiry", in: Bundle.frameworkBundle, compatibleWith: nil)
        return img
    }()
    lazy var lblInquiry: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.text = "문의하기"
        lbl.font = .systemFont(ofSize: 12)
        return lbl
    }()
    
    lazy var innerADView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .white
        return view
    }()
    lazy var leftView: UIView = {
        let leftView: UIView = UIView()
        leftView.backgroundColor = .white
        return leftView
    }()
    
    var webView: WKWebView = WKWebView()
    
    lazy var btnClose: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        btn.setTitle("X", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .lightGray
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        
        return btn
    }()
    
    lazy var btnPoint: UIButton = {
        let btn: UIButton = UIButton(type: .custom)
        return btn
    }()
    
    weak var delegate: HanaKeyboardContentSettingViewDelegate? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        settingViewConstraint()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingViewConstraint()
    }
    
    private func settingViewConstraint() {        
        self.backgroundColor = UIColor(red: 37/255, green: 46/255, blue: 51/255, alpha: 1)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        self.addSubview(clipBoardView)
        clipBoardView.translatesAutoresizingMaskIntoConstraints = false
        clipBoardView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        clipBoardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22).isActive = true
        clipBoardView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        clipBoardView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        clipBoardView.addSubview(imgClipBoard)
        imgClipBoard.translatesAutoresizingMaskIntoConstraints = false
        imgClipBoard.widthAnchor.constraint(equalToConstant: 52).isActive = true
        imgClipBoard.heightAnchor.constraint(equalToConstant: 52).isActive = true
        imgClipBoard.centerXAnchor.constraint(equalTo: clipBoardView.centerXAnchor).isActive = true
        imgClipBoard.centerYAnchor.constraint(equalTo: clipBoardView.centerYAnchor).isActive = true
        
        self.addSubview(lblClipBoard)
        lblClipBoard.translatesAutoresizingMaskIntoConstraints = false
        lblClipBoard.widthAnchor.constraint(equalToConstant: 70).isActive = true
        lblClipBoard.topAnchor.constraint(equalTo: clipBoardView.bottomAnchor).isActive = true
        lblClipBoard.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22).isActive = true
        
        let clipBoardViewTap = UITapGestureRecognizer(target: self, action: #selector(contentViewTapHandler(_:)))
        clipBoardView.tag = 1
        clipBoardView.addGestureRecognizer(clipBoardViewTap)
        // end of 클립보드 view
        
        self.addSubview(inquiryView)
        inquiryView.translatesAutoresizingMaskIntoConstraints = false
        inquiryView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        inquiryView.leadingAnchor.constraint(equalTo: self.clipBoardView.trailingAnchor, constant: 12).isActive = true
        inquiryView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        inquiryView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        inquiryView.addSubview(imgInquiry)
        imgInquiry.translatesAutoresizingMaskIntoConstraints = false
        imgInquiry.widthAnchor.constraint(equalToConstant: 52).isActive = true
        imgInquiry.heightAnchor.constraint(equalToConstant: 52).isActive = true
        imgInquiry.centerXAnchor.constraint(equalTo: inquiryView.centerXAnchor).isActive = true
        imgInquiry.centerYAnchor.constraint(equalTo: inquiryView.centerYAnchor).isActive = true
        
        self.addSubview(lblInquiry)
        lblInquiry.translatesAutoresizingMaskIntoConstraints = false
        lblInquiry.widthAnchor.constraint(equalToConstant: 70).isActive = true
        lblInquiry.topAnchor.constraint(equalTo: inquiryView.bottomAnchor).isActive = true
        lblInquiry.leadingAnchor.constraint(equalTo: clipBoardView.trailingAnchor, constant: 12).isActive = true
        
        let inquiryViewTap = UITapGestureRecognizer(target: self, action: #selector(contentViewTapHandler(_:)))
        inquiryView.tag = 2
        inquiryView.addGestureRecognizer(inquiryViewTap)
        // end of 문의하기 view
        
        self.addSubview(settingView)
        settingView.translatesAutoresizingMaskIntoConstraints = false
        settingView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        settingView.leadingAnchor.constraint(equalTo: inquiryView.trailingAnchor, constant: 12).isActive = true
        settingView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        settingView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        settingView.addSubview(imgSetting)
        imgSetting.translatesAutoresizingMaskIntoConstraints = false
        imgSetting.widthAnchor.constraint(equalToConstant: 52).isActive = true
        imgSetting.heightAnchor.constraint(equalToConstant: 52).isActive = true
        imgSetting.centerXAnchor.constraint(equalTo: settingView.centerXAnchor).isActive = true
        imgSetting.centerYAnchor.constraint(equalTo: settingView.centerYAnchor).isActive = true
        
        self.addSubview(lblSetting)
        lblSetting.translatesAutoresizingMaskIntoConstraints = false
        lblSetting.widthAnchor.constraint(equalToConstant: 70).isActive = true
        lblSetting.topAnchor.constraint(equalTo: settingView.bottomAnchor).isActive = true
        lblSetting.leadingAnchor.constraint(equalTo: inquiryView.trailingAnchor, constant: 12).isActive = true
        
        let settingViewTap = UITapGestureRecognizer(target: self, action: #selector(contentViewTapHandler(_:)))
        settingView.tag = 3
        settingView.addGestureRecognizer(settingViewTap)
        // end of 설정 view
        
        self.addSubview(innerADView)
        innerADView.translatesAutoresizingMaskIntoConstraints = false
        innerADView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        innerADView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        innerADView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        innerADView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        innerADView.addSubview(leftView)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        leftView.topAnchor.constraint(equalTo: innerADView.topAnchor).isActive = true
        leftView.bottomAnchor.constraint(equalTo: innerADView.bottomAnchor).isActive = true
        leftView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        innerADView.addSubview(btnClose)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.widthAnchor.constraint(equalToConstant: 15).isActive = true
        btnClose.topAnchor.constraint(equalTo: leftView.topAnchor).isActive = true
        btnClose.trailingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
        btnClose.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        btnClose.addTarget(self, action: #selector(btnCloseHandler(_:)), for: .touchUpInside)
        // 닫기 핸들러 달기
        
        innerADView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: innerADView.leadingAnchor).isActive = true
        webView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 45).isActive = true
        webView.topAnchor.constraint(equalTo: innerADView.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: innerADView.bottomAnchor).isActive = true
        
        loadSettingBannerPoint()
    }
    
    func loadSettingBannerPoint() {
        
        ENKeyboardAPIManeger.shared.getBannerPoint(isMainBanner: false) {[weak self] data, response, error in
            guard let self = self else { return }
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                #if DEBUG
                print("get_reward_chk_set : \(jsonString)")
                #endif

                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(SettingBannerModel.self, from: jsonData)
                        DispatchQueue.main.async {
                            self.settingAdPoint(rewardFlag: data.Result, rewardPoint: data.point)
                        }
                    } catch {
                        print("get_reward_chk_set exception")
                        DispatchQueue.main.async {
                            self.settingAdPoint(rewardFlag: "false", rewardPoint: "")
                        }
                    }
                } else {
                    print("get_reward_chk_set invalid json data")
                    DispatchQueue.main.async {
                        self.settingAdPoint(rewardFlag: "false", rewardPoint: "")
                    }
                }
            }
        }
    }
    func settingAdPoint(rewardFlag: String, rewardPoint: String) {
        btnPoint.removeFromSuperview()
        if rewardFlag == "true" {
            btnPoint.setTitle("+\(rewardPoint)", for: .normal)
            btnPoint.setTitleColor(.white, for: .normal)
            btnPoint.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
            btnPoint.backgroundColor = UIColor(red: 19/255, green: 201/255, blue: 190/255, alpha: 1)
            btnPoint.setImage(nil, for: .normal)
            
        } else {
            btnPoint.setImage(UIImage.init(named: "hanaAdPointCheck", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
            btnPoint.backgroundColor = .clear
        }
        
        innerADView.addSubview(btnPoint)
        
        btnPoint.translatesAutoresizingMaskIntoConstraints = false
        btnPoint.widthAnchor.constraint(equalToConstant: 25).isActive = true
        btnPoint.heightAnchor.constraint(equalToConstant: 25).isActive = true
        btnPoint.trailingAnchor.constraint(equalTo: btnClose.leadingAnchor).isActive = true
        btnPoint.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        
        if rewardFlag == "true" {
            btnPoint.layer.cornerRadius = 25 / 2
        }
    }
    
    
    @objc func contentViewTapHandler(_ sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            switch tag {
            case 0:
                if let delegate = delegate {
                    delegate.openTheme()
                }
            case 1:
                if let delegate = delegate {
                    delegate.openClipBoard()
                }
            case 2:
                if let delegate = delegate {
                    delegate.openInquiry()
                }
            case 3:
                if let delegate = delegate {
                    delegate.openSetting()
                }
            default:
                print("not tag exist")
            }
        }
    }
    
    @objc func btnCloseHandler(_ sender: UIButton) {
        btnClose.removeFromSuperview()
        webView.removeFromSuperview()
        innerADView.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        if webView.bounds.width > 0 {
            webViewSetting()
        }
    }

    func webViewSetting() {
        let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
        webCfg.websiteDataStore = WKWebsiteDataStore.default()
        webCfg.preferences.javaScriptEnabled = true
        webCfg.preferences.javaScriptCanOpenWindowsAutomatically = true
        webCfg.selectionGranularity = .character

        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        
        webView.scrollView.delegate = self
        
        loadWebview()
    }
    func loadWebview(){
        let url = URL(string:ENAPIConst.AD_Sub_Banner)!
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)) // 캐싱 사용하지 않도록 설정
        loadSettingBannerPoint()
    }

    func callSendRewardPoint(url:String){
        ENKeyboardAPIManeger.shared.callSendRewardPoint(ENAPIConst.ZONE_ID_SUB) {[weak self] data, response, error in
            guard let self = self else { return }
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(ENSendRewardZonePointModel.self, from: jsonData)
                        if data.Result == "true" {
                            ENSettingManager.shared.zoneToastMsg = data.message ?? "리워드 포인트 당첨!"

                            DispatchQueue.main.async {
                                self.btnPoint.setImage(UIImage.init(named: "hanaAdPointCheck", in: Bundle.frameworkBundle, compatibleWith: nil), for: .normal)
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
                            print("send_reward_zone_point error code : \(data.errcode ?? "code nil")")
                            print("send_reward_zone_point error String : \(data.errstr ?? "errstr nil")")
                            ENSettingManager.shared.zoneToastMsg = data.errstr ?? "사용자 정보를 확인할 수 없어요. 하나머니 앱에서 인증해 주세요."

                            
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


extension HanaKeyboardContentSettingView {
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

struct SettingBannerModel: Codable {
    let Result: String
    let point: String
}
