//
//  AppointmentServices.swift
//  RememberMedication
//
//  Created by guilherme babugia on 02/05/16.
//  Copyright © 2016 Alexandre Calil Marconi. All rights reserved.
//

import Foundation

class LoginServices{
    
    static func createDataCD(userName: String, password: String){
        let login = LoginCD()
        print("USERNAME COREDATA = " + userName)
        login.userName = userName
        login.password = password
        LoginDAO.insert(login)
    }
    
    static func deleteDataCD(userName: String) {
        
        let auxiliarQueue:NSOperationQueue = NSOperationQueue()
        
        let deleteOperation : NSBlockOperation = NSBlockOperation(block: {
            
            let data: DataCD? = DataDAO.findByName(userName)
            
            if (data != nil) {
                // delete data
                DataDAO.delete(data!)
            }
        })
        
        auxiliarQueue.addOperation(deleteOperation)
        
    }
}
