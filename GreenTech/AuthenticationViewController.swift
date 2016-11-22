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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFacebookButtons()
        
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
    
    func authLogin() {
        FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: {(user,error) in
            if error == nil {
                guard let uid = user?.uid else { return }
                UserDefaults.standard.setValue(uid, forKey: "Actual")
                self.performSegue(withIdentifier: self.StoryID, sender: uid)
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
            self.performSegue(withIdentifier: StoryID, sender: uid)
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

extension AuthenticationViewController: FBSDKLoginButtonDelegate {
    
    
    func setupFacebookButtons() {
        
        loginFacebookButton.isHidden = true
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                guard let uid = user?.uid else { return }
                UserDefaults.standard.setValue(uid, forKey: "Actual")
                self.performSegue(withIdentifier: self.StoryID, sender: uid)
            } else {
                // No user is signed in.
                self.loginFacebookButton.frame = CGRect(x: 40, y: self.view.frame.height/2 - 60, width: self.view.frame.width - 80, height: 50)
                self.loginFacebookButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginFacebookButton.delegate = self
                self.view.addSubview(self.loginFacebookButton)
                self.loginFacebookButton.isHidden = false
            }
        }

    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            showErrorAlert(error.localizedDescription)
            return
        }

        self.loginFacebookButton.isHidden = true
        if error != nil {
            self.loginFacebookButton.isHidden = false
        } else if result.isCancelled {
            self.loginFacebookButton.isHidden = false
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        } else {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if error != nil {
                    self.showErrorAlert((error?.localizedDescription)!)
                    return
                }
                guard let uid = user?.uid else { return }
                
                UserDefaults.standard.setValue(uid, forKey: "Actual")
                self.performSegue(withIdentifier: self.StoryID, sender: uid)
            }
        
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
}
