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
    let loginFacebookButton = FBSDKLoginButton()
    
    let connection = VerifyConnection()
    let StoryID = "signSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: StoryID, sender: self)
        }
        
        setupFacebookButtons()
        setupGoogleButtons()
        
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
                self.performSegue(withIdentifier: self.StoryID, sender: self)
            }else{
                self.showErrorAlert((error?.localizedDescription)!)
            }
        })
    }
    
    func authOfflineLogin() {
        let result = LoginDAO.findByUserName(self.emailField.text!)
        
        if result != nil && result!.password == self.passwordField.text!.md5() {
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

extension AuthenticationViewController: FBSDKLoginButtonDelegate {
    
    
    func setupFacebookButtons() {
        
        loginFacebookButton.isHidden = true
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "dontShowLogInView"), object: nil)
                self.performSegue(withIdentifier: self.StoryID, sender: self)
            } else {
                // No user is signed in.
                self.loginFacebookButton.center = self.view.center
                self.loginFacebookButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginFacebookButton.delegate = self
                
                self.view.addSubview(self.loginFacebookButton)
                self.loginFacebookButton.isHidden = false
            }
        }

    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
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
                    print("Something went wrong with our FB user: ", error ?? "")
                    return
                }
                print("user logged to firebase app")
                self.performSegue(withIdentifier: self.StoryID, sender: self)
            }
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
                if err != nil {
                    print("Failed to start graph request:", err ?? "")
                    return
                }
                print(result ?? "")
            }
        
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
}

extension AuthenticationViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func setupGoogleButtons() {
        //add google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }
            
            guard let uid = user?.uid else { return }
            print("Successfully logged into Firebase with Google", uid)
            self.performSegue(withIdentifier: self.StoryID, sender: self)
        })
        
    }
    
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Did log out of Google")
    }

}
