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
    @IBOutlet weak var startDate: UIPickerView!
    @IBOutlet weak var endDate: UIPickerView!
    @IBOutlet weak var startPeriodLabel: UILabel!
    @IBOutlet weak var endPeriodLabel: UILabel!
    
    var selectedDateKind : DateSelectionKind?
    var monthsArray : [String] = []
    var yearsArray : [String] = []
    
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
        
        startDate.delegate = self
        startDate.dataSource = self
        
        endDate.delegate = self
        endDate.dataSource = self
        
        guard let dateKind = toKind else { return }
        
        switch (dateKind){
        case DateSelectionKind.MONTH :
            break
            
        case DateSelectionKind.YEAR :
            //Get Current Year into i2
            var formatter : DateFormatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("yyyy")
            
            var year : String  = formatter.string(from: Date())
            
            
//            //Create Years Array from 1960 to This year
//            years = [[NSMutableArray alloc] init];
//            for (int i=2015; i<=year; i++) {
//                [years addObject:[NSString stringWithFormat:@"%d",i]];
//            }
            
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

extension SpinnerViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Teste"
    }
}
