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
    
//    func takeValueFromDatabase(_ id: String, year: String, month: String, day: String, completionHandler: @escaping (MilkInfo) -> ()) {
//        databaseRef.child("Fazendas").child(id).child("Coleta").child(year).child(month).child(day).observe(.value) { (snap: FIRDataSnapshot) in
//            let milk = self.createMilkInfoWithSnap(snap)
//            completionHandler(milk)
//        }
//    }
    
    
    func takeMonthValueFromDatabase(_ id: String, year: String, month: String, completionHandler: @escaping ([MilkInfo]) -> ()) {
        databaseRef.child("Fazendas").child(id).child("Coleta").child(year).child(month).observe(.value) { (snap: FIRDataSnapshot) in
            var milkInfo = [MilkInfo]()
            
            for item in snap.children {
                milkInfo.append(MilkInfo(snapshot: item as! FIRDataSnapshot))
            }
            
            completionHandler(milkInfo)
        }
    }
    
    
//    func createMilkInfoWithSnap(_ snap: FIRDataSnapshot) -> MilkInfo{
//        let newValue = snap.value! as AnyObject
//        let cbt = unWrap(value: newValue, key: "CBT")
//        let ccs = unWrap(value: newValue, key: "CCS")
//        let cr = unWrap(value: newValue, key: "CR")
//        let esd = unWrap(value: newValue, key: "ESD")
//        let empresa = unWrap(value: newValue, key: "Empresa")
//        let gor = unWrap(value: newValue, key: "GOR")
//        let lact = unWrap(value: newValue, key: "LACT")
//        let prot = unWrap(value: newValue, key: "PROT")
//        let quantidade = unWrap(value: newValue, key: "Quantidade")
//        let st = unWrap(value: newValue, key: "ST")
//        
//        let milk = MilkInfo(cbt: cbt,ccs: ccs,cr: cr, esd: esd,empresa: empresa, gor: gor, lact: lact, prot: prot,quantidade: quantidade, st: st)
//        
//        return milk
//    }
    
    func unWrap(value: AnyObject, key: String) -> String{
        let newValue = value.object(forKey: key)! as AnyObject
        let valueToString = newValue.description!
        return valueToString
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
