//
//  GameZoneViewController.swift
//  KeyboardSDK
//
//  Created by Enliple on 2024/01/25.
//

import UIKit
@objc
protocol GameZoneMainDelegate: AnyObject {

     func selectGameDelegate(_ game: String)

}

public class GameZoneViewController: UIViewController  {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var currentScreen = ENGameScreem.Main
    var currentViewController: UIViewController!
     var delegate:GameZoneMainDelegate?

    enum ENGameScreem {
        case Main
        case Scratch
        case Roulette
        case Ladder
    }
    

     public static func create() -> GameZoneViewController {
         let vc = GameZoneViewController.init(nibName: "GameZoneViewController", bundle: Bundle.frameworkBundle)
         vc.modalPresentationStyle = .overFullScreen
         
         return vc
     }

    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        titleLabel.text = "메인화면"
        currentViewController = GameZoneMainViewController(delegate: self.delegate!)
        self.addChild(currentViewController)
        currentViewController.view.frame = mainView.frame
        view.addSubview(currentViewController.view)
        currentViewController.didMove(toParent: self)
        


    }
    @IBAction func prevClick(_ sender: Any) {
        switch currentScreen{
        case .Scratch:
            callMainView()
            
            break
        case .Roulette:
            callMainView()

            
            break
        case .Ladder:
            callMainView()
            break
        default:
            enDismiss()
            break

        }
        
    }
    func enDismiss(animated flag: Bool = true, popToRoot: Bool = false) {
        if let nav = self.navigationController {
            if popToRoot {
                nav.popToRootViewController(animated: flag)
            }
            else {
                nav.popViewController(animated: flag)
            }
        }
        else {
            self.dismiss(animated: flag)
        }
    }

     func callMainView(){
         currentScreen = .Main
         currentViewController.view.removeFromSuperview()
         currentViewController.removeFromParent()
         currentViewController = GameZoneMainViewController(delegate: self.delegate!)
         self.addChild(currentViewController)
         currentViewController.view.frame = mainView.frame
         view.addSubview(currentViewController.view)
         currentViewController.didMove(toParent: self)
         self.titleLabel.text = "메인화면"

     }
     
}

extension GameZoneViewController:GameZoneMainDelegate{
    func selectGameDelegate(_ game: String) {
        print("ViewController selectGame game :: \(game)")
        self.titleLabel.text = game
        if game == "scratch"{
            currentScreen = .Scratch
            currentViewController.removeFromParent()
            currentViewController = ENScratchViewController()

        }else if game == "roulette"{
            currentScreen = .Roulette
            currentViewController.removeFromParent()
            currentViewController = ENRouletteViewController()

        }else{
            currentScreen = .Ladder
            currentViewController.removeFromParent()
            let players = [Player(name: "사", image: nil, presentedColor: .black),Player(name: "다", image: nil, presentedColor: .black),Player(name: "리", image: nil, presentedColor: .black),Player(name: "타", image: nil, presentedColor: .black),Player(name: "기", image: nil, presentedColor: .black)]
            let rewards = [Reward(object: "꽝", presentedColor: randomColor(luminosity: .dark)), Reward(object: "1P", presentedColor: randomColor(luminosity: .dark)),Reward(object: "2P", presentedColor: randomColor(luminosity: .dark)),Reward(object: "3P", presentedColor: randomColor(luminosity: .dark)),Reward(object: "4P", presentedColor: randomColor(luminosity: .dark))]
                    let gameService = LadderService(players: players)
                    gameService.prepare()
                    gameService.setReward(rewards)
            currentViewController = ENLadderViewController(gameService: gameService)

        }
        self.addChild(currentViewController)
        currentViewController.view.frame = mainView.frame
        view.addSubview(currentViewController.view)
        currentViewController.didMove(toParent: self)
    }
}
