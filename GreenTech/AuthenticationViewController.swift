//
//  ViewController.swift
//  GreenTech
//
//  Created by HyagoHirai on 09/08/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SystemConfiguration
import CryptoSwift

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let connection = VerifyConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (FIRAuth.auth()?.currentUser != nil) {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "cowsName")
            self.show(controller!, sender:  nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        if connection.isConnectedToNetwork() == true {
            if self.emailField.text == "" || self.passwordField.text == "" {
                self.showErrorAlert("Please enter an email and password.")
            }else{
                authLogin()
            }
        }else{
            authOfflineLogin()
        }
    }
    
    func authLogin() {
        FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: {(user,error) in
            if error == nil {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "cowsName")
                self.show(controller!, sender:  nil)
                
            }else{
                self.showErrorAlert((error?.localizedDescription)!)
            }
        })
    }
    
    func authOfflineLogin() {
        let result = LoginDAO.findByUserName(self.emailField.text!)
        
        if result != nil && result!.password == self.passwordField.text!.md5() {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "cowsName")
            self.show(controller!, sender:  nil)
        }else{
            self.showErrorAlert("Incorrect email or password")
        }
    }
    
    fileprivate func showErrorAlert(_ message: String) {
        let alertController = UIAlertController(title: "Ooops!", message: message , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController,animated: true, completion: nil)
    }
    
}
