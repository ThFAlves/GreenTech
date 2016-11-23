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
    @IBOutlet weak var startPeriodView: UIView!
    @IBOutlet weak var endPeriodView: UIView!
    
    var startDateHasChanged : Bool = false
    var endDateHasChanged : Bool = false
    
    //MARK - Class methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CALENDAR_TITLE
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startDate.dateDelegate = self
        endDate.dateDelegate = self
    }
    
    //MARK - Actions
    @IBAction func didFinishedPicking(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MonthSpinnerViewController : DateSelection {
    func onDateSelected(_ month: Int, _ year: Int) {
        let startMonthName = DateFormatter().monthSymbols[startDate.month - 1]
        startPeriodLabel.text = startMonthName
        
        let endMonthName = DateFormatter().monthSymbols[endDate.month - 1]
        endPeriodLabel.text = endMonthName
        print("start date \(startDate.month) enddate \(endDate.month)")
    }
}
