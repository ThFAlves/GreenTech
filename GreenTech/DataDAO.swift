//
//  PersonDAO.swift
//  Exercicio
//
//  Created by HyagoHirai on 13/07/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import Foundation
import CoreData

class DataDAO {
    
    static func insert(_ objectToBeInserted: DataCD) {
        // insert element into context
        DatabaseManager.sharedInstance.managedObjectContext?.insert(objectToBeInserted)
        
        // save context
        let error:NSErrorPointer? = nil
        do {
            try DatabaseManager.sharedInstance.managedObjectContext?.save()
        } catch let error1 as NSError {
            error??.pointee = error1
        }
        
        if error != nil {
            // log error
            print(error, terminator: "")
        }
    }
    
    static func delete(_ objectToBeDeleted: DataCD) {
        // remove object from context
        let error:NSErrorPointer? = nil
        DatabaseManager.sharedInstance.managedObjectContext?.delete(objectToBeDeleted)
        do {
            try DatabaseManager.sharedInstance.managedObjectContext?.save()
        } catch let error1 as NSError {
            error??.pointee = error1
        }
        
        if error != nil {
            print(error, terminator: "")
        }
    }
    
    static func findByName(_ name: String) -> DataCD? {
        // creating fetch request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DataCD")
        
        // assign predicate
        request.predicate = NSPredicate(format: "name == %@", name)
        
        // perform search
        let results:[DataCD] = (try! DatabaseManager.sharedInstance.managedObjectContext?.fetch(request)) as! [DataCD]
        
        return results[0]
    }
    
    static func returnAll() -> [DataCD]? {
        // creating fetch request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DataCD")
        
        // perform search
        let results:[DataCD] = (try! DatabaseManager.sharedInstance.managedObjectContext?.fetch(request)) as! [DataCD]
        
        return results
    }

}
