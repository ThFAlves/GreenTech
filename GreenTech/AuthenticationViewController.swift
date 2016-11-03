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
import FBSDKLoginKit
import SystemConfiguration
import CryptoSwift
import GoogleSignIn

class AuthenticationViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let connection = VerifyConnection()
    let StoryID = "tabBar"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Email Sign

        if (FIRAuth.auth()?.currentUser != nil) {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: StoryID)
            self.show(controller!, sender:  nil)
        }
        
        // Google Sign
        
        GIDSignIn.sharedInstance().uiDelegate = self

        // Facebook Sign
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        
        loginButton.frame = CGRect(x: 72, y: 550, width: 231, height: 42)
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
                let controller = self.storyboard?.instantiateViewController(withIdentifier: self.StoryID)
                self.show(controller!, sender:  nil)
                
            }else{
                self.showErrorAlert((error?.localizedDescription)!)
            }
        })
    }
    
    func authOfflineLogin() {
        let result = LoginDAO.findByUserName(self.emailField.text!)
        
        if result != nil && result!.password == self.passwordField.text!.md5() {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: StoryID)
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
