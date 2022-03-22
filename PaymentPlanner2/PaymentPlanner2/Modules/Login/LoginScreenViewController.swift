//
//  LoginScreenViewController.swift
//  PaymentPlanner2
//
//  Created by ali on 22.03.2022.
//

import UIKit
import LocalAuthentication

class LoginScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        let authContext = LAContext()
        var error: NSError?
        if authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Lütfen Touch ID İle Giriş Yapınız") {(success, error) in
                if success == true {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toPaymentTabBar", sender: nil)
                    }
                }
            }
        }
    }
}
