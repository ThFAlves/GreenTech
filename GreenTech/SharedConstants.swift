//
//  SharedConstants.swift
//  GreenTech
//
//  Created by Juliana Salgado on 13/10/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import Foundation

// MARK: - Calendar Strings

let CALENDAR_TITLE = "Período"

// MARK: - Graphics Strings

//MARK: - Segues

let CALENDAR_SEGUE = "viewCalendar"

let MONTH_SPINNER_SEGUE = "viewSpinnerMonth"

let YEAR_SPINNER_SEGUE = "viewSpinnerYear"

let ALERT_TITLE = "Tente novamente"

let ALERT_MESSAGE_MONTH = "Selecione um período válido, o mês inicial deve ser inferior ao mês final"

let ALERT_MESSAGE_YEAR = "Selecione um período válido, o ano inicial deve ser inferior ao ano final"

let OK_BTN = "OK"

let START_DATE = "Inicial: "

let END_DATE = "Final: "

// MARK: - Colors

let baseColor = "#5EB244" //bar green color - que está no zeplin
let baseFontColor = "#3D9B41"
let strongGreen = UIColor(red:0.20, green:0.41, blue:0.20, alpha:1.0)
let customLightGreen = UIColor(red:0.37, green:0.70, blue:0.27, alpha:1.0)

func getMonthFromInt(_ month : Int) -> String{

    var monthName = "Janeiro"

    switch month {
    case 0:
        monthName =  "Janeiro"
        break
    case 1:
        monthName =  "Fevereiro"
        break
    case 2:
        monthName =  "Março"
        break
    case 3:
        monthName =  "Abril"
        break
    case 4:
        monthName =  "Maio"
        break
    case 5:
        monthName =  "Junho"
        break
    case 6:
        monthName =  "Julho"
        break
    case 7:
        monthName =  "Agosto"
        break
    case 8:
        monthName =  "Setembro"
        break
    case 9:
        monthName =  "Outubro"
        break
    case 10:
        monthName =  "Novembro"
        break
    case 11:
        monthName =  "Dezembro"
        break
    default:
        break
    }
    
    return monthName
}
