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
    
    // DATABASE
    
    func takeValueFromDatabase(path: String, queryType: QueryType, completionHandler: @escaping ([MilkInfo]) -> ()) {
        databaseRef.child(path).observe(.value) { (snap: FIRDataSnapshot) in
            var milkInfo = [MilkInfo]()
            
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
    
    // STORAGE
    
    func uploadDataStorage(_ data: Data, path: String) {
        let imageRef = storageRef.child(path)
        imageRef.put(data, metadata: nil) { metadata, error in
            if(error != nil) {
                print("ERRO SAVE")
            }else{
                let downloadURL = metadata!.downloadURL()?.absoluteString
                self.saveUrlDatabase(downloadURL!)
                print(downloadURL)
            }
        }
    }
    
    func saveUrlDatabase(_ url: String) {
        databaseRef.child("Hyago").child("Photo").runTransactionBlock({ (currentData: FIRMutableData) in
            currentData.value = url
            return FIRTransactionResult.success(withValue: currentData)
        })
    }
    
    func getUrlDownloadPhoto() {
        databaseRef.child("Hyago").child("Photo").observe(.value) { (snap: FIRDataSnapshot) in
            self.downloadFromStorage(((snap.value as AnyObject).description)!)
        }
    }
    
    func downloadFromStorage(_ url: String) {
        let httpsReference = FIRStorage.storage().reference(forURL: url)
        httpsReference.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if(error != nil) {
                print("ERRRO UPLOAD")
            }else{
                //let image = UIImage(data: data!)
            }
        }
    }
}
