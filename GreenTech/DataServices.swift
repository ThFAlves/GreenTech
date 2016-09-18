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
    
    static func createDataCD(_ person: String) {
        let data = DataCD()
        data.name = person
        DataDAO.insert(data)
    }
    
    static func deleteDataCD(_ person: String) {
        
        let auxiliarQueue:OperationQueue = OperationQueue()
        
        let deleteOperation : BlockOperation = BlockOperation(block: {
            
            let data: DataCD? = DataDAO.findByName(person)
            
            if (data != nil) {
                // delete data
                DataDAO.delete(data!)
            }
        })
        
        auxiliarQueue.addOperation(deleteOperation)
        
    }
}
