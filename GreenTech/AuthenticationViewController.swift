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
        
        if isConnectedToNetwork() {
            print("connected")
        }else{
            print("not connected")
        }
        
        loadNames()
    
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
}