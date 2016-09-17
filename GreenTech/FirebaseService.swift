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

    func uploadDataStorage(data: NSData, path: String) {
        let imageRef = storageRef.child(path)
        imageRef.putData(data, metadata: nil) { metadata, error in
            if(error != nil) {
                print("ERRO SAVE")
            }else{
                let downloadURL = metadata!.downloadURL()?.absoluteString
                self.saveUrlDatabase(downloadURL!)
                print(downloadURL)
            }
        }
    }
    
    func takeValueFromDatabase(id: String, month: String, day: String, completionHandler: (MilkInfo) -> ()) {
        databaseRef.child("Fazendas").child("ID").child("Coleta").child("09-2016").child("13").observeEventType(.Value) { (snap: FIRDataSnapshot) in
            let milk = self.createMilkInfoWithSnap(snap)
            completionHandler(milk)
        }
    }
    
    func createMilkInfoWithSnap(snap: FIRDataSnapshot) -> MilkInfo{
        let cbt = snap.value!.objectForKey("CBT")?.description
        let ccs = snap.value!.objectForKey("CCS")?.description
        let cr = snap.value!.objectForKey("CR")?.description
        let esd = snap.value!.objectForKey("ESD")?.description
        let empresa = snap.value!.objectForKey("Empresa")?.description
        let gor = snap.value!.objectForKey("GOR")?.description
        let lact = snap.value!.objectForKey("LACT")?.description
        let prot = snap.value!.objectForKey("PROT")?.description
        let quantidade = snap.value!.objectForKey("Quantidade")?.description
        let st = snap.value!.objectForKey("ST")?.description
        
        let milk = MilkInfo(cbt: cbt!,ccs: ccs!,cr: cr!, esd: esd!,empresa: empresa!, gor: gor!, lact: lact!, prot: prot!,quantidade: quantidade!, st: st!)
        
        return milk
    }
    
    func saveUrlDatabase(url: String) {
        databaseRef.child("Hyago").child("Photo").runTransactionBlock({ (currentData: FIRMutableData) in
            currentData.value = url
            return FIRTransactionResult.successWithValue(currentData)
        })
    }
    
    func getUrlDownloadPhoto() {
        databaseRef.child("Hyago").child("Photo").observeEventType(.Value) { (snap: FIRDataSnapshot) in
            self.downloadFromStorage((snap.value?.description)!)
        }
    }
    
    func downloadFromStorage(url: String) {
        let httpsReference = FIRStorage.storage().referenceForURL(url)
        httpsReference.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
            if(error != nil) {
                print("ERRRO UPLOAD")
            }else{
                //let image = UIImage(data: data!)
            }
        }
    }
}
