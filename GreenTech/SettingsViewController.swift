//
//  SettingsViewController.swift
//  GreenTech
//
//  Created by HyagoHirai on 20/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(_ sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        let loginView : FBSDKLoginManager = FBSDKLoginManager()
        loginView.loginBehavior = FBSDKLoginBehavior.web
        
        let manager = FBSDKLoginManager()
        manager.logOut()
        
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        
        GIDSignIn.sharedInstance().signOut()
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }

}
