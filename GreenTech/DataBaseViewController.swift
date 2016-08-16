//
//  DataBaseViewController.swift
//  GreenTech
//
//  Created by HyagoHirai on 16/08/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DataBaseViewController: UIViewController {
    
    let conditionRef = FIRDatabase.database().reference().child("AnimalName")

    @IBOutlet weak var conditionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conditionRef.observeEventType(.Value) { (snap: FIRDataSnapshot) in
            //self.conditionLabel.text = snap.value?.description
        }
    }
    
    @IBAction func sunnyDidTouch(sender: AnyObject) {
        conditionRef.setValue("Mimosa")
    }
    
    @IBAction func foggyDidTouch(sender: AnyObject) {
        conditionRef.setValue("Thiaguinho")
    }
}
