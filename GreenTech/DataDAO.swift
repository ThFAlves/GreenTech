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
    
    static func insert(objectToBeInserted: DataCD) {
        // insert element into context
        DatabaseManager.sharedInstance.managedObjectContext?.insertObject(objectToBeInserted)
        
        // save context
        let error:NSErrorPointer = nil
        do {
            try DatabaseManager.sharedInstance.managedObjectContext?.save()
        } catch let error1 as NSError {
            error.memory = error1
        }
        
        if error != nil {
            // log error
            print(error, terminator: "")
        }
    }
    
    static func delete(objectToBeDeleted: DataCD) {
        // remove object from context
        let error:NSErrorPointer = nil
        DatabaseManager.sharedInstance.managedObjectContext?.deleteObject(objectToBeDeleted)
        do {
            try DatabaseManager.sharedInstance.managedObjectContext?.save()
        } catch let error1 as NSError {
            error.memory = error1
        }
        
        if error != nil {
            print(error, terminator: "")
        }
    }
    
    static func findByName(name: String) -> DataCD? {
        // creating fetch request
        let request = NSFetchRequest(entityName: "DataCD")
        
        // assign predicate
        request.predicate = NSPredicate(format: "name == %@", name)
        
        // perform search
        let results:[DataCD] = (try! DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as! [DataCD]
        
        return results[0]
    }
    
    static func returnAll() -> [DataCD]? {
        // creating fetch request
        let request = NSFetchRequest(entityName: "DataCD")
        
        // perform search
        let results:[DataCD] = (try! DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as! [DataCD]
        
        return results
    }

}