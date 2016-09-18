//
//  AppointmentServices.swift
//  RememberMedication
//
//  Created by guilherme babugia on 02/05/16.
//  Copyright © 2016 Alexandre Calil Marconi. All rights reserved.
//

import Foundation

class LoginServices{
    
    static func createDataCD(_ userName: String, password: String){
        let login = LoginCD()
        print("USERNAME COREDATA = " + userName)
        login.userName = userName
        login.password = password
        LoginDAO.insert(login)
    }
    
    static func deleteDataCD(_ userName: String) {
        
        let auxiliarQueue:OperationQueue = OperationQueue()
        
        let deleteOperation : BlockOperation = BlockOperation(block: {
            
            let data: DataCD? = DataDAO.findByName(userName)
            
            if (data != nil) {
                // delete data
                DataDAO.delete(data!)
            }
        })
        
        auxiliarQueue.addOperation(deleteOperation)
        
    }
}
