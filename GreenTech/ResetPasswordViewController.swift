//
//  ResetPasswordViewController.swift
//  GreenTech
//
//  Created by HyagoHirai on 12/08/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    let connection = VerifyConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func submitActio(_ sender: AnyObject) {
        if connection.isConnectedToNetwork() == true{
            if self.emailField.text == "" {
                self.showErrorAlert("Oops!", message: "Please enter an email.")
            } else {
                resetPassword()
            }
        }else{
            self.showErrorAlert("Error!", message: "There ins't internet connection")
        }
    }
    
    func resetPassword() {
        FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailField.text!, completion: { (error) in
            if error != nil {
                self.showErrorAlert("Oops!", message: (error?.localizedDescription)!)
            }else{
                self.showErrorAlert("Sucess!", message: "Password reset email sent.")
            }
        })
    }
    
    fileprivate func showErrorAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController,animated: true, completion: nil)
    }
}
