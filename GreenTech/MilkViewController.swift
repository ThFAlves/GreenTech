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
    let descriptionVector: [String] = ["Produzido", "CBT", "CCS", "CR", "Empresa"]
    let unitVector: [String] = ["Lts", "UFC/mL", "mil/mL", "oH", ""]
    var milksInfo = [MilkInfo]()
    
    // MARK: - tableview cell itens Declaration
    
    
    
    // MARK: - database Declaration
    
    let service  = FirebaseService()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      takeValue(path: "Fazendas/ID/Coleta/2016/10/07", queryType: .Day)
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}


// MARK: - TableView

extension MilkViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return milksInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MilkTableViewCell
        cell.configureCell(descriptionVector[0], valueInfo: Double(milksInfo[indexPath.row].produced!), unitInfo: unitVector[0])
        
        return cell
    }
}

// MARK: - Database functions

extension MilkViewController {
    
    func takeValue(path: String, queryType: QueryType) {
        service.takeValueFromDatabase(path: path, queryType: queryType) { [weak self] result in
            self?.milksInfo = result
            self?.milkTableView.reloadData()
        }
    }
}


