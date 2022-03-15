//
//  NewSymbolAddViewController.swift
//  PaymentPlanner
//
//  Created by ali on 15.03.2022.
//

import UIKit

class NewSymbolAddViewController: UIViewController {

    var symbolArray = [String]()

    @IBOutlet weak var newSymbolLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(symbolArray)
    }

    @IBAction func symbolSavedButtonClicked(_ sender: Any) {
        symbolArray.append(newSymbolLabel.text ?? "")
        print(symbolArray)
    }
}
