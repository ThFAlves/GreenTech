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
    
    let connection = VerifyConnection()
    let StoryID = "tabBar"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (FIRAuth.auth()?.currentUser != nil) {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: StoryID)
            self.show(controller!, sender:  nil)
        }
        
        setupFacebookButtons()
        setupGoogleButtons()
        
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

extension AuthenticationViewController: FBSDKLoginButtonDelegate {
    
    func setupFacebookButtons() {
        let loginFacebookButton = FBSDKLoginButton()
        view.addSubview(loginFacebookButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginFacebookButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginFacebookButton.delegate = self
        loginFacebookButton.readPermissions = ["email", "public_profile"]
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        showEmailAddress()
    }
    
    func showEmailAddress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with our FB user: ", error ?? "")
                return
            }
            
            print("Successfully logged in with our user: ", user ?? "")
            self.performSegue(withIdentifier: "signSegue", sender: self)
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err ?? "")
                return
            }
            print(result ?? "")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
}

extension AuthenticationViewController: GIDSignInUIDelegate {
    
    func setupGoogleButtons() {
        //add google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().delegate = self
    }
    

}
