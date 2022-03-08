//
//  PaymentListViewController.swift
//  PaymentPlanner
//
//  Created by ali on 8.03.2022.
//

import UIKit
import CoreData

class PaymentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var paymentArray = [String]()
    var idArray = [UUID]()
    var totalPriceArray = [String]()
    var selectedPayment = ""
    var selectedPaymentId : UUID?
    
    @IBOutlet weak var toplamLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        getData()
        totalPriceCalculate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
      totalPriceCalculate()
    }
    
    @objc func addButtonClicked() {
        selectedPayment = ""
        performSegue(withIdentifier: "toPaymentDetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = paymentArray[indexPath.row]
        return cell
    }
    
    @objc func getData() {
        
        paymentArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        totalPriceArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PaymentDB")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let payment = result.value(forKey: "paymentType") as? String {
                        self.paymentArray.append(payment)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                    if let price = result.value(forKey: "price") as? String {
                        self.totalPriceArray.append(price)
                    }
                    self.tableView.reloadData()
                }
            }
        } catch {
            print("erroorrrrr")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPaymentDetail" {
            let destinationVC = segue.destination as! PaymentDetailViewController
            destinationVC.chosenPayment = selectedPayment
            destinationVC.chosenPaymentId = selectedPaymentId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPayment = paymentArray[indexPath.row]
        selectedPaymentId = idArray[indexPath.row]
        performSegue(withIdentifier: "toPaymentDetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PaymentDB")
            let idString = idArray[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if let id = result.value(forKey: "id") as? UUID {
                            
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                paymentArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                
                                do {
                                    try context.save()
                                    
                                } catch {
                                    print("error")
                                }
                                break
                            }
                        }
                    }
                }
            } catch {
                print("error")
            }
        }
    }
    
    func totalPriceCalculate() {
        var total = 0
        for x in 0...totalPriceArray.count-1 {
            total += Int(totalPriceArray[x])!
        }
        toplamLabel.text = ("Toplam Borç: \(String(total))   ")
    }
    
}
