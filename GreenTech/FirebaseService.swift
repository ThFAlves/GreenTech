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
    
    func takeValueFromDatabase(path: String, completionHandler: @escaping ([MilkInfo]) -> ()) {
        databaseRef.child(path).observe(.value) { (snap: FIRDataSnapshot) in
            var milkInfo = [MilkInfo]()
            
            for item in snap.children {
                milkInfo.append(MilkInfo(snapshot: item as! FIRDataSnapshot))
            }
            
            completionHandler(milkInfo)
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
