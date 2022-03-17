//
//  CalendarDetailViewController.swift
//  PaymentPlanner
//
//  Created by ali on 9.03.2022.
//

import UIKit
import FSCalendar
import CoreData

class CalendarDetailViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    fileprivate weak var calendar: FSCalendar!

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    var dateArray = [String]()
    var datesWithEvent:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let calendar = FSCalendar(frame: CGRect(x: 10,
                                                y: 50,
                                                width: 400,
                                                height: 400))
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        self.calendar = calendar

        getDateData()
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let dateString = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        return 0
    }

    @objc func getDateData() {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PaymentDB")
        fetchRequest.returnsObjectsAsFaults = false

        if let results = try? context.fetch(fetchRequest) {
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let date = result.value(forKey: "date") as? String {
                        self.dateArray.append(date)
                    }
                }
            }
        }
    }

    @IBAction func buttonClicked(_ sender: Any) {
        print("***********")
        print(dateArray)
        print("***********")
    }
}
