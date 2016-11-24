//
//  MonthPickerView.swift
//  GreenTech
//
//  Created by Thiago Alves on 17/11/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit

protocol DateSelection {
    
    func onDateSelected(_ month: Int , _ year: Int)
}

class MonthPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var month: Int = 0 {
        didSet {
            selectRow(month-1, inComponent: 0, animated: false)
        }
    }
    
    var hasChanged = false
    
    var dateDelegate : DateSelection?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        self.delegate = self
        self.dataSource = self
        
        let month = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        self.month = month
        self.selectRow(month-1, inComponent: 0, animated: false)
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return months[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return months.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRow(inComponent: 0)+1
        self.month = month
        hasChanged = true
        dateDelegate?.onDateSelected(month, 0)
        hasChanged = false
    }
}

