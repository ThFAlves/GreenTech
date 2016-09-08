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
    
    @IBAction func createAccount(sender: AnyObject) {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            self.showErrorAlert("Please enter an email and password.")
        }else{
            FIRAuth.auth()?.createUserWithEmail(self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user,error) in
                
                if error == nil {
                    let email = self.emailTextField.text!
                    let password = self.passwordTextField.text!
                    let passwordMD5 = password.md5()
                    LoginServices.createDataCD(email, password: passwordMD5)
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    self.showErrorAlert((error?.localizedDescription)!)
                }
            })

        }
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Ooops!", message: message , preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController,animated: true, completion: nil)
    }

}
