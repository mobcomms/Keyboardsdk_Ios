//
//  ENMemoAddViewController.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/05.
//

import Foundation
import KeyboardSDKCore

public class ENMemoAddViewController: UIViewController, ENViewPrsenter, UITextViewDelegate {
    
    public static func create() -> ENMemoAddViewController {
        let vc = ENMemoAddViewController.init(nibName: "ENMemoAddViewController", bundle: Bundle.frameworkBundle)
        vc.modalPresentationStyle = .overFullScreen
        
        return vc
    }
    
    @IBOutlet weak var viewOpacity: UIView!
    @IBOutlet weak var viewWrapper: UIView!
    @IBOutlet weak var viewTextViewWrapper: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTextCount: UILabel!
    
    weak var eNMemoDetailViewDelegate: ENMemoDetailViewDelegate?
    
    let maxCount = 300

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        viewOpacity.backgroundColor = .clear
        
        settingUI()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUpNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDownNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func settingUI() {
        textView.delegate = self
        let opacityTap = UITapGestureRecognizer(target: self, action: #selector(opacityTapHandler(_:)))
        viewOpacity.addGestureRecognizer(opacityTap)
        
        viewWrapper.popupEffect()
        
        viewTextViewWrapper.layer.borderWidth = 1
        viewTextViewWrapper.layer.borderColor = UIColor(red: 228/225, green: 231/255, blue: 236/255, alpha: 1).cgColor
        viewTextViewWrapper.layer.cornerRadius = 10
        
        btnConfirm.layer.cornerRadius = 12
        btnClose.layer.cornerRadius = 12
        
        btnConfirm.addTarget(self, action: #selector(btnConfirmHandler(_:)), for: .touchUpInside)
        btnClose.addTarget(self, action: #selector(btnCloseHandler(_:)), for: .touchUpInside)
    }
    
    @objc func keyboardUpNotification(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self else { return }
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
            })
        }
    }
    
    @objc func keyboardDownNotification(notification: NSNotification) {
        self.view.transform = .identity
    }
    
    @objc func btnConfirmHandler(_ sender: UIButton) {
        if self.textView.text == "" {
            showErrorMessage(message: "내용을 입력해 주세요.")
            return
        }
        
        if let delegates = eNMemoDetailViewDelegate {
            enDismiss(completion: { [weak self] in
                guard let self else { return }
                delegates.addMemo(memo: self.textView.text)
            })
        } else {
            showErrorMessage(message: "메모 저장에 실패하였습니다. 다시 시도해 주세요.")
            enDismiss()
        }
    }
    
    @objc func btnCloseHandler(_ sender: UIButton) {
        enDismiss()
    }
    
    @objc func opacityTapHandler(_ sender: UITapGestureRecognizer) {
        enDismiss()
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        // 시작할 때
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        // 바뀔 때
//        print("ㅇㅇ : \(textView.text ?? "")")
        if textView.text.isEmpty {
            self.lblTextCount.text = "0/300"
        } else if textView.text.count > maxCount {
            textView.text.removeLast()
            self.lblTextCount.text = "\(textView.text.count)/300"
        } else {
            self.lblTextCount.text = "\(textView.text.count)/300"
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        // 끝날 때
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.count - range.length + text.count
        let koreanMaxCount = maxCount + 1
        
        if newLength >= koreanMaxCount {
            let overFlow = newLength - koreanMaxCount
            if text.count < overFlow {
                return true
            }
            
            let index = text.index(text.endIndex, offsetBy: -overFlow)
            let newText = text[..<index]
            
            guard let startPosition = textView.position(from: textView.beginningOfDocument, offset: range.location) else { return false }
            guard let endPosition = textView.position(from: textView.beginningOfDocument, offset: NSMaxRange(range)) else { return false }
            guard let textRange = textView.textRange(from: startPosition, to: endPosition) else { return false }
            
            textView.replace(textRange, withText: String(newText))
                        
            return false
        }
                
        return true
    }
}
