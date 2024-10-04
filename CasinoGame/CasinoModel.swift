//
//  CasinoModel.swift
//  CasinoGame
//
//  Created by Charles Carroll on 4/11/24.
//
// Charles Carroll (chajcarr), Anthony Reyes (antreye)
// App Name: Diamond Dunes Casinno
// Final Project Submission Date: 04/28/2024

import Foundation

class CasinoModel: NSObject, NSCoding, NSSecureCoding, Decodable, Encodable {
    
    
    init(balance: Int){
        self.balance = balance
    }
    
    static var supportsSecureCoding: Bool{
        return true
    }
    
    required convenience init?(coder decoder: NSCoder){
        guard let b = decoder.decodeInteger(forKey: "balance") as Int? else{
            return nil;
        }
        self.init(balance: b)
    }
    
    func encode(with coder: NSCoder) {
            coder.encode(balance, forKey: "balance")
        }
    
    var balance : Int;
    var bet = 0 ;
    var winStatus = false ;

    
    var cards1 = [ "spade", "clubs", "heart", "diamondCard"]
    var cards = ["ace_of_spades","ace_of_clubs","ace_of_hearts","ace_of_diamonds","2_of_spades","2_of_clubs","2_of_hearts","2_of_diamonds","3_of_spades","3_of_clubs","3_of_hearts","3_of_diamonds","4_of_spades","4_of_clubs","4_of_hearts","4_of_diamonds","5_of_spades","5_of_clubs","5_of_hearts","5_of_diamonds","6_of_spades","6_of_clubs","6_of_hearts","6_of_diamonds","7_of_spades","7_of_clubs","7_of_hearts","7_of_diamonds","8_of_spades","8_of_clubs","8_of_hearts","8_of_diamonds","9_of_spades","9_of_clubs","9_of_hearts","9_of_diamonds","10_of_spades","10_of_clubs","10_of_hearts","10_of_diamonds","jack_of_spades2","jack_of_clubs2","jack_of_hearts2","jack_of_diamonds2","queen_of_spades2","queen_of_clubs2","queen_of_hearts2","queen_of_diamonds2","king_of_spades2","king_of_clubs2","king_of_spades2","king_of_diamonds2"]
    var cards2 = ["2_of_spades","2_of_clubs","2_of_hearts","2_of_diamonds","3_of_spades","3_of_clubs","3_of_hearts","3_of_diamonds","4_of_spades","4_of_clubs","4_of_hearts","4_of_diamonds","5_of_spades","5_of_clubs","5_of_hearts","5_of_diamonds","6_of_spades","6_of_clubs","6_of_hearts","6_of_diamonds","7_of_spades","7_of_clubs","7_of_hearts","7_of_diamonds","8_of_spades","8_of_clubs","8_of_hearts","8_of_diamonds","9_of_spades","9_of_clubs","9_of_hearts","9_of_diamonds","10_of_spades","10_of_clubs","10_of_hearts","10_of_diamonds","jack_of_spades2","jack_of_clubs2","jack_of_hearts2","jack_of_diamonds2","queen_of_spades2","queen_of_clubs2","queen_of_hearts2","queen_of_diamonds2","king_of_spades2","king_of_clubs2","king_of_spades2","king_of_diamonds2"]
    var playerCards: [String] = []
    var dealerCards: [String] = []
    
    
    
    func add10Gems() {
        balance = 10 + balance
        print("added 10")
    }
    func add25Gems() {
        balance = 25 + balance
        print("added 25")
    }
    func add50Gems() {
        balance = 50 + balance
        print("added 50")
    }
    func add150Gems() {
        balance = 150 + balance
        print("added 150")
    }
    
    
    
    func startOfGame(){
        playerCards = []
        dealerCards = []
        blackjackHit()
        blackjackHit()
        blackjackHitDealer()
        
        
    }
    
    
    func blackjackHit(){
        let lCurrentPlayerIndex = Int.random(in: 0..<self.cards2.count)
        playerCards.append(cards2[lCurrentPlayerIndex])
        if playerCards.count == 5 {
            blackjackWinGame()
        }
    }
    func blackjackHitDealer(){
        let lCurrentPlayerIndex = Int.random(in: 0..<self.cards2.count)
        dealerCards.append(cards2[lCurrentPlayerIndex])
        print("dealer has hit \(cards2[lCurrentPlayerIndex])")
        print("\(dealerCards)")
        if dealerCards.count == 5 {
            blackjackWinGame()
        }
    }
    
    
    func blackjackDouble(){
        
        bet = bet*2
        
        let lCurrentPlayerIndex = Int.random(in: 0..<self.cards.count)
        playerCards.append(cards[lCurrentPlayerIndex])
        if playerCards.count == 5 {
            blackjackWinGame()        }
    
    }
   
    func blackjackSplit() {
        
    }

    
    func blackjackWinGame(){
        winStatus = true
        balance = balance + bet * 2
        bet = 0
        playerCards.removeAll()
        dealerCards.removeAll()
    }
    func blackjackLostGame(){
        winStatus = false 
        bet = 0
        playerCards.removeAll()
        dealerCards.removeAll()
    }
    func blackjackTie(){
        winStatus = false
        bet = balance + bet/2
        playerCards.removeAll()
        dealerCards.removeAll()
        
    }
    
    
    

}
