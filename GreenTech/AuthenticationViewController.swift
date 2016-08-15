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
import LocalAuthentication

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = FIRAuth.auth()?.currentUser {
            self.logoutButton.alpha = 1.0
            self.usernameLabel.text = user.email
        }else{
            self.logoutButton.alpha = 0.0
            self.usernameLabel.text = ""
        }
        
        if !isConnectedToNetwork() {
            authenticationUser()
        }
    }

    func loadNames() {
        var loginCD = [LoginCD]()
        loginCD = LoginDAO.returnAll()! as [LoginCD]
        
        for m in loginCD {
            print("email = " + m.userName + "senha = " + m.password)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    @IBAction func createAccountAction(sender: AnyObject) {
        if self.emailField.text == "" || self.passwordField.text == "" {
            let alertController = UIAlertController(title: "Ooops!", message: "Please enter an email and password.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.presentViewController(alertController,animated: true, completion: nil)
        }else{
            FIRAuth.auth()?.createUserWithEmail(self.emailField.text!, password: self.passwordField.text!, completion: { (user,error) in
                
                if error == nil {
                    LoginServices.createDataCD(self.emailField.text!, password: self.passwordField.text!.md5())
                    
                    self.logoutButton.alpha = 1.0
                    self.usernameLabel.text = user?.email
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    
                }else{
                    let alertController = UIAlertController(title: "Ooops!", message: error?.localizedDescription , preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController,animated: true, completion: nil)
                }
            })
        }
    }
    
    
    @IBAction func loginAction(sender: AnyObject) {
        if isConnectedToNetwork() == true {
            if self.emailField.text == "" || self.passwordField.text == "" {
                let alertController = UIAlertController(title: "Ooops!", message: "Please enter an email and password.", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController,animated: true, completion: nil)
            }else{
                FIRAuth.auth()?.signInWithEmail(self.emailField.text!, password: self.passwordField.text!, completion: {(user,error) in
                    if error == nil {
                        self.logoutButton.alpha = 1.0
                        self.usernameLabel.text = user?.email
                        self.emailField.text = ""
                        self.passwordField.text = ""
                    }else{
                        let alertController = UIAlertController(title: "Ooops!", message: error?.localizedDescription , preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.presentViewController(alertController,animated: true, completion: nil)
                    }
                })
            }
        }else{
            let result = LoginDAO.findByUserName(self.emailField.text!)
            
            if result != nil && result!.password == self.passwordField.text!.md5() {
                self.logoutButton.alpha = 1.0
                self.usernameLabel.text = self.emailField.text!
                self.emailField.text = ""
                self.passwordField.text = ""
            }else{
                let alertController = UIAlertController(title: "Ooops!", message: "Incorrect email or password" , preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController,animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        self.usernameLabel.text = ""
        self.logoutButton.alpha = 0.0
        self.emailField.text = ""
        self.passwordField.text = ""
    }
    
    
    func authenticationUser() {
        let context = LAContext()
        var error: NSError?
        let reasonString = "Authentification is needed to access your app"
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (sucess, policyError) -> Void in
                
                if sucess {
                    self.logoutButton.alpha = 1.0
                    self.usernameLabel.text = "OLÁ"
                    self.emailField.text = ""
                    self.passwordField.text = ""
                }else{
                    switch policyError!.code{
                    case LAError.SystemCancel.rawValue:
                        print("Authentification was cancelled by the system.")
                    case LAError.UserCancel.rawValue:
                        print("Authentification was cancelled by the user.")
                    case LAError.UserFallback.rawValue:
                        print("User selected to enter password.")
                        NSOperationQueue.mainQueue().addOperationWithBlock( { () -> Void in
                            self.showPasswordAlert()
                        })
                    default:
                        print("Authention failed.")
                        NSOperationQueue.mainQueue().addOperationWithBlock( { () -> Void in
                            self.showPasswordAlert()
                        })
                    }
                }
            })
        }else{
            print(error?.localizedDescription)
            NSOperationQueue.mainQueue().addOperationWithBlock( { () -> Void in
                self.showPasswordAlert()
            })
        }
    }
    
    
    func showPasswordAlert() {
        let alertController = UIAlertController(title: "Touch ID Password", message: "Please enter your password", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            if let textField = alertController.textFields?.first as UITextField? {
                if textField.text == "veasoftware" {
                    self.logoutButton.alpha = 1.0
                    self.usernameLabel.text = "OLÁ"
                    self.emailField.text = ""
                    self.passwordField.text = ""
                }else{
                    self.showPasswordAlert()
                }
            }
        }
        
        alertController.addAction(defaultAction)
        
        alertController.addTextFieldWithConfigurationHandler { (UITextField) -> Void in
            UITextField.placeholder = "Password"
            UITextField.secureTextEntry = true
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}