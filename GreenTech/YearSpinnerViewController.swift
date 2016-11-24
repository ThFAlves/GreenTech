//
//  YearSpinnerViewController.swift
//  GreenTech
//
//  Created by Juliana Salgado on 22/11/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import Foundation
import UIKit
import CVCalendar

class YearSpinnerViewController: UIViewController {
    
    //MARK - Outlets and properties
    @IBOutlet weak var startDate: YearPickerView!
    @IBOutlet weak var endDate: YearPickerView!
    @IBOutlet weak var endPeriodLabel: UILabel!
    @IBOutlet weak var startPeriodLabel: UILabel!
    @IBOutlet weak var startPeriodView: UIView!
    @IBOutlet weak var endPeriodView: UIView!
    
    var selectedDateKind : DateSelectionKind?
    
     var filterDelegate : CalendarFilterSelection?
    
    //MARK - Class methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "\(CVDate(date: Date()).year)"
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
        if startDate.year > endDate.year {
            showErrorAlert()
            filterDelegate?.didSelectYear(startDate.year, endDate.year)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension YearSpinnerViewController : DateSelection {
    func onDateSelected(_ month: Int, _ year: Int) {
        
        if startDate.hasChanged {
            startPeriodLabel.text = "\(START_DATE)\(startDate.years[startDate.year-1])"
            startPeriodView.backgroundColor = strongGreen
            startPeriodLabel.textColor = UIColor.white
            startPeriodView.layer.borderColor = strongGreen.cgColor
        }else {
            startPeriodLabel.textColor = customLightGreen
            startPeriodView.backgroundColor = UIColor.clear
            startPeriodView.layer.borderColor = customLightGreen.cgColor
        }
        
        if endDate.hasChanged {
            endPeriodLabel.text = "\(END_DATE)\(endDate.years[endDate.year-1])"
            endPeriodLabel.textColor = UIColor.white
            endPeriodView.backgroundColor = strongGreen
            endPeriodView.layer.borderColor = strongGreen.cgColor
        }else {
            endPeriodLabel.textColor = customLightGreen
            endPeriodView.backgroundColor = UIColor.clear
            endPeriodView.layer.borderColor = customLightGreen.cgColor
        }
        
//        print("start date \(startDate.years[startDate.year-1])  end date \(endDate.years[endDate.year-1])")
    }
    
    
    func showErrorAlert(){
        let refreshAlert = UIAlertController(title: ALERT_TITLE, message: ALERT_MESSAGE_MONTH , preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: OK_BTN, style: .default, handler: nil))
        
        present(refreshAlert, animated: true, completion: nil)
    }
}
