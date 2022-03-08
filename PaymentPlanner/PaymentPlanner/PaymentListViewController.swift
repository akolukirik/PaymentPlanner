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
    var selectedPayment = ""
    var selectedPaymentId : UUID?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
  @objc func addButtonClicked() {
        selectedPayment = ""
        performSegue(withIdentifier: "toPaymentDetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "deneme"
        return cell
    }
    
    @objc func getData() {
        
        paymentArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
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
                   self.tableView.reloadData()
                }
            }
        } catch {
            print("erroorrrrr")
        }
    }
    
}
