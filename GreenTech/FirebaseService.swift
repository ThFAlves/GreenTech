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
    
    var value: String = ""

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
    
    func takeValueFromDatabase(id: String, month: String, day: String) -> String {
        databaseRef.child("Fazendas").child(id).child("Coleta").child(month).child(day).child("CBT").observeEventType(.Value) { (snap: FIRDataSnapshot) in
            self.downloadFromStorage((snap.value?.description)!)
            
            self.value = (snap.value?.description)!
        }
        
        return value
        
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
