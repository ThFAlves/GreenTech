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
    
    var filterDelegate : CalendarFilterSelection?
    
    //MARK - Class methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CALENDAR_TITLE
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startDate.dateDelegate = self
        endDate.dateDelegate = self
        startPeriodView.layer.borderWidth = 1
        startPeriodView.layer.borderColor = customLightGreen.cgColor
        endPeriodView.layer.borderWidth = 1
        endPeriodView.layer.borderColor = customLightGreen.cgColor
    }
    
    //MARK - Actions
    @IBAction func didFinishedPicking(_ sender: AnyObject) {
        if startDate.month > endDate.month {
            showErrorAlert()
        }else {
            filterDelegate?.didSelectMonth(startDate.month, endDate.month)

           // _ to discard resulting view controller
           _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension MonthSpinnerViewController : DateSelection {
    func onDateSelected(_ month: Int, _ year: Int) {
        
        if startDate.hasChanged {
            let startMonthName = DateFormatter().monthSymbols[startDate.month - 1]
            startPeriodLabel.text = "\(START_DATE)\(startMonthName.capitalizingFirstLetter())"
            startPeriodView.backgroundColor = strongGreen
            startPeriodLabel.textColor = UIColor.white
            startPeriodView.layer.borderColor = strongGreen.cgColor
        }else {
            startPeriodLabel.textColor = customLightGreen
            startPeriodView.backgroundColor = UIColor.clear
            startPeriodView.layer.borderColor = customLightGreen.cgColor
        }
        
        if endDate.hasChanged {
            let endMonthName = DateFormatter().monthSymbols[endDate.month - 1]
            endPeriodLabel.text = "\(END_DATE)\(endMonthName.capitalizingFirstLetter())"
            endPeriodLabel.textColor = UIColor.white
            endPeriodView.backgroundColor = strongGreen
            endPeriodView.layer.borderColor = strongGreen.cgColor
        }else {
            endPeriodLabel.textColor = customLightGreen
            endPeriodView.backgroundColor = UIColor.clear
            endPeriodView.layer.borderColor = customLightGreen.cgColor
        }
        
        //        print("start date \(startDate.month) end date \(endDate.month)")
    }
    
    func showErrorAlert(){
        let refreshAlert = UIAlertController(title: ALERT_TITLE, message: ALERT_MESSAGE_MONTH , preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: OK_BTN, style: .default, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
}
