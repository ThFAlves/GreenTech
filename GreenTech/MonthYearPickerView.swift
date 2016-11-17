//
//  MonthYearPicker.swift
//

import UIKit

class MonthYearPickerView: UIPickerView {
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var years: [Int]!
    
    
    var month: Int = 0 {
        didSet {
            selectRow(month-1, inComponent: 0, animated: false)
        }
    }
    
    var year: Int = 0 {
        didSet {
            selectRow(years.index(of: year)!, inComponent: 1, animated: true)
        }
    }
    
    var selectedDateKind : DateSelectionKind?     
    var onDateSelected: ((_ month: String?, _ year: Int?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.commonSetup()
    }
    
    //TODO CRIAR CONSTRUTOR PASSANDO SELECTEDDATEKIND
    
    //    convenience init(dateKind : DateSelectionKind) {
    //        selectedDateKind = dateKind
    //    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        
        selectedDateKind = .MONTH
        
        if selectedDateKind == .MONTH {
            var years: [Int] = []
            if years.count == 0 {
                var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
                for _ in 1...15 {
                    years.append(year)
                    year += 1
                }
            }
            self.years = years
            
        }
        
        if selectedDateKind == .YEAR {
            let month = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
            self.selectRow(month-1, inComponent: 0, animated: false)
        }

        self.delegate = self
        self.dataSource = self
        
    }
}

extension MonthYearPickerView : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedDateKind == .MONTH {
            return months[row]
        }
        
        if selectedDateKind == .YEAR {
            return "\(years[row])"
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if selectedDateKind == .MONTH {
            return months.count
            
        }
        
        if selectedDateKind == .YEAR {
            return years.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let month = months[row]
        let year = years[row]
        
        if selectedDateKind == .MONTH {
            
            self.month = Int(month)!
        }
        if selectedDateKind == .YEAR {
            
            self.year = year
        }
        
        if let block = onDateSelected {
            block(month, year)
        }
    }
}
