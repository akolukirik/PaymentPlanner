//
//  PaymentDetailViewController.swift
//  PaymentPlanner
//
//  Created by ali on 8.03.2022.
//

import UIKit
import CoreData

class PaymentDetailViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPayment = NSEntityDescription.insertNewObject(forEntityName: "PaymentDB", into: context)
        
        newPayment.setValue(descriptionLabel.text!, forKey: "paymentType")
        newPayment.setValue(priceLabel.text!, forKey: "price")
        newPayment.setValue(datePicker.date, forKey: "date")
        newPayment.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("uldi")
        } catch  {
            print("aglaaa")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
