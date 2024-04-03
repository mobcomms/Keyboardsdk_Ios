//
//  ENScratchViewController.swift
//  KeyboardSDK
//
//  Created by Enliple on 2024/01/31.
//

import Foundation
import UIKit

public class ENScratchViewController : UIViewController {
 
    

    lazy var scratchImageView = ENScratchView(frame: .zero)
    
      let scratchCardView:UIView = UIView(frame: .zero)
    
      let trophyView:UIImageView = UIImageView(frame: .zero)

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(scratchCardView)
        scratchCardView.addSubview(trophyView)

        self.view.addSubview(scratchImageView)

        scratchCardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scratchCardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        scratchCardView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        scratchCardView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        scratchCardView.heightAnchor.constraint(equalTo: scratchCardView.widthAnchor, multiplier: 1.0).isActive = true
        scratchCardView.backgroundColor = .lightGray
        scratchCardView.translatesAutoresizingMaskIntoConstraints = false

        trophyView.centerXAnchor.constraint(equalTo: scratchCardView.centerXAnchor).isActive = true
        trophyView.centerYAnchor.constraint(equalTo: scratchCardView.centerYAnchor).isActive = true
        trophyView.leadingAnchor.constraint(equalTo: scratchCardView.leadingAnchor, constant: 20).isActive = true
        trophyView.trailingAnchor.constraint(equalTo: scratchCardView.trailingAnchor, constant: -20).isActive = true
        trophyView.heightAnchor.constraint(equalTo: trophyView.widthAnchor, multiplier: 1.0).isActive = true
        trophyView.backgroundColor = .clear
        trophyView.translatesAutoresizingMaskIntoConstraints = false
        trophyView.image = UIImage(named: "goldTrophy", in: Bundle.frameworkBundle, compatibleWith: nil)

        scratchImageView.leadingAnchor.constraint(equalTo: scratchCardView.leadingAnchor, constant: 0).isActive = true
        scratchImageView.trailingAnchor.constraint(equalTo: scratchCardView.trailingAnchor, constant: 0).isActive = true
        scratchImageView.topAnchor.constraint(equalTo: scratchCardView.topAnchor, constant: 0).isActive = true
        scratchImageView.bottomAnchor.constraint(equalTo: scratchCardView.bottomAnchor, constant: 0).isActive = true
        scratchImageView.backgroundColor = .clear
        scratchImageView.translatesAutoresizingMaskIntoConstraints = false

        self.scratchImageView.isUserInteractionEnabled = true
        scratchImageView.lineWidth = 40.0
        self.scratchImageView.delegate = self
        self.scratchImageView.image = UIImage(named: "srachView", in: Bundle.frameworkBundle, compatibleWith: nil)
        
        self.scratchImageView.layer.cornerRadius = 8
        self.scratchImageView.layer.masksToBounds = true
        
        self.scratchCardView.layer.cornerRadius = 8
        self.scratchCardView.layer.masksToBounds = true
        
        self.trophyView.layer.cornerRadius = self.trophyView.frame.height/2
        self.trophyView.layer.masksToBounds = true
        self.view.backgroundColor = .white
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }

    
}
extension ENScratchViewController : ENScratchViewDelegate{
    public func scratchCardEraseProgress(eraseProgress: Float) {
        print(eraseProgress)
        if eraseProgress > 50.0{
            UIView.animate(withDuration: 0.5, animations: {
                self.scratchImageView.alpha = 0.0
            })
            
        }

    }
}
