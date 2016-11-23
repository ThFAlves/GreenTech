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
        if startDate.month > endDate.month {
            showErrorAlert()
        }else {
            let startMonthName = DateFormatter().monthSymbols[startDate.month - 1]
            startPeriodLabel.text = startMonthName.capitalizingFirstLetter()
            
            let endMonthName = DateFormatter().monthSymbols[endDate.month - 1]
            endPeriodLabel.text = endMonthName.capitalizingFirstLetter()
            print("start date \(startDate.month) enddate \(endDate.month)")
        }
    }
    
    func showErrorAlert(){
        let refreshAlert = UIAlertController(title: ALERT_TITLE, message: ALERT_MESSAGE_MONTH , preferredStyle: UIAlertControllerStyle.alert)
        
        //        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        //            print("Handle Ok logic here")
        //        }))
        refreshAlert.addAction(UIAlertAction(title: OK_BTN, style: .default, handler: nil))
        
        present(refreshAlert, animated: true, completion: nil)
    }
}
