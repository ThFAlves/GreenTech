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

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginFacebookButton: FBSDKLoginButton!

    let connection = VerifyConnection()
    let StoryID = "signSegue"
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    @IBAction func buttonFacebookLogin(_ sender: Any) {
        let permissions = ["public_profile","email"]
        
        FBSDKLoginManager().logIn(withReadPermissions: permissions, from: nil) { [weak self] result, error in
            guard error == nil else {
                print("FB Login error -> \(error)")
                return
            }
            
            guard let result = result, !result.isCancelled else {
                print("Ops! Voce precisa aprovar ....")
                return
            }
            
            print("Login with sucess")
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if error != nil {
                    self?.showErrorAlert((error?.localizedDescription)!)
                    return
                }
                guard let uid = user?.uid else { return }
                
                UserDefaults.standard.setValue(uid, forKey: "Actual")
                print("loginButton")
                self?.performSegue(withIdentifier: (self?.StoryID)!, sender: self)
            }
        }
    }
    
    func authLogin() {
        FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: {(user,error) in
            if error == nil {
                guard let uid = user?.uid else { return }
                UserDefaults.standard.setValue(uid, forKey: "Actual")
                print("authLogin")
                self.performSegue(withIdentifier: self.StoryID, sender: self)
            }else{
                self.showErrorAlert((error?.localizedDescription)!)
            }
        })
    }
    
    func authOfflineLogin() {
        let result = LoginDAO.findByUserName(self.emailField.text!)
        
        if result != nil && result!.password == self.passwordField.text!.md5() {
            guard let uid = result?.id else { return }
            UserDefaults.standard.setValue(uid, forKey: "Actual")
            print("authOffileLogin")
            self.performSegue(withIdentifier: StoryID, sender: self)
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
