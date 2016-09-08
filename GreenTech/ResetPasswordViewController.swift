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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func submitActio(sender: AnyObject) {
        if self.emailField.text == "" {
            self.showErrorAlert("Oops!", message: "Please enter an email.")
        } else {
            FIRAuth.auth()?.sendPasswordResetWithEmail(self.emailField.text!, completion: { (error) in
                if error != nil {
                    self.showErrorAlert("Oops!", message: (error?.localizedDescription)!)
                }else{
                    self.showErrorAlert("Sucess!", message: "Password reset email sent.")
                }
            })
        }
    }
    
    private func showErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController,animated: true, completion: nil)
    }
}
