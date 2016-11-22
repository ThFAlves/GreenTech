//
//  MonthYearPicker.swift
//

import UIKit

class YearPickerView: UIPickerView {
    
    var years: [Int]!
    
   
    var year: Int = 0 {
        didSet {
            selectRow(year-1, inComponent: 0, animated: true)
        }
    }
    
    var onDateSelected: ((_ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
        
    }
    
    func commonSetup() {
        self.delegate = self
        self.dataSource = self
        
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...5 {
                years.append(year)
                year += 1
            }
        }
        self.years = years
    }
}

extension YearPickerView : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(years[row])"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let year = self.selectedRow(inComponent: 0)+1
        
        if let block = onDateSelected {
            block(year)
        }
        
        self.year = year
        
    }
}
