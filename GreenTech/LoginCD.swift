//
//  AppointmentCD.swift
//  RememberMedication
//
//  Created by guilherme babugia on 02/05/16.
//  Copyright © 2016 Alexandre Calil Marconi. All rights reserved.
//

import Foundation
import CoreData

class LoginCD: NSManagedObject {
    
    @NSManaged var userName: String
    @NSManaged var password: String

    
    /// The designated initializer
    convenience init() {
        // get context
        let context:NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        // create entity description
        let entityDescription:NSEntityDescription? = NSEntityDescription.entityForName("LoginCD", inManagedObjectContext: context)
        
        // call super using
        self.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
    }
    
}
