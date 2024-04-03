//
//  HanaKeyboardInquiryViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 12/19/23.
//

import Foundation
import WebKit
import KeyboardSDKCore

class HanaKeyboardInquiryViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate, WKScriptMessageHandler {
    
    public static func create() -> HanaKeyboardInquiryViewController {
        let vc = HanaKeyboardInquiryViewController.init(nibName: "HanaKeyboardInquiryViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    @IBOutlet weak var viewWebViewFrame: UIView!
    
    var webView: WKWebView = WKWebView()
    
    var isRoad: Bool = false
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //print("viewFrame: \(viewWebViewFrame.bounds)")
        //print("viewFrame: \(viewWebViewFrame.frame)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isRoad == false {
            isRoad = true
            let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
            let userController: WKUserContentController = WKUserContentController()
            userController.add(self, name: "fcmRegister")
            webCfg.websiteDataStore = WKWebsiteDataStore.default()
            webCfg.preferences.javaScriptEnabled = true
            webCfg.preferences.javaScriptCanOpenWindowsAutomatically = true
            webCfg.selectionGranularity = .character
            webCfg.userContentController = userController
            
            webView = WKWebView(frame: viewWebViewFrame.bounds, configuration: webCfg)
            webView.backgroundColor = .white
            
            webView.uiDelegate = self
            webView.navigationDelegate = self
            
            webView.isOpaque = false
            webView.backgroundColor = .clear
            
            webView.scrollView.delegate = self
            
            viewWebViewFrame.addSubview(webView)
            webViewLoad()
        }
    }
    func webViewLoad(){

        if ENSettingManager.shared.hanaCustomerID == "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.webViewLoad()
            })

            return
        }
        
        let url = URL(string: ENAPIConst.InquiryURL)!
        
        // 캐싱 사용하지 않도록 설정
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10))

    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        #if DEBUG
        print("userContent message: \(message.name): \(message.body)")
        #endif
        
        if message.name == "fcmRegister" {
            let dict = message.body as! [String: AnyObject]
            let funcName = dict["funcName"] as! String
            
            if funcName == "showMessage" {
                let msg = dict["msg"] as? String ?? "메세지 형식이 올바르지 않습니다."
                
                let alert = UIAlertController(title: "문의 하기", message: "\(msg)", preferredStyle: .alert)
                
                let confirmAction = UIAlertAction(title: "닫기", style: .default) {[weak self] action in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                }
                
                alert.addAction(confirmAction)
                
                self.present(alert, animated: false, completion: nil)
            } else {
                let msg = "데이터 내용이 올바르지 않습니다. 다시 시도해 주세요."
                
                let alert = UIAlertController(title: "문의 하기", message: "\(msg)", preferredStyle: .alert)
                
                let confirmAction = UIAlertAction(title: "닫기", style: .default) {[weak self] action in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: true)
                    }
                }
                
                alert.addAction(confirmAction)
                
                self.present(alert, animated: false, completion: nil)
            }
        } else {
            let msg = "데이터가 올바르지 않습니다. 다시 시도해 주세요."
            
            let alert = UIAlertController(title: "문의 하기", message: "\(msg)", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "닫기", style: .default) {[weak self] action in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
            
            alert.addAction(confirmAction)
            
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @IBAction func btnCloseHandler(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

extension HanaKeyboardInquiryViewController {
//     html a tag target
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        #if DEBUG
        print("webview load finish : \(webView.url?.absoluteString ?? "nil")")
        #endif
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        return
    }
    
    // javascript alert method
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler()
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // javascript confirm method
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in
            completionHandler(false)
        }
        let okAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            completionHandler(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
