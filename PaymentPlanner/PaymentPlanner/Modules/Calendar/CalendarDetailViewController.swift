//
//  CalendarDetailViewController.swift
//  PaymentPlanner
//
//  Created by ali on 9.03.2022.
//

import UIKit
import FSCalendar

class CalendarDetailViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    fileprivate weak var calendar: FSCalendar!
    var formatter = DateFormatter()
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
       
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "yyyy-MM-dd"
       // print(formatter.string(from: date))
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date,
                  at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "yyyy-MM-dd"
        //print(formatter.string(from: date))
    }

    var datesWithEvent = ["2022-03-01", "2022-03-03", "2022-03-12", "2022-03-23"]

    var datesWithMultipleEvents = ["2022-03-25", "2022-03-26", "2022-03-27", "2022-03-28"]

    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let dateString = self.dateFormatter2.string(from: date)

        if self.datesWithEvent.contains(dateString) {
            return 1
        }

        if self.datesWithMultipleEvents.contains(dateString) {
            return 2
        }

        return 0
    }

    
}
