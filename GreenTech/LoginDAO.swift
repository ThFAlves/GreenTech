//
//  AppointmentDAO.swift
//  RememberMedication
//
//  Created by guilherme babugia on 02/05/16.
//  Copyright © 2016 Alexandre Calil Marconi. All rights reserved.
//

import Foundation
import CoreData

class LoginDAO {
    
    static func insert(objectToBeInserted: LoginCD) {
        // insert element into context
        DatabaseManager.sharedInstance.managedObjectContext?.insertObject(objectToBeInserted)
        
        // save context
        let error:NSErrorPointer = nil
        do {
            try DatabaseManager.sharedInstance.managedObjectContext?.save()
        } catch let error1 as NSError {
            error.memory = error1
        }
        if (error != nil) {
            // log error
            print(error, terminator: "")
        }
    }
    
    static func delete(objectToBeDeleted: LoginCD) {
        // remove object from context
        let error:NSErrorPointer = nil
        DatabaseManager.sharedInstance.managedObjectContext?.deleteObject(objectToBeDeleted)
        do {
            try DatabaseManager.sharedInstance.managedObjectContext?.save()
        } catch let error1 as NSError {
            error.memory = error1
        }
        
        // log error
        if (error != nil) {
            // log error
            print(error, terminator: "")
        }
    }
    
    static func findByUserName(userName: String) -> LoginCD? {
        // creating fetch request
        let request = NSFetchRequest(entityName: "LoginCD")
        
        // assign predicate
        request.predicate = NSPredicate(format: "userName == %@", userName)
        
        // perform search
        let results:[LoginCD] = (try! DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as! [LoginCD]
        
        return (results.isEmpty) ? nil : results[0]
    }
    
    static func returnAll() -> [LoginCD]? {
        // creating fetch request
        let request = NSFetchRequest(entityName: "LoginCD")
        
        // perform search
        let results:[LoginCD] = (try! DatabaseManager.sharedInstance.managedObjectContext?.executeFetchRequest(request)) as! [LoginCD]
        
        return results
    }
}
