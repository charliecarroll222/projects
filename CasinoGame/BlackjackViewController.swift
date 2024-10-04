//
//  BlackjackViewController.swift
//  CasinoGame
//
//  Created by Charles Carroll on 4/11/24.
//
// Charles Carroll (chajcarr), Anthony Reyes (antreye)
// App Name: Diamond Dunes Casinno
// Final Project Submission Date: 04/28/2024

import UIKit
import AVFoundation

class BlackjackViewController: UIViewController {
    

    @IBOutlet var playerCard1 : UIImageView!
    @IBOutlet var playerCard2 : UIImageView!
    @IBOutlet var playerCard3 : UIImageView!
    @IBOutlet var playerCard4 : UIImageView!
    @IBOutlet var playerCard5 : UIImageView!
    
    @IBOutlet var dealerCard1 : UIImageView!
    @IBOutlet var dealerCard2 : UIImageView!
    @IBOutlet var dealerCard3 : UIImageView!
    @IBOutlet var dealerCard4 : UIImageView!
    @IBOutlet var dealerCard5 : UIImageView!
    
    @IBOutlet var status : UIImageView! 
    var audioPlayer: AVAudioPlayer?
   
   
    
    var appDelegate: AppDelegate?
    var model: CasinoModel?
    
    @IBOutlet weak var balanceLabel : UILabel!
    @IBOutlet weak var betLabel : UILabel!
    @IBOutlet weak var playerCounter : UILabel!
    @IBOutlet weak var dealerCounter : UILabel!
    
    @IBOutlet weak var doubleButton : UIButton!
    
