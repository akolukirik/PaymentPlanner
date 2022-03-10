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
    
}
