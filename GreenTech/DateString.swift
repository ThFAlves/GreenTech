//
//  DateString.swift
//  GreenTech
//
//  Created by HyagoHirai on 21/10/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import Foundation

class DateString {
    
    func getCurrentDate() -> (Int,Int,Int) {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        return (day,month,year)
    }
    
    func formattedDay() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }
    
    func getFormattedDay(day: String) -> Date{
        let dateFormatter = formattedDay()
        if let day = dateFormatter.date(from: day) {
            return day
        }
        return Date()
    }
    
    func dateToString(calendar: Calendar, date: Date) -> String {
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let dayFormatted = String(format: "%.2d", day)
        return "\(year)/\(month)/\(dayFormatted)"
    }
    
    func getPathFromDate(dateString: String) -> String {
        return "Fazendas/ID/Coleta/\(dateString)"
    }
    
    func decreaseDate(calendar: Calendar, date: Date) -> Date{
        return calendar.date(byAdding: .day, value: -1, to: date)!
    }
}
