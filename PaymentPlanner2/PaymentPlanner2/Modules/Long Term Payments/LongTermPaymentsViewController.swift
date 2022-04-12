//
//  LongTermPaymentsViewController.swift
//  PaymentPlanner2
//
//  Created by ali on 28.03.2022.
//

import UIKit
import CoreData

class LongTermPaymentsViewController: UIViewController {

    var idArrayLT = [UUID]()
    var paymentArrayLT = [String]()
    var priceArrayLT = [Float]()
    var dateArrayLT = [Date]()
    var pickerArrayLT = [String]()

    @IBOutlet weak var longTermTableView: UITableView!
    @IBOutlet weak var longTermValueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        longTermTableView.delegate = self
        longTermTableView.dataSource = self
        longTermTableView.register(UINib(nibName: "PaymentListTableViewCell",
                                         bundle: nil),
                                   forCellReuseIdentifier: "PaymentListTableViewCell")
        getLongTermData()
        longTermTotalPriceCalculate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(getLongTermData), name: NSNotification.Name(rawValue: "newDataLT"), object: nil)
        longTermTotalPriceCalculate()
    }

    @IBAction func addPaymentButtonClicked(_ sender: Any) {
        navigateToPaymentDetail()
    }

    func longTermTotalPriceCalculate() {
        var total: Float = 0.0
        for x in 0..<priceArrayLT.count {
            total += priceArrayLT[x]
        }
        longTermValueLabel.text = ("Total: \(String(total))₺")
    }

    func navigateToPaymentDetail(selectedPayment: String = "", selectedPaymentId: UUID? = nil ) {
        let addPaymentVc = AddNewLongTermPaymentViewController.init(nibName: "AddNewLongTermPaymentViewController", bundle: nil)
        addPaymentVc.chosenPaymentLT = selectedPayment
        addPaymentVc.chosenPaymentIdLT = selectedPaymentId
        addPaymentVc.modalPresentationStyle = .fullScreen
        self.present(addPaymentVc, animated: true, completion: nil)
    }

    @objc func getLongTermData() {
        paymentArrayLT.removeAll(keepingCapacity: false)
        idArrayLT.removeAll(keepingCapacity: false)
        priceArrayLT.removeAll(keepingCapacity: false)
        dateArrayLT.removeAll(keepingCapacity: false)
        pickerArrayLT.removeAll(keepingCapacity: false)

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LongTermDB")
        fetchRequest.returnsObjectsAsFaults = false
        if let results = try? context?.fetch(fetchRequest) {
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let payment = result.value(forKey: "paymentDescription") as? String {
                        self.paymentArrayLT.append(payment)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.idArrayLT.append(id)
                    }
                    if let price = result.value(forKey: "price") as? Float {
                        self.priceArrayLT.append(price)
                    }
                    if let date = result.value(forKey: "date") as? Date {
                        self.dateArrayLT.append(date)
                    }
                    if let picker = result.value(forKey: "chosenSymbol") as? String {
                        self.pickerArrayLT.append(picker)
                    }
                    self.longTermTableView.reloadData()
                }
            }
        }
    }
}

extension LongTermPaymentsViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return idArrayLT.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentListTableViewCell", for: indexPath) as? PaymentListTableViewCell
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        cell?.descriptionLabel.text = paymentArrayLT[indexPath.section]
        cell?.priceLabel.text = ("\(priceArrayLT[indexPath.section]) ₺ ")
        cell?.symbolLabel.text = pickerArrayLT[indexPath.section]
        cell?.dateLabel.text = formatter.string(from: dateArrayLT[indexPath.section])
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPayment = paymentArrayLT[indexPath.section]
        let selectedPaymentId = idArrayLT[indexPath.section]
        navigateToPaymentDetail(selectedPayment: selectedPayment, selectedPaymentId: selectedPaymentId)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let context = appDelegate?.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LongTermDB")
            let idString = idArrayLT[indexPath.section].uuidString

            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false

            do {
                let results = try context?.fetch(fetchRequest)
                if results?.count ?? 0 > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArrayLT[indexPath.section] {
                                context?.delete(result)
                                paymentArrayLT.remove(at: indexPath.section)
                                idArrayLT.remove(at: indexPath.section)
                                dateArrayLT.remove(at: indexPath.section)
                                pickerArrayLT.remove(at: indexPath.section)
                                priceArrayLT.remove(at: indexPath.section)
                                self.longTermTableView.reloadData()
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
        longTermTotalPriceCalculate()
    }
}
