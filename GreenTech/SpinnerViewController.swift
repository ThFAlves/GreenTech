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
    @IBOutlet weak var startDate: MonthYearPickerView!
    @IBOutlet weak var endDate: MonthYearPickerView!
    @IBOutlet weak var startPeriodLabel: UILabel!
    @IBOutlet weak var endPeriodLabel: UILabel!
    
    var selectedDateKind : DateSelectionKind?
    
    
    //MARK - Class methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CVDate(date: Date()).globalDescription
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPickerViewAccording(selectedDateKind)
    }
    
    
    func setPickerViewAccording(_ toKind : DateSelectionKind?) {
        
        guard let dateKind = toKind else { return }
        
        switch (dateKind){
        case DateSelectionKind.MONTH :
            startDate = MonthYearPickerView()
            startDate.onDateSelected = { (month: String?, year: Int?) in
                print("month \(month)")
            }
            
            endDate = MonthYearPickerView()
            endDate.onDateSelected = { (month: String?, year: Int?) in
                print("month \(month)")
            }
            
            break
            
        case DateSelectionKind.YEAR :
            startDate = MonthYearPickerView()
            startDate.onDateSelected = { (month: String?, year: Int?) in
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
