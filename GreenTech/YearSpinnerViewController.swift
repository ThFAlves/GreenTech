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
        setPickerView()
    }
    
    func setPickerView() {
        
        let startDate = YearPickerView()
        startDate.onDateSelected = { (year: Int) in
            print("year \(year)")
        }
        self.startDate = startDate
        
        let endDate = YearPickerView()
        endDate.onDateSelected = { (year: Int) in
            print("year \(year)")
        }
        self.endDate = endDate
        
    }
    
    //MARK - Actions
    @IBAction func didFinishedPicking(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
