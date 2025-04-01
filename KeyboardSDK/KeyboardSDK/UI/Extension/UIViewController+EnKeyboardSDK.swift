//
//  UIViewController+EnKeyboardSDK.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/05/21.
//

import Foundation
import UIKit



public extension UIViewController {
    
    func showErrorMessage(message:String) {
        
        let vc = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction.init(title: "확인", style: .default, handler: { action in
            vc.dismiss(animated: true, completion: nil)
        }))
        
        self.present(vc, animated: true, completion: nil)        
    }
    
//    /// Open url inside app extension
//    ///
//    /// - Parameter url: url
//    func open(url: URL) {
//        var responder: UIResponder? = self as UIResponder
//        let selector = #selector(openURL(_:))
//        while responder != nil {
//            if responder! is UIApplication {
//                responder!.perform(selector, with: url)
//                return
//            }
//            responder = responder?.next
//        }
//    }
//    
//    /// Fake selector to suppress compile error
//    ///
//    /// - Parameter url: useless
//    /// - Returns: useless
////    @objc func openURL(_ url: URL) -> Bool {
////        return true
////    }
//    @objc func openURL(_ url: URL) -> Bool {
//        var responder: UIResponder? = self
//        while responder != nil {
//            if let application = responder as? UIApplication {
//                return application.perform(#selector(openURL(_:)), with: url) != nil
//            }
//            responder = responder?.next
//        }
//        return false
//    }
    
    @objc func open(url: URL) -> Bool {weak

        var responder: UIResponder? = self
        print("0331 open :: \(url)")
        while responder != nil {
            if let application = responder as? UIApplication {
                print("0331 open :: application : \(application)")

                if application.canOpenURL(url) {
                    print("0331 open :: canOpenURL")

                    application.open(url, options: [:], completionHandler: nil)
                    return true
                } else {
                    print("0331 open :: canOpenURL false!!!")

                    return false
                }
            }
            responder = responder?.next
        }
        return false
    }

    
    @objc func openURL(_ url: URL) -> Bool {weak
        var responder: UIResponder? = self
        print("0331 openURL :: \(url)")

        while responder != nil {
            if let application = responder as? UIApplication {
                if application.canOpenURL(url) {

                    application.open(url, options: [:], completionHandler: nil)
                    return true
                } else {
                    return false
                }
            }
            responder = responder?.next
        }
        return false
    }

}


