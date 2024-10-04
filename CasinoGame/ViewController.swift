//
//  ViewController.swift
//  CasinoGame
//
//  Created by Charles Carroll on 4/11/24.
//
// Charles Carroll (chajcarr), Anthony Reyes (antreye)
// App Name: Diamond Dunes Casinno
// Final Project Submission Date: 04/28/2024

import UIKit



class ViewController: UIViewController {
    //VIEW CONTROLLER FOR MAIN MENU
    var appDelegate: AppDelegate?
    var model: CasinoModel?

    
    @IBOutlet weak var blackjackButton : UIButton!
    @IBOutlet weak var warButton : UIButton!
    @IBOutlet weak var rulesButton : UIButton!
    @IBOutlet weak var gemsButton : UIButton!
    
    @IBOutlet weak var diamond1 : UIImageView!
    @IBOutlet weak var diamond2 : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.model = self.appDelegate?.model
        
        diamond1.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 1.75)
        diamond2.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.3)
        
    }
    
}

