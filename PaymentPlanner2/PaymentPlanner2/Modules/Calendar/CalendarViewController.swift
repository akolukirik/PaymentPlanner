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

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    var dateArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.dataSource = self
        calendar.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    var datesWithEvent = ["03/03/2022","05/03/2022","09/03/2022","20/03/2022"]

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let dateString = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        return 0
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        print("***********")
        print(dateArray)
        print("***********")
    }
}
