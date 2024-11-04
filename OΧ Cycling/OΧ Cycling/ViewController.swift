//
//  ViewController.swift
//  OΧ Cycling
//
//  Created by Charles Carroll on 9/18/24.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    var appDelegate: AppDelegate?
    var model: cycling_model?
    @IBOutlet weak var enterEmail: UITextField!
    @IBOutlet weak var enterPass: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.model = self.appDelegate?.model
        
        model!.checkAndResetWeeklyMiles()
        
        loginButton.layer.borderWidth = 3.0
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.layer.cornerRadius = 10.0
        
        errorLabel.isHidden = true
        let emailText = NSAttributedString(string: "Enter Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        enterEmail.attributedPlaceholder = emailText
        let passText = NSAttributedString(string: "Enter Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        enterPass.attributedPlaceholder = passText
    }
    
    @IBAction func login(_ sender: UIButton) {
        sender.alpha = 1.0
        guard let email = enterEmail.text else {return}
        guard let password = enterPass.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in if let e = error {
            self.errorLabel.isHidden = false}
            else {
                self.performSegue(withIdentifier: "pastLogin", sender: self)
            }
        }
    }
    
    //highlight
    @objc func buttonTouchDown(_ sender: UIButton) {
        sender.alpha = 0.5
    }

}

