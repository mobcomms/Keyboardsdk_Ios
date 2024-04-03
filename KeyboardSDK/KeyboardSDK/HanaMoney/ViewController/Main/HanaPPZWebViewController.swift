//
//  HanaPPZWebViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 11/21/23.
//

import Foundation
import WebKit
import KeyboardSDKCore

public class HanaPPZWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate, ENViewPrsenter {
    public static func create() -> HanaPPZWebViewController {
        let vc = HanaPPZWebViewController.init(nibName: "HanaPPZWebViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    var isRoad: Bool = false
    var isMove: Bool = false

    @IBOutlet weak var viewFrame: UIView!
    
    @IBOutlet weak var constraintBridgeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tempView: UIView!
    
    var webView: WKWebView = WKWebView()
    
    let webCfg: WKWebViewConfiguration = WKWebViewConfiguration()
    public override func loadView() {
        super.loadView()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
//        if #available(iOS 16.4, *) {
//            self.webView.isInspectable = true
//        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        constraintBridgeHeight.constant = 0
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// 다른 화면에서 다시 돌아올 때 딜리게이트를 주지 않으면 얼럿이 뜨지 않음...
        webView.scrollView.delegate = self
        webView.uiDelegate = self
        webView.navigationDelegate = self

    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        webView.scrollView.delegate = nil
//        webView.uiDelegate = nil
//        webView.navigationDelegate = nil
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isRoad == false {
            isRoad = true
            
            webCfg.websiteDataStore = WKWebsiteDataStore.default()
            webCfg.preferences.javaScriptEnabled = true
            webCfg.preferences.javaScriptCanOpenWindowsAutomatically = true
            webCfg.selectionGranularity = .character
            
            webCfg.processPool = WKProcessPool()
            
            webView = WKWebView(frame: CGRect(x: viewFrame.bounds.origin.x,
                                              y: viewFrame.bounds.origin.y,
                                              width: UIScreen.main.bounds.width,
                                              height: tempView.frame.height),
                                configuration: webCfg)
            
            webView.isOpaque = false
            webView.backgroundColor = UIColor.white
            webView.scrollView.backgroundColor = UIColor.clear
            webView.scrollView.delegate = self
            webView.uiDelegate = self
            webView.navigationDelegate = self

            webView.scrollView.bounces = false
            
            webView.insetsLayoutMarginsFromSafeArea = false
            
            webView.allowsBackForwardNavigationGestures = true
            
            viewFrame.addSubview(webView)
            
            if let url = URL(string: ENAPIConst.PlusPointZoneURL ) {
                #if DEBUG
                print("url 이다 : \(url.absoluteString)")
                #endif

                self.webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10))
            }
        }
    }
    
    @IBAction func btnBridgeHeaderBack(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func btnBridgeHeaderClose(_ sender: Any) {
        enDismiss()
    }
    
    @IBAction func btnMainClose(_ sender: Any) {
        enDismiss()
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        print("webView didCommit url :: \(webView.url?.absoluteString)")

//        let apiUrl = "common/getAccessToken"
//        let parameter = ["media_id" : "hanamembership"]
//        let token = "eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2OTgxMDkxNDB9.99xqC-IUNylT6PYmdxzX9VEPBBNjvu-IisR8tenRy_g"
//        
//        URLUtil().customCallApi(url: apiUrl, method: .GET, parameters: parameter, token: token) { data, response, error in
//            print("common token api")
//            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
//                print("data : \(jsonString)")
//                if let jsonData = jsonString.data(using: .utf8) {
//                    do {
//                        let data = try JSONDecoder().decode(PPZTokenModel.self, from: jsonData)
//                        
//                        print("Result : \(data.result)")
//                        print("Token : \(data.token)")
//                        
//                    } catch {
//                        print("json parse error : \(error)")
//                    }
//                } else {
//                    print("invalid json data")
//                }
//            }
//            
//            if let res = response {
//                print("res : \(res)")
//            }
//            
//            if let error = error {
//                print("error : \(error)")
//            }
//        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("webView didFinish")
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        print("webView didFail")
    }
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//        print("webView createWebViewWith url : \(navigationAction.request.url!.absoluteString)")

        if navigationAction.targetFrame == nil {
//            webView.load(navigationAction.request)
            if let url = URL(string: navigationAction.request.url!.absoluteString) {
                self.isMove = true
                self.webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10))
            }
        }
        
        return nil
    }
    
    // javascript alert method
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler()
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // javascript confirm method
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
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
    
    // 로드 되기 전 url 허가 받는 곳
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let requestURL = navigationAction.request.url else { return }
        
        let url = requestURL.absoluteString
        let hostAddress = navigationAction.request.url?.host ?? ""
        #if DEBUG
        print("hostAddress: \(hostAddress)")
        print("url : \(url)")
        #endif
        print("url : \(url)")

        if url.contains("bridge") {
            constraintBridgeHeight.constant = 50
        } else if !url.contains("pomission.com") {
            constraintBridgeHeight.constant = 50
        }else {
            constraintBridgeHeight.constant = isMove ? 50  : 0
        }
        isMove = false

        if !hostAddress.contains("pomission.com") {
            decisionHandler(.cancel)
            if let otherUrl = URL(string: url) {
                self.open(url: otherUrl)
            }
        } else {
            decisionHandler(.allow)
        }
        return
    }
    
    // 중복적으로 리로드가 일어나지 않도록 처리 필요.
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    fileprivate func clearCache() {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
