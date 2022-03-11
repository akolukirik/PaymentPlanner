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
    var chosenPaymentId: UUID?
    lazy var selectedObject: NSManagedObject? = {
        return prepareSelectedObject()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = ""
        priceLabel.text = ""

        if let selectedObject = selectedObject {
            if let description = selectedObject.value(forKey: "paymentType") as? String {
                descriptionLabel.text = description
            }

            if let price = selectedObject.value(forKey: "price") as? String {
                priceLabel.text = String(price)
            }

            if let date = selectedObject.value(forKey: "date") as? Date {
                datePicker.date = date
            }
        }

       // let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
       // view.addGestureRecognizer(tap)
        
    }

    func prepareSelectedObject() -> NSManagedObject? {
        guard let chosenPaymentId = chosenPaymentId else {
            return nil
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PaymentDB")
        let idString = chosenPaymentId.uuidString

        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false

        guard let results = try? context.fetch(fetchRequest) else { return nil }

        return results.first as? NSManagedObject
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let paymentObject: NSManagedObject
        if let selectedObject = selectedObject {
            paymentObject = selectedObject
            paymentObject.setValue(chosenPaymentId, forKey: "id")
        } else {
            paymentObject = NSEntityDescription.insertNewObject(forEntityName: "PaymentDB", into: context)
            paymentObject.setValue(UUID(), forKey: "id")
        }


        paymentObject.setValue(descriptionLabel.text, forKey: "paymentType")
        paymentObject.setValue(priceLabel.text, forKey: "price")
        paymentObject.setValue(datePicker.date, forKey: "date")
        
        do {
            try context.save()
            print("uldi")
            // print(datePicker.date)
        } catch  {
            print("aglaaa")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }

    /*@objc func hideKeyboard() {
        view.endEditing(true)
    }*/
}
