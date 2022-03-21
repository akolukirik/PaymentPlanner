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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datesWithEvent.removeAll(keepingCapacity: false)
        NotificationCenter.default.addObserver(self, selector: #selector(getDateData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        qweqwe()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func qweqwe() {
        for x in 0..<dateArray.count {
            let newDateFormat = dateFormatter.string(from: dateArray[x])
            datesWithEvent.append("\(newDateFormat)")
        }
        self.calendar.reloadData()
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
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
}
