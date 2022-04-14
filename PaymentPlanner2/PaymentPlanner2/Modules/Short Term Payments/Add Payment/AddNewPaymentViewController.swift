//
//  AddNewPaymentViewController.swift
//  PaymentPlanner2
//
//  Created by ali on 17.03.2022.
//

import UIKit
import CoreData

class AddNewPaymentViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var paymentSymbolLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var pickerView = UIPickerView()
    let data = ["💸","🧾","🎯"," 🍔","🏡","👾","👔","🚘"]
    
    var chosenPayment = ""
    var chosenPaymentId: UUID?
    lazy var selectedObject: NSManagedObject? = {
        return prepareSelectedObject()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentSymbolLabel.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        descriptionLabel.text = ""
        priceLabel.text = ""
        
        if let selectedObject = selectedObject {
            if let description = selectedObject.value(forKey: "paymentDescription") as? String {
                descriptionLabel.text = description
            }
            if let price = selectedObject.value(forKey: "price") as? Float {
                priceLabel.text = String(price)
            }
            if let date = selectedObject.value(forKey: "date") as? Date {
                datePicker.date = date
            }
            if let type = selectedObject.value(forKey: "chosenSymbol") as? String {
                paymentSymbolLabel.text = type
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func prepareSelectedObject() -> NSManagedObject? {
        guard let chosenPaymentId = chosenPaymentId else {
            return nil
        }
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PaymentDB")
        let idString = chosenPaymentId.uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        guard let results = try? context?.fetch(fetchRequest) else { return nil }
        
        return results.first as? NSManagedObject
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        if descriptionLabel.text != "" && priceLabel.text != "" && paymentSymbolLabel.text != "" {
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
            paymentObject.setValue(descriptionLabel.text, forKey: "paymentDescription")
            paymentObject.setValue(Float(priceLabel.text ?? ""), forKey: "price")
            paymentObject.setValue(datePicker.date, forKey: "date")
            paymentObject.setValue(paymentSymbolLabel.text, forKey: "chosenSymbol")
            do {
                try context.save()
            } catch  {
                print("error")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        else {
            makeAlert(title: "Boş Alan", message: "Lüfen bütün alanları doldurunuz.")
        }
    }
    
    @IBAction func backButtonclicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddNewPaymentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        paymentSymbolLabel.text = data[row]
        paymentSymbolLabel.resignFirstResponder()
    }
}
