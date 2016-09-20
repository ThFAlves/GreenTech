//
//  SettingsViewController.swift
//  GreenTech
//
//  Created by HyagoHirai on 20/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import FirebaseAuth

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
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "loginScreen")
        self.show(controller!, sender:  nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
