//
//  MilkViewController.swift
//  GreenTech
//
//  Created by Leonardo Maffei on 15/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import CVCalendar
import Firebase
import FirebaseDatabase

class MilkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var milksTableView: UITableView!
    let cellIdentifier = "CellIdentifier"
    var milksInfo = [MilkInfo]()
    let service  = FirebaseService()
    var dayCollection: Int = 0
    var monthCollection: Int = 0
    var yearCollection: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MILK ==================== \(dayCollection) \(monthCollection) \(yearCollection)")
        takeValue("ID", month: "09-2016", day: "13")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return milksInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MilkTableViewCell
        cell.configureCell(milksInfo[(indexPath as NSIndexPath).row])
        return cell
    }
    
    func takeValue(_ id: String, month: String, day: String) {
        service.takeValueFromDatabase(id, month: month, day: day) { (milk) in
            self.milksInfo.append(milk)
            self.milksTableView.reloadData()
        }
    }
}
