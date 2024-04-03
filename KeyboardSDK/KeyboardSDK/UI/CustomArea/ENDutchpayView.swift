//
//  ENDutchpayView.swift
//  KeyboardSDK
//
//  Created by ximAir on 2023/09/12.
//

import Foundation
import KeyboardSDKCore

protocol ENDutchpayViewDelegate: AnyObject {
    /// 인원 수 전달
    func sendPersonNumber(person: String)
    /// 금액 전달
    func sendPriceNumber(price: String)
    /// 결과 전달
    func sendResult(person: String, price: String)
    /// 왼쪽으로 포커스 이동
    func sendLeftHandler()
    /// 오른쪽으로 포커스 이동
    func sendRightHandler()
}

public class ENDutchpayView: UIView {
    
    weak var delegates: ENDutchpayViewDelegate? = nil
    var person = ""
    var price = ""
    var isPerson: Bool = true
    var isPrice: Bool = false
    
    let textArray = [
        ["7", "4", "1", "<", ">"],
        ["8", "5", "2", "0"],
        ["9", "6", "3", "x"],
    ]
    
    var btnArray: [UIButton] = []
    var btnConstraintArray: [NSLayoutConstraint] = []
    
    public lazy var stackView1: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 7
        stackView.alignment = .fill
        
        return stackView
    }()
    
    public lazy var stackView2: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 7
        stackView.alignment = .fill
        
        return stackView
    }()
    
    public lazy var stackView3: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 7
        stackView.alignment = .fill
        
        return stackView
    }()
    
    public lazy var innerStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
        
        return stackView
    }()
    
    let frameHeightSupportedNum = 110.0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        settingUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        settingUI()
    }
    
    public func initDutchPayView() {
        person = ""
        price = ""
        
        isPerson = true
        isPrice = false
    }
    
    public func settingUI() {
        self.addSubview(stackView1)
        self.addSubview(stackView2)
        self.addSubview(stackView3)
//        self.addSubview(stackView4)
        
        self.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        
        let frameHeight = ENSettingManager.shared.getKeyboardHeight(isLandcape: false) - frameHeightSupportedNum  + 50
        let buttonHeight:CGFloat = ((frameHeight < 6 ? ENSettingManager.shared.getKeyboardHeight(isLandcape: false) : frameHeight) - 6) / CGFloat(textArray[0].count)
        
        for (lineIndex, line) in textArray.enumerated() {
            for textItem in line {
                
                let button: UIButton = UIButton(type: .custom)
                button.setTitle(textItem, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .white
                button.layer.cornerRadius = 4
                
                button.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3).cgColor
                button.layer.shadowOpacity = 1.0
                button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                button.layer.shadowRadius = 2
                
                button.addTarget(self, action: #selector(buttonTouchDownInsideHandler(_:)), for: .touchDown)
                button.addTarget(self, action: #selector(buttonTouchUpInsideHandler(_:)), for: .touchUpInside)
                
                button.translatesAutoresizingMaskIntoConstraints = false
                
                btnArray.append(button)
                
                let constraint = button.heightAnchor.constraint(equalToConstant: buttonHeight)
                btnConstraintArray.append(constraint)
                constraint.isActive = true
                
                switch lineIndex {
                case 0:
                    if textItem == "<" || textItem == ">" {
                        innerStackView.addArrangedSubview(button)
                        stackView1.addArrangedSubview(innerStackView)
                    } else {
                        stackView1.addArrangedSubview(button)
                    }
                    break
                case 1:
                    stackView2.addArrangedSubview(button)
                    break
                case 2:
                    stackView3.addArrangedSubview(button)
                    break
                default:
                    break
                }
            }
        }
        
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        stackView1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        stackView1.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        stackView1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        stackView2.translatesAutoresizingMaskIntoConstraints = false
        stackView2.leadingAnchor.constraint(equalTo: stackView1.trailingAnchor, constant: 8).isActive = true
        stackView2.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        stackView2.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        stackView2.widthAnchor.constraint(equalTo: stackView1.widthAnchor, multiplier: 1.0).isActive = true
        
        stackView3.translatesAutoresizingMaskIntoConstraints = false
        stackView3.leadingAnchor.constraint(equalTo: stackView2.trailingAnchor, constant: 8).isActive = true
        stackView3.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        stackView3.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        stackView3.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        stackView3.widthAnchor.constraint(equalTo: stackView1.widthAnchor, multiplier: 1.0).isActive = true
    }
    
    public func updateButtonHeight(isLand: Bool) {
        let frameHeight = ENSettingManager.shared.getKeyboardHeight(isLandcape: isLand) - frameHeightSupportedNum  + 50
        let buttonHeight:CGFloat = ((frameHeight < 6 ? ENSettingManager.shared.getKeyboardHeight(isLandcape: isLand) : frameHeight) - 6) / CGFloat(textArray[0].count)
        
        for inner in btnConstraintArray {
            inner.constant = buttonHeight
        }
    }
    
    @objc func buttonTouchDownInsideHandler(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    @objc func buttonTouchUpInsideHandler(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        guard let inputText = sender.titleLabel?.text else { return }
        
        if inputText == "<" || inputText == ">" {
            switch inputText {
            case "<":
                delegates?.sendLeftHandler()
                break
            case ">":
                delegates?.sendRightHandler()
                break
            default:
                break
            }
        } else {
            if isPerson {
                if inputText != "x" {
                    if (self.person == "0" && inputText == "0") {
                        // 00000000 명은 할수 없게 하기
                    } else {
                        if self.person.count <= 2 {
                            self.person += inputText
                            delegates?.sendPersonNumber(person: self.person)
                        }
                    }
                } else {
                    if self.person != "0" {
                        self.person = String(self.person.dropLast())
                        delegates?.sendPersonNumber(person: self.person == "" ? "0" : self.person)
                    }
                }
            } else if isPrice {
                if inputText != "x" {
                    if self.price == "0" && inputText == "0" {
                        // 00000000 원 은 할수 없게 하기
                    } else {
                        if self.price.count <= 7 {
                            self.price += inputText
                            delegates?.sendPriceNumber(price: self.price)
                        }
                    }
                } else {
                    if self.price != "0" {
                        self.price = String(self.price.dropLast())
                        delegates?.sendPriceNumber(price: self.price == "" ? "0" : self.price)
                    }
                }
            }
        }
    }
}
