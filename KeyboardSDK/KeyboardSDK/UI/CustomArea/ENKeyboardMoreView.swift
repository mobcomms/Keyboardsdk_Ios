//
//  ENKeyboardMoreView.swift
//  KeyboardSDK
//
//  Created by cashwalkKeyboard on 2024/02/13.
//

import Foundation
import WebKit
import KeyboardSDKCore

protocol ENKeyboardMoreViewDelegate: AnyObject {
    func openTheme()
    func openClipBoard()
    func openSetting()
    func openInquiry()
    func openCash()

    func openOtherBrowser(url: String)
    func canOpenURL(url:String) -> Bool

}

class ENMoreViewCell: UICollectionViewCell {
    static let ID: String = "ENMoreViewCell"
    lazy var cellItem: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var cellImage: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.backgroundColor = .clear
        return imgView
    }()
    lazy var lbl: UILabel = {
        let lbl: UILabel = UILabel()
        
        lbl.textColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.key_text
        
        
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 13)
        lbl.backgroundColor = .clear
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byClipping
        return lbl
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        settingView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingView()
    }
    
    func settingView() {
        self.addSubview(cellItem)
        let itemWidth: CGFloat = 60
        let itemHeight: CGFloat = 104
        let imageWidth: CGFloat = 60
        let imageHeight: CGFloat = 60
        let lblTopMargin: CGFloat = 4
        let lblHeight: CGFloat = itemHeight - imageHeight - lblTopMargin

        self.layer.cornerRadius = 8
        cellItem.translatesAutoresizingMaskIntoConstraints = false
        cellItem.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
        cellItem.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
    
        cellItem.addSubview(cellImage)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        cellImage.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        cellImage.topAnchor.constraint(equalTo: cellItem.topAnchor).isActive = true
        cellImage.leadingAnchor.constraint(equalTo: cellItem.leadingAnchor).isActive = true
        cellImage.trailingAnchor.constraint(equalTo: cellItem.trailingAnchor).isActive = true
        
        cellItem.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.topAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: lblTopMargin).isActive = true
        lbl.heightAnchor.constraint(equalToConstant: lblHeight).isActive = true

//        lbl.bottomAnchor.constraint(lessThanOrEqualTo: cellItem.bottomAnchor).isActive = true
        lbl.leadingAnchor.constraint(equalTo: cellItem.leadingAnchor).isActive = true
        lbl.trailingAnchor.constraint(equalTo: cellItem.trailingAnchor).isActive = true
        
    }
   
    func setCellData(data : ENMoreInnerModel){
        lbl.text = data.name + "\n"
        cellImage.image = UIImage.init(named: data.imageName, in: Bundle.frameworkBundle, compatibleWith: nil)
    }
}

class ENKeyboardMoreView: UIView, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var dataSource:[ENMoreInnerModel] = [ENMoreInnerModel(tag: 0, name: "테마변경", imageName: "btn_more_theme"),
                                          ENMoreInnerModel(tag: 1, name: "클립보드", imageName: "btn_more_clipboard"),
                                          ENMoreInnerModel(tag: 2, name: "설정", imageName: "btn_more_setting"),
                                          ENMoreInnerModel(tag: 3, name: "문의/건의", imageName: "btn_more_inquiry"),
                                          ENMoreInnerModel(tag: 4, name: "적립내역", imageName: "btn_more_cash")]
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view: UICollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        view.register(ENMoreViewCell.self, forCellWithReuseIdentifier: ENMoreViewCell.ID)
//        view.backgroundColor = ENPlusInputViewManager.shared.keyboardTheme?.themeColors.tab_on
        view.backgroundColor = .white
        return view
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
    
    weak var delegate: ENKeyboardMoreViewDelegate? = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        settingViewConstraint()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingViewConstraint()
    }
    
    private func settingViewConstraint() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
       
        

        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 50).isActive = true
        collectionView.allowsMultipleSelection = false

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
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
    
        
        innerADView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: innerADView.leadingAnchor).isActive = true
        webView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 45).isActive = true
        webView.topAnchor.constraint(equalTo: innerADView.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: innerADView.bottomAnchor).isActive = true
        
        // 닫기 핸들러 달기
        innerADView.addSubview(btnClose)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.widthAnchor.constraint(equalToConstant: 15).isActive = true
        btnClose.topAnchor.constraint(equalTo: leftView.topAnchor).isActive = true
        btnClose.trailingAnchor.constraint(equalTo: leftView.trailingAnchor).isActive = true
        btnClose.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        btnClose.addTarget(self, action: #selector(btnCloseHandler(_:)), for: .touchUpInside)
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
        
    @objc func btnCloseHandler(_ sender: UIButton) {
        innerADView.removeFromSuperview()
        innerADView.heightAnchor.constraint(equalToConstant: 0).isActive = true
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


extension ENKeyboardMoreView {
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
extension ENKeyboardMoreView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 60, height: 104) // 각 셀의 크기
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 10 // 섹션 내의 셀 간의 수평 간격
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10) // 콜렉션 뷰의 내부 여백
       }
}

extension ENKeyboardMoreView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
            // 여기는 텍스트 보내야함
            let targetCell = collectionView.cellForItem(at: indexPath)
            
        if let cell = targetCell as? ENMoreViewCell {
            let data = dataSource[indexPath.row]
            print("ENKeyboardMoreView collection select :: \(data.name)/\(data.tag)")

                switch data.tag {
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
                        delegate.openSetting()
                    }
                case 3:
                    if let delegate = delegate {
                        delegate.openInquiry()
                    }
                case 4:
                    if let delegate = delegate {
                        delegate.openCash()
                    }
                    
                default:
                    print("not tag exist")
                }
            
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ENKeyboardMoreView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ENMoreViewCell.ID, for: indexPath) as? ENMoreViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: ENMoreViewCell.ID, for: indexPath)
        }
        cell.backgroundColor = .clear
        cell.setCellData(data: dataSource[indexPath.row])
        cell.isSelected = false
        cell.layoutIfNeeded()
        return cell
    }
}

struct SettingBannerModel: Codable { 
    let Result: String
    let point: String
}
struct ENMoreInnerModel: Codable {
    let tag: Int
    let name: String
    let imageName: String
}
