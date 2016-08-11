//
//  PersonCD.swift
//  Exercicio
//
//  Created by HyagoHirai on 13/07/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import CoreData

public final class DataCD: NSManagedObject {
    
    @NSManaged var name: String
    
    convenience init()
    {
        // get context
        let context:NSManagedObjectContext = DatabaseManager.sharedInstance.managedObjectContext!
        
        // create entity description
        let entityDescription:NSEntityDescription? = NSEntityDescription.entityForName("DataCD", inManagedObjectContext: context)
        
        // call super using
        self.init(entity: entityDescription!, insertIntoManagedObjectContext: context)
    }

}