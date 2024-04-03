//
//  GameZoneMainViewController.swift
//  KeyboardSDK
//
//  Created by Enliple on 2024/01/31.
//

import Foundation
import UIKit


class GameZoneMainViewController : UIViewController {
    
    
    
    let scratchView:UIView = UIView(frame: .zero)
    let rouletteView:UIView = UIView(frame: .zero)
    let ladderView:UIView = UIView(frame: .zero)
     var delegate:GameZoneMainDelegate?
    init(delegate:GameZoneMainDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(scratchView)
        scratchView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        scratchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        scratchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        scratchView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        scratchView.backgroundColor = .gray
        scratchView.translatesAutoresizingMaskIntoConstraints = false
        scratchView.tag = 0
        scratchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveTapAction(_:))))
        let scratchTitle = UILabel(frame: .zero)
        scratchView.addSubview(scratchTitle)
        scratchTitle.textColor = .white
        scratchTitle.textAlignment = .center
        scratchTitle.text = "복권"
        scratchTitle.font = UIFont.systemFont(ofSize: 30.0, weight: .bold)
        scratchTitle.topAnchor.constraint(equalTo: scratchView.topAnchor, constant: 0).isActive = true
        scratchTitle.bottomAnchor.constraint(equalTo: scratchView.bottomAnchor, constant: 0).isActive = true
        scratchTitle.leadingAnchor.constraint(equalTo: scratchView.leadingAnchor, constant: 0).isActive = true
        scratchTitle.trailingAnchor.constraint(equalTo: scratchView.trailingAnchor, constant: 0).isActive = true
        scratchTitle.translatesAutoresizingMaskIntoConstraints = false

//
        self.view.addSubview(rouletteView)
        rouletteView.translatesAutoresizingMaskIntoConstraints = false
        rouletteView.topAnchor.constraint(equalTo: scratchView.bottomAnchor, constant: 10).isActive = true
        rouletteView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        rouletteView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        rouletteView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        rouletteView.backgroundColor = .gray
        rouletteView.tag = 1
        rouletteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveTapAction(_:))))
        let rouletteTitle = UILabel(frame: .zero)
        rouletteView.addSubview(rouletteTitle)
        rouletteTitle.textColor = .white
        rouletteTitle.textAlignment = .center
        rouletteTitle.text = "룰렛"
        rouletteTitle.font = UIFont.systemFont(ofSize: 30.0, weight: .bold)
        rouletteTitle.topAnchor.constraint(equalTo: rouletteView.topAnchor, constant: 0).isActive = true
        rouletteTitle.bottomAnchor.constraint(equalTo: rouletteView.bottomAnchor, constant: 0).isActive = true
        rouletteTitle.leadingAnchor.constraint(equalTo: rouletteView.leadingAnchor, constant: 0).isActive = true
        rouletteTitle.trailingAnchor.constraint(equalTo: rouletteView.trailingAnchor, constant: 0).isActive = true
        rouletteTitle.translatesAutoresizingMaskIntoConstraints = false


        self.view.addSubview(ladderView)
        ladderView.topAnchor.constraint(equalTo: rouletteView.bottomAnchor, constant: 10).isActive = true
        ladderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        ladderView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        ladderView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        ladderView.backgroundColor = .gray
        ladderView.translatesAutoresizingMaskIntoConstraints = false
        ladderView.tag = 2
        ladderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveTapAction(_:))))
        let ladderTitle = UILabel(frame: .zero)
        ladderView.addSubview(ladderTitle)
        ladderTitle.textColor = .white
        ladderTitle.textAlignment = .center
        ladderTitle.text = "사다리타기"
        ladderTitle.font = UIFont.systemFont(ofSize: 30.0, weight: .bold)
        ladderTitle.topAnchor.constraint(equalTo: ladderView.topAnchor, constant: 0).isActive = true
        ladderTitle.bottomAnchor.constraint(equalTo: ladderView.bottomAnchor, constant: 0).isActive = true
        ladderTitle.leadingAnchor.constraint(equalTo: ladderView.leadingAnchor, constant: 0).isActive = true
        ladderTitle.trailingAnchor.constraint(equalTo: ladderView.trailingAnchor, constant: 0).isActive = true
        ladderTitle.translatesAutoresizingMaskIntoConstraints = false

        self.view.backgroundColor = .white
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
@objc func moveTapAction(_ sender: AnyObject) {
    let tag = sender.view.tag
    if let delegate = self.delegate{
        let screen = tag == 0 ? "scratch"  : tag == 1 ?  "roulette" : "ladder"
        delegate.selectGameDelegate(screen)

    }else{
        print("moveTapAction delegate nil")

    }
}

}
