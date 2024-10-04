//
//  WarViewController.swift
//  CasinoGame
//
//  Created by Charles Carroll on 4/11/24.
//
// Charles Carroll (chajcarr), Anthony Reyes (antreye)
// App Name: Diamond Dunes Casinno
// Final Project Submission Date: 04/28/2024

import UIKit
import SpriteKit

class WarViewController: UIViewController {
    
    var appDelegate: AppDelegate?
    var model: CasinoModel?
    @IBOutlet var playerCard : UIImageView!
    @IBOutlet var dealerCard : UIImageView!
    @IBOutlet var status : UIImageView!
    
    @IBOutlet weak var balanceLabel : UILabel!
    @IBOutlet weak var betLabel : UILabel!
    
    var bet = 0
    var gameStarted = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.model = self.appDelegate?.model
        
//        let skView = SKView(frame: view.frame)
//        skView.showsFPS = false
//        skView.showsNodeCount = false
//        view.addSubview(skView)
//        let scene = SKScene(size: view.frame.size)
//        scene.backgroundColor = .clear
//        
//        let t = SKTexture(image: (UIImage(named : "back")!))
//
//        let card1 = SKSpriteNode(texture: t)
//        let card2 = SKSpriteNode(texture: t)
//        let move1 = SKAction.move(to: CGPoint(x: scene.size.width + 100, y: scene.size.height / 2), duration: 1.0)
//        let move2 = SKAction.move(to: CGPoint(x: scene.size.width - 100, y: scene.size.height / 2), duration: 1.0)
//        
//        card1.run(move1)
//        card2.run(move2)
//        skView.presentScene(scene)
        
        self.playerCard.image = UIImage(named : "back")
        self.dealerCard.image = UIImage(named : "back")
        balanceLabel.text  = "GEM BALANCE - \(model!.balance)"
    }
    
    func startWar(){
        var balanceText = balanceLabel.text
        balanceText = balanceText! + "\(model!.balance)"
        balanceLabel.text = balanceText
        betLabel.text = "bet: 0"
        
        
        model!.startOfGame()
        playerCard.image = UIImage(named: "\(model!.playerCards[0])")
        dealerCard.image = UIImage(named: "\(model!.dealerCards[0])")
        evaluateWinner()
        gameStarted = false
        betLabel.text = "bet: 0"
        

    }
    
    
    
    func evaluateWinner(){
        let theText = model!.playerCards[0]
        let textArray = theText.split(separator: "_")
        var playercount = 0
        if textArray[0] == "jack"{
            playercount = 10
        } else if textArray[0] == "queen"{
            playercount = 11
        } else if textArray[0] == "king"{
            playercount = 13
        } else {
            playercount = Int("\(textArray[0])")!
        }
        
        
        let theText1 = model!.dealerCards[0]
        let textArray1 = theText1.split(separator: "_")
        var dealercount = 0
        if textArray1[0] == "jack" || textArray1[0] == "queen" || textArray1[0] == "king"{
            dealercount = 10
        }else {
            dealercount = Int("\(textArray1[0])")!
        }
        
        
        
        if dealercount == playercount {
            model!.blackjackLostGame()
            status.image = UIImage(named:"TIE!")
            print("TIE")
            print("\(model!.balance)")
        }else if playercount > dealercount {
            model!.bet = bet 
            model!.blackjackWinGame()
            status.image = UIImage(named:"WIN!")
            print("U WIN ")
            print("\(model!.balance)")
        }else{
            model!.blackjackLostGame()
            status.image = UIImage(named:"YOULOSE!")
            print("U LOSE")
            print("\(model!.balance)")
        }
        
        
    }
    
    @IBAction func increaseBet(_ sender: Any){
        if gameStarted{
            return
        }
        bet = bet + 1
        betLabel.text = "bet: " + "\(bet)"
    }
    @IBAction func decreaseBet(_ sender: Any){
        if gameStarted{
            return
        }
        if bet == 0{
            return
        }
        bet = bet - 1
        betLabel.text = "bet: " + "\(bet)"
        
    }
    
    @IBAction func nextHand(_ sender: Any){
        self.playerCard.image = UIImage(named : "back")
        self.dealerCard.image = UIImage(named : "back")
        balanceLabel.text  = "GEM BALANCE - \(model!.balance)"
        status.image = nil
    }
    
    @IBAction func ready(_ sender: Any){
        if model!.balance - bet < 0{
            return
        }
        gameStarted = true
        model!.balance -= bet
        balanceLabel.text = "GEM COUNT - " + "\(model!.balance)"
        startWar()
        balanceLabel.text = "GEM COUNT - " + "\(model!.balance)"
    }
}




