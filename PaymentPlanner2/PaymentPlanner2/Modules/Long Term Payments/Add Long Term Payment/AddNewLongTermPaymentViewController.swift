//
//  AddNewLongTermPaymentViewController.swift
//  PaymentPlanner2
//
//  Created by ali on 28.03.2022.
//

import UIKit
import CoreData

class AddNewLongTermPaymentViewController: UIViewController {

    @IBOutlet weak var descriptionLabelLT: UITextField!
    @IBOutlet weak var priceLabelLT: UITextField!
    @IBOutlet weak var paymentSymbolLabelLT: UITextField!
    @IBOutlet weak var datePickerLT: UIDatePicker!

    var pickerViewLT = UIPickerView()
    let dataLT = ["💸","🧾","🎯"," 🍔","🏡","👾","👔","🚘"]

    var chosenPaymentLT = ""
    var chosenPaymentIdLT: UUID?
    lazy var selectedObjectLT: NSManagedObject? = {
        return prepareSelectedObject()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        paymentSymbolLabelLT.inputView = pickerViewLT
        pickerViewLT.delegate = self
        pickerViewLT.dataSource = self
        descriptionLabelLT.text = ""
        priceLabelLT.text = ""

        if let selectedObject = selectedObjectLT {
            if let description = selectedObject.value(forKey: "paymentDescription") as? String {
                descriptionLabelLT.text = description
            }
            if let price = selectedObject.value(forKey: "price") as? Float {
                priceLabelLT.text = String(price)
            }
            if let date = selectedObject.value(forKey: "date") as? Date {
                datePickerLT.date = date
            }
            if let type = selectedObject.value(forKey: "chosenSymbol") as? String {
                paymentSymbolLabelLT.text = type
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    func prepareSelectedObject() -> NSManagedObject? {
        guard let chosenPaymentId = chosenPaymentIdLT else {
            return nil
        }
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LongTermDB")
        let idString = chosenPaymentId.uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false

        guard let results = try? context?.fetch(fetchRequest) else { return nil }

        return results.first as? NSManagedObject
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        if descriptionLabelLT.text != "" && priceLabelLT.text != "" && paymentSymbolLabelLT.text != "" {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let paymentObject: NSManagedObject

            if let selectedObject = selectedObjectLT {
                paymentObject = selectedObject
                paymentObject.setValue(chosenPaymentIdLT, forKey: "id")
            } else {
                paymentObject = NSEntityDescription.insertNewObject(forEntityName: "LongTermDB", into: context)
                paymentObject.setValue(UUID(), forKey: "id")
            }

            paymentObject.setValue(descriptionLabelLT.text, forKey: "paymentDescription")
            paymentObject.setValue(Float(priceLabelLT.text ?? ""), forKey: "price")
            paymentObject.setValue(datePickerLT.date, forKey: "date")
            paymentObject.setValue(paymentSymbolLabelLT.text, forKey: "chosenSymbol")

            do {
                try context.save()
            } catch  {
                print("error")
            }

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataLT"), object: nil)
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

extension AddNewLongTermPaymentViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataLT[row]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataLT.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        paymentSymbolLabelLT.text = dataLT[row]
        paymentSymbolLabelLT.resignFirstResponder()
    }
}

