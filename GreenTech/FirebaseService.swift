//
//  FirebaseService.swift
//  GreenTech
//
//  Created by HyagoHirai on 06/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class FirebaseService {
    
    let databaseRef = FIRDatabase.database().reference()
    let storageRef = FIRStorage.storage().reference()
    let dateStringFunctions = DateString()
    
    func takeValueFromDatabase(path: String, queryType: QueryType, completionHandler: @escaping ([MilkInfo]) -> ()) {
        databaseRef.child(path).observe(.value) { (snap: FIRDataSnapshot) in
            var milkInfo = [MilkInfo]()
            
            if !snap.exists() {
                return
            }
            switch queryType {
            
            case .Day:
                milkInfo.append(MilkInfo(snapshot: snap))
                break;
            case .Week:
                milkInfo.append(MilkInfo(snapshot: snap))
                break;
            case .Month:
                milkInfo = self.getMilkDayFromDatabase(days: snap)
                break;
            case .Year:
                for month in snap.children {
                    let newValue = month as! FIRDataSnapshot
                    milkInfo.append(self.getMilkYearFromDatabase(days: newValue))
                }
                break;
            default:
                break;
            }
            completionHandler(milkInfo)
        }
    }
    
    func getMilkDayFromDatabase(days: FIRDataSnapshot) -> [MilkInfo]{
        var milkInfo = [MilkInfo]()
       
        for day in days.children {
            milkInfo.append(MilkInfo(snapshot: day as! FIRDataSnapshot))
        }
        
        return milkInfo
    
    }
    
    func getMilkYearFromDatabase(days: FIRDataSnapshot) -> MilkInfo{
        let sumMilkInfo = getSumOfMilkInfo(days: days)
        let month = sumMilkInfo.0
        let year = sumMilkInfo.1
        let milkInfo = sumMilkInfo.2

        return MilkInfo(newInterConsume: milkInfo.internConsume! ,newDate: "01-\(month)-\(year)", newLost: milkInfo.lost!, newProduced: milkInfo.produced!, newSold: milkInfo.sold!)
        
    }
    
    func getSumOfMilkInfo(days: FIRDataSnapshot) -> (Int, Int, MilkInfo) {
        var milkInfo = MilkInfo(newInterConsume: 0, newDate: "", newLost: 0, newProduced: 0, newSold: 0)
        var month = 0
        var year = 0
        for day in days.children {
            let milk = MilkInfo(snapshot: day as! FIRDataSnapshot)
            
            if let intern = milk.internConsume {
                milkInfo.internConsume?.add(intern)
            }
            
            if let lost = milk.lost {
                milkInfo.lost?.add(lost)
            }
            
            if let produced = milk.produced {
                milkInfo.produced?.add(produced)
            }
            
            if let sold = milk.sold {
                milkInfo.sold?.add(sold)
            }
            
            if let date = milk.date {
                let day = dateStringFunctions.getFormattedDay(day: date)
                let calendar = Calendar.current
                month = calendar.component(.month, from: day)
                year = calendar.component(.year, from: day)
            }
            
        }
        return(month,year,milkInfo)
    }
    
    func saveMilkInfoDatabase(dictionary: [String: Any]) {
        var newDictionary = dictionary
        if let dateFromDictionary = newDictionary["Data"] {
            let date = dateStringFunctions.getFormattedDayReverse(dateString: dateFromDictionary as! String)
            let hour = dateStringFunctions.hourToString(date: date)
            let dateString = dateStringFunctions.dateToString(date: date)
            let pathDate = dateStringFunctions.dateToStringPath(date: date)
            let path = dateStringFunctions.getPathFromDate(dateString: pathDate)
            
            newDictionary["Data"] = dateString
            newDictionary["Hora"] = hour

            databaseRef.child(path).runTransactionBlock({ (currentData: FIRMutableData) in
                currentData.value = newDictionary
                return FIRTransactionResult.success(withValue: currentData)
            })
        }
    }
    
    func saveSaleMilkDatabase(dictionary: [String: Any]) {
        var newDictionary = dictionary
        if let dateFromDictionary = newDictionary["Data"] {
            let date = dateStringFunctions.getFormattedDayReverse(dateString: dateFromDictionary as! String)
            let pathDate = dateStringFunctions.dateToStringPath(date: date)
            var path = dateStringFunctions.getPathFromDate(dateString: pathDate)
            path += "/Vendido"            
            let sale = newDictionary["Vendido"] as! NSNumber
            
            databaseRef.child(path).runTransactionBlock({ (currentData: FIRMutableData) in
                currentData.value = sale
                return FIRTransactionResult.success(withValue: currentData)
            })
        }
    }
}
