//
//  ViewController.swift
//  PaymentPlanner2
//
//  Created by ali on 17.03.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var idArray = [UUID]()
    var paymentArray = [String]()
    var priceArray = [String]()
    var dateArray = [Date]()
    var pickerArray = [String]()

    @IBOutlet private weak var paymentDetailsTableView: UITableView!
    @IBOutlet private weak var totalValueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        paymentDetailsTableView.delegate = self
        paymentDetailsTableView.dataSource = self
        paymentDetailsTableView.register(UINib(nibName: "PaymentListTableViewCell",
                                               bundle: nil),
                                         forCellReuseIdentifier: "PaymentListTableViewCell")
        getData()
        totalPriceCalculate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        totalPriceCalculate()
    }

    @IBAction func addPaymentButtonClicked(_ sender: Any) {
        navigateToPaymentDetail()
    }

    func totalPriceCalculate() {
        var total = 0
        for x in 0..<priceArray.count {
            total += Int(priceArray[x]) ?? 0
        }
        totalValueLabel.text = ("Total: \(String(total)) ₺")
    }

    func navigateToPaymentDetail(selectedPayment: String = "", selectedPaymentId: UUID? = nil ) {
        let addPaymentVc = AddNewPaymentViewController.init(nibName: "AddNewPaymentViewController", bundle: nil)
        addPaymentVc.chosenPayment = selectedPayment
        addPaymentVc.chosenPaymentId = selectedPaymentId
        addPaymentVc.modalPresentationStyle = .fullScreen
        self.present(addPaymentVc, animated: true, completion: nil)
    }

    @objc func getData() {
        paymentArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        priceArray.removeAll(keepingCapacity: false)
        dateArray.removeAll(keepingCapacity: false)
        pickerArray.removeAll(keepingCapacity: false)

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PaymentDB")
        fetchRequest.returnsObjectsAsFaults = false
        if let results = try? context?.fetch(fetchRequest) {
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let payment = result.value(forKey: "paymentDescription") as? String {
                        self.paymentArray.append(payment)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArray.append(id)
                    }
                    if let price = result.value(forKey: "price") as? String {
                        self.priceArray.append(price)
                    }
                    if let date = result.value(forKey: "date") as? Date {
                        self.dateArray.append(date)
                    }
                    if let picker = result.value(forKey: "chosenSymbol") as? String {
                        self.pickerArray.append(picker)
                    }
                    self.paymentDetailsTableView.reloadData()
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return idArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentListTableViewCell", for: indexPath) as? PaymentListTableViewCell
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        cell?.descriptionLabel.text = paymentArray[indexPath.section]
        cell?.priceLabel.text = ("\(priceArray[indexPath.section]) ₺ ")
        cell?.symbolLabel.text = pickerArray[indexPath.section]
        cell?.dateLabel.text = formatter.string(from: dateArray[indexPath.section])
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPayment = paymentArray[indexPath.section]
        let selectedPaymentId = idArray[indexPath.section]
        navigateToPaymentDetail(selectedPayment: selectedPayment, selectedPaymentId: selectedPaymentId)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let context = appDelegate?.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PaymentDB")
            let idString = idArray[indexPath.section].uuidString

            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false

            do {
                let results = try context?.fetch(fetchRequest)
                if results?.count ?? 0 > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.section] {
                                context?.delete(result)
                                paymentArray.remove(at: indexPath.section)
                                idArray.remove(at: indexPath.section)
                                dateArray.remove(at: indexPath.section)
                                pickerArray.remove(at: indexPath.section)
                                priceArray.remove(at: indexPath.section)
                                self.paymentDetailsTableView.reloadData()
                                do {
                                    try context?.save()
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
        totalPriceCalculate()
    }
}
