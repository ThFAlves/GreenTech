//
//  MilkViewController.swift
//  GreenTech
//
//  Created by Leonardo Maffei on 15/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MilkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var milksTableView: UITableView!
    let cellIdentifier = "CellIdentifier"
    var milksInfo = [MilkInfo]()
    let service  = FirebaseService()

    override func viewDidLoad() {
        super.viewDidLoad()
        takeValue("ID", month: "09-2016", day: "13")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return milksInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MilkTableViewCell
        cell.configureCell(milksInfo[indexPath.row])
        return cell
    }
    
    func takeValue(id: String, month: String, day: String) {
        service.takeValueFromDatabase(id, month: month, day: day) { (milk) in
            self.milksInfo.append(milk)
            self.milksTableView.reloadData()
        }
    }
}
