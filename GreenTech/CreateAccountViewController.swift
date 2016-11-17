//
//  CreateAccountViewController.swift
//  GreenTech
//
//  Created by HyagoHirai on 08/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SystemConfiguration
import CryptoSwift
import LocalAuthentication

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    let connection = VerifyConnection()
    
    @IBAction func createAccount(_ sender: AnyObject) {
        if connection.isConnectedToNetwork() == true {
            if self.emailTextField.text == "" || self.passwordTextField.text == "" {
                self.showErrorAlert("Please enter an email and password.")
            }else{
                createUserAccount()
            }
        }else{
            self.showErrorAlert("There isn't internet connection")
        }
    }
    
    func createUserAccount() {
        FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user,error) in
            
            if error == nil {
                let email = self.emailTextField.text!
                let password = self.passwordTextField.text!
                let passwordMD5 = password.md5()
                let id = user?.uid
                LoginServices.createDataCD(email, password: passwordMD5, id: id!)
                let _ = self.navigationController?.popViewController(animated: true)
            }else{
                self.showErrorAlert((error?.localizedDescription)!)
            }
        })
    }
    fileprivate func showErrorAlert(_ message: String) {
        let alertController = UIAlertController(title: "Ooops!", message: message , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController,animated: true, completion: nil)
    }

}
