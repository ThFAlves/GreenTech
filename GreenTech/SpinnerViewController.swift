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

class SpinnerViewController: UIViewController {
    
    //MARK - Outlets and properties
    @IBOutlet weak var startDate: MonthPickerView!
    @IBOutlet weak var endDate: MonthYearPickerView!
    @IBOutlet weak var startPeriodLabel: UILabel!
    @IBOutlet weak var endPeriodLabel: UILabel!
    
    var selectedDateKind : DateSelectionKind?
    
    
    //MARK - Class methods
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< Updated upstream
        
        if let dateKind = selectedDateKind {
            if dateKind == .MONTH{
                self.title = "\(CVDate(date: Date()).year)"
            }else {
                self.title = CALENDAR_TITLE
            }
        }else {
            self.title = CALENDAR_TITLE
        }
        
=======
        self.title = CVDate(date: Date()).globalDescription
        
        let startDatee = MonthPickerView()
        startDatee.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            NSLog(string) // should show something like 05/2015
        }
        view.addSubview(startDatee)
        startDatee.frame.origin.x = (view.frame.size.width - startDatee.frame.size.width)/2.0
        startDatee.frame.origin.y = (view.frame.size.height - startDatee.frame.height)/2.0

>>>>>>> Stashed changes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPickerViewAccording(selectedDateKind)
    }
    
    
    func setPickerViewAccording(_ toKind : DateSelectionKind?) {
        
        guard let dateKind = toKind else { return }
        
        switch (dateKind){
        case DateSelectionKind.MONTH :
            print(dateKind)
<<<<<<< Updated upstream
            
            startDate = MonthYearPickerView()
            
            startDate.onDateSelected = { (month: String?, year: Int?) in
                print("month \(month)")
            }
            
=======


>>>>>>> Stashed changes
            endDate = MonthYearPickerView()
//            endDate.onDateSelected = { (month: String?, year: Int?) in
//                print("month \(month)")
//            }
            
            break
            
        case DateSelectionKind.YEAR :
            startDate = MonthPickerView()
            startDate.onDateSelected = { (month: Int?, year: Int?) in
                print("year \(year)")
            }
            
            endDate = MonthYearPickerView()
            endDate.onDateSelected = { (month: String?, year: Int?) in
                print("year \(year)")
            }
            
            
            break
            
        default :
            break
        }
    }
    
    //MARK - Actions
    @IBAction func didFinishedPicking(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
