//
//  MilkViewController.swift
//  GreenTech
//
//  Created by Leonardo Maffei on 29/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class MilkViewController: UIViewController {

    // MARK: - TableView Declaration
    
    @IBOutlet weak var milkTableView: UITableView!
    let cellIdentifier = "milkCellIdentifier"
    let descriptionVector: [String] = ["Quantidade", "CBT", "CCS", "CR", "Empresa"]
    let unitVector: [String] = ["Lts", "UFC/mL", "mil/mL", "oH", ""]
    var milksInfo = [String]()
    
    // MARK: - tableview cell itens Declaration
    
    
    
    // MARK: - database Declaration
    
    let service  = FirebaseService()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        takeValue("ID", year: "2016", month: "10", day: "01")
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}


// MARK: - TableView

extension MilkViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return milksInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MilkTableViewCell
        cell.configureCell(descriptionVector[indexPath.row], valueInfo: milksInfo[indexPath.row], unitInfo: unitVector[indexPath.row])
        
        return cell
    }
}

// MARK: - Database functions

extension MilkViewController {
    
    func takeValue(_ id: String,year: String , month: String, day: String) {
        service.takeValueFromDatabase(id, year: year , month: month, day: day) { [weak self] milk in
            self?.milksInfo.append(milk.quantidade)
            self?.milksInfo.append(milk.cbt)
            self?.milksInfo.append(milk.ccs)
            self?.milksInfo.append(milk.cr)
            self?.milksInfo.append(milk.empresa)
            self?.milkTableView.reloadData()
        }
    }

}
