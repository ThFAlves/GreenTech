//
//  SpinnerViewController.swift
//  GreenTech
//
//  Created by Juliana Salgado on 13/10/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import Foundation
import UIKit
import CVCalendar

class SpinnerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CVDate(date: Date()).globalDescription
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK - Actions
    @IBAction func didFinishedEditing(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
