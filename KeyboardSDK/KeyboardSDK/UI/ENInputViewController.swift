//
//  ENInputViewController.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/05/04.
//

import UIKit
import KeyboardSDKCore


/// UIInputViewController 상속.  Client에서 해당 클래스를 상속받아 Keyboard Extension을 구현할 수 있도록 한다.
open class ENInputViewController: UIInputViewController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .landscape]
    }
    
    open override func viewDidLoad() {
        ENPlusInputViewManager.shared.inputViewController = self
        
        super.viewDidLoad()
        
        ENPlusInputViewManager.shared.viewDidLoad()
    }

    open override func viewWillLayoutSubviews() {
        ENPlusInputViewManager.shared.viewWillLayoutSubviews()
        super.viewWillLayoutSubviews()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ENPlusInputViewManager.shared.viewWillAppear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ENPlusInputViewManager.shared.viewDidAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ENPlusInputViewManager.shared.viewWillDisappear(animated)
    }
    
}
