//
//  DateString.swift
//  GreenTech
//
//  Created by HyagoHirai on 21/10/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import Foundation

class DateString {
    private let calendar = Calendar.current
    
    func getCurrentDate() -> (Int,Int,Int) {
        let date = Date()
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        return (day,month,year)
    }
    
    func getFormattedDay(day: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let day = dateFormatter.date(from: day) {
            return day
        }
        return Date()
    }
    
    func getFormattedDayReverse(dateString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        return Date()
    }
    
    func dateToStringPath(date: Date) -> String {
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let dayFormatted = String(format: "%.2d", day)
        return "\(year)/\(month)/\(dayFormatted)"
    }
    
    func hourToString(date: Date) -> String {
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return "\(hour):\(minute)"
    }
    
    func dateToString(date: Date) -> String {
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let dayFormatted = String(format: "%.2d", day)
        return "\(dayFormatted)-\(month)-\(year)"
    }
    
    func getPathFromDate(dateString: String) -> String {
        return "Fazendas/ID/Coleta/\(dateString)"
    }
    
    func decreaseDate(calendar: Calendar, date: Date) -> Date{
        return calendar.date(byAdding: .day, value: -1, to: date)!
    }
}
