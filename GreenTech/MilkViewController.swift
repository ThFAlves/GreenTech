//
//  MilkViewController.swift
//  GreenTech
//
//  Created by Leonardo Maffei on 15/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit

class MilkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "CellIdentifier"
    var dados: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        dados = ["115 litros","10% aumento","1% perca"]
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
        return dados.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let dado = dados[indexPath.row]
        
        cell.textLabel?.text = dado
        
        return cell
    }
    


}
