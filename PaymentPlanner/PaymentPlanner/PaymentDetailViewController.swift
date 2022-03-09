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
    
    var chosenPayment = ""
    var chosenPaymentId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenPayment != "" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PaymentDB")
            let idString = chosenPaymentId?.uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if let description = result.value(forKey: "paymentType") as? String {
                            descriptionLabel.text = description
                        }
                        
                        if let price = result.value(forKey: "price") as? String {
                            priceLabel.text = String(price)
                        }
                        
                        if let date = result.value(forKey: "date") as? Date {
                            datePicker.date = date
                        }
                    }
                }
                
            } catch {
                print("error")
            }
        } else {
            descriptionLabel.text = ""
            priceLabel.text = ""
        }
        
        //  let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        //  view.addGestureRecognizer(gestureRecognizer)
        
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
            print(datePicker.date)
        } catch  {
            print("aglaaa")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func hideKeyboard() {
        
        view.endEditing(true)
        
    }
}
