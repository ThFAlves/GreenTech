//
//  SpinnerViewController.swift
//  GreenTech
//
//  Created by Juliana Salgado on 13/10/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import Foundation
import UIKit
import CVCalendar

class MonthSpinnerViewController: UIViewController {
    
    //MARK - Outlets and properties
    @IBOutlet weak var startDate: MonthPickerView!
    @IBOutlet weak var endDate: MonthPickerView!
    @IBOutlet weak var endPeriodLabel: UILabel!
    @IBOutlet weak var startPeriodLabel: UILabel!
    
    //MARK - Class methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CALENDAR_TITLE
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPickerView()
    }
    
    
    func setPickerView() {
        let startDateView = MonthPickerView()
        startDateView.onDateSelected = { (month: Int) in
            let string = String(format: "%02d", month)
            NSLog(string) // should show something like 05/2015
        }
        startDate = startDateView
        
        let endDateView = MonthPickerView()
        endDateView.onDateSelected = { (month: Int) in
            let string = String(format: "%02d", month)
            NSLog(string) // should show something like 05/2015
        }
        endDate = endDateView
        
    }
    
    //MARK - Actions
    @IBAction func didFinishedPicking(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
