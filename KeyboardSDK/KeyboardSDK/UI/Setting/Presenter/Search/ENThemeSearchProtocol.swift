//
//  ENThemeSearchProtocol.swift
//  KeyboardSDK
//
//  Created by enlipleIOS1 on 2021/07/06.
//

import Foundation


protocol ENThemeSearchProtocol: AnyObject {
    func search(by keyword:String, from: ENThemeSearchProtocol?)
}