    var bet = 0
    var gameStarted = false
    var playerCount = 0;
    var dealerCount = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.model = self.appDelegate?.model
        balanceLabel.text = "GEM COUNT - \(model!.balance)"
        playerCounter.text = "0"
        dealerCounter.text = "0"
    }
    
    func resetGame() {
        bet = 0
        self.betLabel.text = "0"
        self.playerCounter.text = "0"
        self.dealerCounter.text = "0"
        gameStarted = false
        self.balanceLabel.text = "GEM COUNT: \(model!.balance)"
    }
    
    
    func evaluateWinner(){
        let deltadealer = 21 - dealerCount
        let deltaplayer = 21 - playerCount
        
        if deltadealer < 0 {
            model!.bet = bet
            model!.blackjackWinGame()
            resetGame()
            status.image = UIImage(named: "UWDB")
            print("YOU WIN , DEALER BUST")
            
        }
        else if deltaplayer < deltadealer{
            model!.bet = bet
            model!.blackjackWinGame()
            resetGame()
            print("YOU WIN")
            status.image = UIImage(named: "WIN!")
            gameStarted = false

           
            
        }
        else if deltadealer == deltaplayer{
            model!.blackjackLostGame()
            resetGame()
            status.image = UIImage(named:"TIE!")
            print("TIE")
            gameStarted = false

            
        }
        else{
            model!.blackjackLostGame()
            resetGame()
            status.image = UIImage(named: "YOULOSE!")
            print("U LOST")
            gameStarted = false

        }
        
    }
    
    func evaluateBust(){
        let deltaplayer = 21 - playerCount
        if deltaplayer < 0 {
            model!.blackjackLostGame()
            resetGame()
            
            print("U LOST")
            status.image = UIImage(named: "YOUBUST!")
            gameStarted = false
        }
    }
    
    
    func startBlackjack(){
        gameStarted = true
        var balanceText = balanceLabel.text
        balanceText = balanceText! + "\(model!.balance)"
        balanceLabel.text = balanceText
        betLabel.text = "bet: "
        model!.startOfGame()
        
        self.playerCard1.image = UIImage(named : "\(model!.playerCards[0])")
        self.playerCard2.image = UIImage(named : "\(model!.playerCards[1])")
        var theText = model!.playerCards[0]
        var textArray = theText.split(separator: "_")
        var count = 0
        if textArray[0] == "jack" || textArray[0] == "queen" || textArray[0] == "king"{
            count = 10
        }else {
            count = Int("\(textArray[0])")!
        }
        playerCount += count
        theText = model!.playerCards[1]
        textArray = theText.split(separator: "_")
        count = 0
        if textArray[0] == "jack" || textArray[0] == "queen" || textArray[0] == "king"{
            count = 10
        }else {
            count = Int("\(textArray[0])")!
        }
        playerCount += count
        self.playerCounter.text = "\(playerCount)"
        
        
         
        
        self.dealerCard1.image = UIImage(named : "\(model!.dealerCards[0])")
        let theText1 = model!.dealerCards[0]
        let textArray1 = theText1.split(separator: "_")
        var count1 = 0
        if textArray1[0] == "jack" || textArray1[0] == "queen" || textArray1[0] == "king"{
            count1 = 10
        }else{
            count1 = Int("\(textArray1[0])")!
        }
        dealerCount += count1
        
        
        self.dealerCard2.image = UIImage(named : "back")
        
    
    }
    
    func dealerTurn(){
            model!.blackjackHitDealer()
            self.dealerCard2.image = UIImage(named: "\(model!.dealerCards[1])")
            let theText = model!.dealerCards[1]
            let textArray = theText.split(separator: "_")
            var count = 0
            if textArray[0] == "jack" || textArray[0] == "queen" || textArray[0] == "king"{
                count = 10
            }else{
                count = Int("\(textArray[0])")!
            }
            dealerCount += count
            self.dealerCounter.text = "\(dealerCount)"
        
        if dealerCount>16{
            evaluateWinner()
        }else{
            
            if dealerCount <= 16 {
                
                model?.blackjackHitDealer()
                self.dealerCard3.image = UIImage(named: "\(model!.dealerCards[2])")
                let theText1 = model!.dealerCards[2]
                let textArray1 = theText1.split(separator: "_")
                var count1 = 0
                if textArray1[0] == "jack" || textArray1[0] == "queen" || textArray1[0] == "king"{
                    count1 = 10
                }else{
                    count1 = Int("\(textArray1[0])")!
                }
                dealerCount += count1
                self.dealerCounter.text = "\(dealerCount)"
                
                if dealerCount < 16 {
                    model?.blackjackHitDealer()
                    self.dealerCard4.image = UIImage(named: "\(model!.dealerCards[3])")
                    let theText2 = model!.dealerCards[3]
                    let textArray2 = theText2.split(separator: "_")
                    var count2 = 0
                    if textArray2[0] == "jack" || textArray2[0] == "queen" || textArray2[0] == "king"{
                        count2 = 10
                    }else{
                        count2 = Int("\(textArray2[0])")!
                    }
                    dealerCount += count2
                    self.dealerCounter.text = "\(dealerCount)"
                    if dealerCount < 16 {
                        model?.blackjackHitDealer()
                        self.dealerCard5.image = UIImage(named: "\(model!.dealerCards[4])")
                        let theText3 = model!.playerCards[4]
                        let textArray3 = theText3.split(separator: "_")
                        var count3 = 0
                        if textArray3[0] == "jack" || textArray3[0] == "queen" || textArray3[0] == "king"{
                            count3 = 10
                        }else{
                            count3 = Int("\(textArray3[0])")!
                        }
                        dealerCount += count3
                        self.dealerCounter.text = "\(dealerCount)"
                        if dealerCount <= 21 {
                            if playerCount == 21 && dealerCount == 21 {
                                print( " THE IMPOSSIBLE TIE")
                                self.dealerCounter.text = "\(dealerCount)"
                            } else{
                                evaluateWinner()
                                self.dealerCounter.text = "\(dealerCount)"
                            }
                        }
                        
                    }else{
                        evaluateWinner()
                        self.dealerCounter.text = "\(dealerCount)"
                    }
                }else{
                    evaluateWinner()}
                self.dealerCounter.text = "\(dealerCount)"
            }
        }
        gameStarted = false
       
    }
            
    @IBAction func hit(_ sender: Any){
        if gameStarted == false {
            return
        }
        
        print("HAS HIT")
        playCardFlipSound()
    
        model?.blackjackHit()
        if model?.playerCards.count == 2 {
            self.playerCard2.image = UIImage(named: model!.playerCards[1])
            let theText = model!.playerCards[1]
            let textArray = theText.split(separator: "_")
            var count = 0
            if textArray[0] == "jack" || textArray[0] == "queen" || textArray[0] == "king"{
                count = 10
            }else{
                count = Int("\(textArray[0])")!
            }
            playerCount += count
        }
        else if model?.playerCards.count == 3 {
            self.playerCard3.image = UIImage(named: model!.playerCards[2])
            let theText = model!.playerCards[2]
            let textArray = theText.split(separator: "_")
            var count = 0
            if textArray[0] == "jack" || textArray[0] == "queen" || textArray[0] == "king"{
                count = 10
            }else{
                count = Int("\(textArray[0])")!
            }
            playerCount += count
        }
        else if model?.playerCards.count == 4 {
            self.playerCard4.image = UIImage(named: model!.playerCards[3])
            let theText = model!.playerCards[3]
            let textArray = theText.split(separator: "_")
            var count = 0
            if textArray[0] == "jack" || textArray[0] == "queen" || textArray[0] == "king"{
                count = 10
            }
            else{
                count = Int("\(textArray[0])")!
            }
            playerCount += count
        }
        else if model?.playerCards.count == 5 {
            self.playerCard5.image = UIImage(named: model!.playerCards[4])
            let theText = model!.playerCards[4]
            let textArray = theText.split(separator: "_")
            var count = 0
            if textArray[0] == "jack" || textArray[0] == "queen" || textArray[0] == "king"{
                count = 10
            }
            else{
                count = Int("\(textArray[0])")!
            }
            playerCount += count
            
            if playerCount <= 21 {
                evaluateWinner()
            }
        }
        if playerCount > 21 {
            evaluateBust()
        }
        self.playerCounter.text = "\(playerCount)"
    }
    
    
    
    @IBAction func double(_ sender: Any){
        if gameStarted == false {
            return
        }

        print("HAS DOUBLE")
        if(model!.balance - bet >= 0){
            bet = bet*2
            betLabel.text = "bet: \(bet)"
            model!.bet = bet
            //model!.blackjackDouble()
        } else{
            return
        }
        hit(doubleButton!)
        self.playerCounter.text = "\(playerCount)"
        dealerTurn()
    }
    
    @IBAction func standButton(_ sender: Any){
        if gameStarted == false {
            return
        }
     dealerTurn()
        
    }
    
    @IBAction func split(_ sender: Any){
        if gameStarted == false {
            return
        }

     
        model!.blackjackSplit()
        
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
    
    @IBAction func ready(_ sender: Any){
        
        if model!.balance - bet < 0{
            return
        }
        
        playerCounter.text = "0"
        dealerCounter.text = "0"
        playerCount = 0
        dealerCount = 0
        
        playerCard1.image = UIImage(named: "back")
        playerCard2.image = UIImage()
        playerCard3.image = UIImage()
        playerCard4.image = UIImage()
        playerCard5.image = UIImage()
        dealerCard1.image = UIImage(named: "back")
        dealerCard2.image = UIImage()
        dealerCard3.image = UIImage()
        dealerCard4.image = UIImage()
        dealerCard5.image = UIImage()
        status.image = UIImage()
        
        startBlackjack()
        gameStarted = true
        model!.balance -= bet
        balanceLabel.text = "GEM COUNT - " + "\(model!.balance)"
        
    }
    
    func playCardFlipSound() {
            guard let url = Bundle.main.url(forResource: "flipcard-91468", withExtension: "mp3") else {
                print("Sound file not found")
                return
            }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    
}
