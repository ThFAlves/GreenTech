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

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (FIRAuth.auth()?.currentUser != nil) {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("cowsName")
            self.showViewController(controller!, sender:  nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        if isConnectedToNetwork() == true {
            if self.emailField.text == "" || self.passwordField.text == "" {
                self.showErrorAlert("Please enter an email and password.")
            }else{
                FIRAuth.auth()?.signInWithEmail(self.emailField.text!, password: self.passwordField.text!, completion: {(user,error) in
                    if error == nil {
                        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("cowsName")
                        self.showViewController(controller!, sender:  nil)
                        
                    }else{
                        self.showErrorAlert((error?.localizedDescription)!)
                    }
                })
            }
        }else{
            let result = LoginDAO.findByUserName(self.emailField.text!)
            
            if result != nil && result!.password == self.passwordField.text!.md5() {
                let controller = self.storyboard?.instantiateViewControllerWithIdentifier("cowsName")
                self.showViewController(controller!, sender:  nil)
            }else{
                self.showErrorAlert("Incorrect email or password")
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Ooops!", message: message , preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController,animated: true, completion: nil)
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
    
}