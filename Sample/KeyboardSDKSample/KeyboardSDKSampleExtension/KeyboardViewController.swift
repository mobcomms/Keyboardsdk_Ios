//
//  KeyboardViewController.swift
//  KeyboardSDKSampleExtension
//
//  Created by enlipleIOS1 on 2021/05/04.
//

import UIKit
import KeyboardSDK 
import KeyboardSDKCore


class KeyboardViewController: ENInputViewController {

    let groupID: String = "group.enkeyboardsdk.sample"
    let apiKey: String = "123"
   
    override func viewDidLoad() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1, execute: {
//            ENKeyboardSDK.shared.sdkInit(apiKey: self.apiKey, groupId: self.groupID)
//        })

//        ENKeyboardSDK.shared.setDebug(isDebug: false)
        print("KeyboardViewController viewDidLoad")

        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SDK Version : \(ENKeyboardSDKInfo.version)///  Core Version : \(ENKeyboardSDKInfo.coreSDKVersion)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
//class KeyboardViewController: UIInputViewController {
//    let groupID: String = "group.enkeyboardsdk.sample"
//    let apiKey: String = "123"
////아직 정해진 키가 없어서 “123” 으로 해주시면 되겠습니다.
//    
//    override func viewDidLoad() {
//        
//        ENKeyboardSDK.shared.sdkInit(apiKey: apiKey, groupId: groupID)
//        ENPlusInputViewManager.shared.inputViewController = self
//
//        super.viewDidLoad()
//
//        ENPlusInputViewManager.shared.viewDidLoad()
//    }
//
//    override func viewWillLayoutSubviews() {
//        ENPlusInputViewManager.shared.viewWillLayoutSubviews()
//        super.viewWillLayoutSubviews()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        ENPlusInputViewManager.shared.viewWillAppear(animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        ENPlusInputViewManager.shared.viewWillDisappear(animated)
//    }
//}
