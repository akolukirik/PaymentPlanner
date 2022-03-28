//
//  CalendarViewController.swift
//  PaymentPlanner2
//
//  Created by ali on 18.03.2022.
//

import UIKit
import FSCalendar
import CoreData

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    @IBOutlet private weak var calendar: FSCalendar!

    var dateArray = [Date]()
    var datesWithEvent = [String]()

    var longTermArray = [Date]()
    var longTermDatesWithEvent = [String]()

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.dataSource = self
        calendar.delegate = self
        getDateData()
        getLongTermDateData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datesWithEvent.removeAll(keepingCapacity: false)
        longTermDatesWithEvent.removeAll(keepingCapacity: false)
        NotificationCenter.default.addObserver(self, selector: #selector(getDateData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getLongTermDateData), name: NSNotification.Name(rawValue: "newDataLT"), object: nil)
        selectedDays()
        selectedLongTermDays()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func selectedDays() {
        for x in 0..<dateArray.count {
            let newDateFormat = dateFormatter.string(from: dateArray[x])
            datesWithEvent.append("\(newDateFormat)")
        }
        self.calendar.reloadData()
    }

    func selectedLongTermDays() {
        for x in 0..<longTermArray.count {
            let newDateFormatLT = dateFormatter.string(from: longTermArray[x])
            longTermDatesWithEvent.append("\(newDateFormatLT)")
        }
        self.calendar.reloadData()
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        if self.longTermDatesWithEvent.contains(dateString) {
            return 2
        }
        return 0
    }

    @objc func getDateData() {
        dateArray.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PaymentDB")
        fetchRequest.returnsObjectsAsFaults = false
        if let results = try? context?.fetch(fetchRequest) {
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let date = result.value(forKey: "date") as? Date {
                        self.dateArray.append(date)
                    }
                    self.calendar.reloadData()
                }
            }
        }
    }

    @objc func getLongTermDateData() {
        longTermArray.removeAll(keepingCapacity: false)
        let appDelegateLT = UIApplication.shared.delegate as? AppDelegate
        let contextLT = appDelegateLT?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LongTermDB")
        fetchRequest.returnsObjectsAsFaults = false
        if let results = try? contextLT?.fetch(fetchRequest) {
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let date = result.value(forKey: "date") as? Date {
                        self.longTermArray.append(date)
                    }
                    self.calendar.reloadData()
                }
            }
        }
    }
}
