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
    
    //MARK - Class methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(CVDate(date: Date()).year)"
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

extension YearSpinnerViewController : DateSelection {
    func onDateSelected(_ month: Int, _ year: Int) {
        if startDate.year > endDate.year {
            showErrorAlert()
        }else {
            startPeriodLabel.text = "\(startDate.years[year-1])"
            endPeriodLabel.text = "\(endDate.years[year-1])"
            
            print("startdate \(startDate.years[year-1])  enddate \(endDate.years[year-1])")
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
