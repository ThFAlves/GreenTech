//
//  PersonServices.swift
//  Exercicio
//
//  Created by HyagoHirai on 13/07/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import Foundation
import CoreData

class DataServices {
    
    static func createDataCD(person: String) {
        let m = DataCD()
        m.name = person
        DataDAO.insert(m)
    }
    
    static func deleteDataCD(person: String) {
        
        let auxiliarQueue:NSOperationQueue = NSOperationQueue()
        
        let deleteOperation : NSBlockOperation = NSBlockOperation(block: {
            
            let data: DataCD? = DataDAO.findByName(person)
            
            if (data != nil) {
                // delete data
                DataDAO.delete(data!)
            }
        })
        
        auxiliarQueue.addOperation(deleteOperation)
        
    }
}