//
//  ViewController.swift
//  PaymentPlanner
//
//  Created by ali on 8.03.2022.
//

import Firebase
import UIKit
import CoreData
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var accessLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordText.isSecureTextEntry = true
    }
/*
    @IBAction func touchIdButtonClicked(_ sender: Any) {
        let authContext = LAContext()
        var error: NSError?

        if authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Lütfen Touch ID İle Giriş Yapınız") {(success, error) in
                if success == true {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toPaymentTabBar", sender: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.accessLabel.text = "Tekrar Deneyiniz.."
                    }
                }
            }
        }
    }

    @IBAction func signInButtonClicked(_ sender: Any) {

        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!,
                               password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Hataa",
                                   messageInput: error?.localizedDescription ?? "Firebase Hatası")
                } else {
                    self.performSegue(withIdentifier: "toPaymentTabBar",
                                      sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Hata", messageInput: "Hoop nereye??")
        }
    }

    func makeAlert(titleInput: String , messageInput: String) {

        let alert = UIAlertController(title: titleInput,
                                      message: messageInput,
                                      preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok",
                                     style: UIAlertAction.Style.default,
                                     handler: nil)
        alert.addAction(okButton)
        self.present(alert,
                     animated: true,
                     completion: nil)
    }*/
}

