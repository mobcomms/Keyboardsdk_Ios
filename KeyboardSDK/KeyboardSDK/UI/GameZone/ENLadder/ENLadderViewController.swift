//
//  ENLadderViewController.swift
//  KeyboardSDK
//
//  Created by Enliple on 2024/01/31.
//

import Foundation
import UIKit


public class ENLadderViewController : UIViewController {
    
    private let gameService: LadderService 
    
    lazy var gameView = GameView(service: gameService)
//    let scrollView = UIScrollView()
    
    private var timer: Timer?
    
    init(gameService: LadderService) {
        self.gameService = gameService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.timer?.invalidate()
        self.timer = nil
        self.view.backgroundColor = .white
        self.view.addSubview(self.gameView)

        
        self.gameView.onTap.delegate(on: self) { (self, track) in
            self.startTrack(tracker: track.tracker, routes: track.routes)
        }
        
        self.gameView.playerCompleteAnimated.delegate(on: self) { (self, gameResult) in
            
            self.stopTrack()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismiss(animated: true)
            }
        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let playerCount = CGFloat(self.gameService.players.count)
//        let totalWidth = playerCount * 80
        self.gameView.frame = CGRect(x: 20, y: 0, width: self.view.frame.width, height: self.view.frame.height - 100 - self.view.safeAreaInsets.bottom)
//        self.scrollView.contentSize = CGSize(width: self.gameView.frame.width + 40, height: self.gameView.frame.height)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func startTrack(tracker: ItemHashable, routes: [CGPoint]) {
        self.timer?.invalidate()
        self.timer = nil
        // Since we have two second duration to display animation
        var timeInterval: TimeInterval = 0.1
        
        let duration: TimeInterval = 2
        
        timeInterval = duration / Double(routes.count)
        
        var offset = routes.startIndex + 2
        let endIndex = routes.endIndex

        self.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
            
        }
    }
    
    private func stopTrack() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
}

extension ENLadderViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.gameView
    }
}
