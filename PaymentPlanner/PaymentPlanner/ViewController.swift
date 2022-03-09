//
//  ViewController.swift
//  PaymentPlanner
//
//  Created by ali on 8.03.2022.
//

import Firebase
import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.passwordText.isSecureTextEntry = true
        
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Hataa", messageInput: error?.localizedDescription ?? "Firebase Hatası")
                } else {
                    self.performSegue(withIdentifier: "toPaymentTabBar", sender: nil)
                }
            }
            
        } else {
            makeAlert(titleInput: "Hata", messageInput: "Hoop nereye??")
        }
    }
    
    func makeAlert(titleInput: String , messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
        
    }
}

