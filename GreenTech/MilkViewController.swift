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

    @IBOutlet weak var segmentedViewOutlet: UISegmentedControl!
    @IBOutlet weak var milkTableView: UITableView!
    
    
    let cellIdentifier = "milkCellIdentifier"
    let descriptionVector: [String] = ["Produzido", "CBT", "CCS", "CR", "Empresa"]
    let unitVector: [String] = ["Litros", "UFC/mL", "mil/mL", "oH", ""]
    var milksInfo = [MilkInfo]()
    var chartToDetailSelection = ""
    var segmentedSelection = ""
    weak var chartsViewController: ChartsViewController?
    lazy var 

    
    let dateStringFunctions = DateString()

    
    
    
    // MARK: - database Declaration
    
    let service  = FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // takeValue(path: "Fazendas/ID/Coleta/2016/10/07", queryType: .Week)
        getWeekValues(day: "07/10/2016")
        segmentedViewOutlet.selectedSegmentIndex = Int(segmentedSelection)!
    }
    
    //when view will disappear send the data from segmented to chartsView controller
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        //push with segue
        self.performSegue(withIdentifier: "unwindMilkSegue", sender: self)
    }
    
    
    @IBAction func SelectRange(_ sender: AnyObject) {
        switch(segmentedViewOutlet.selectedSegmentIndex){
            
        case 0 :
            takeValue(path: "Fazendas/ID/Coleta/2016/10/07", queryType: .Day)
            break
        case 1:
            getWeekValues(day: "07/10/2016")
            break
        case 2:
            takeValue(path: "Fazendas/ID/Coleta/2016/10", queryType: .Month)
            break
        case 3:
            takeValue(path: "Fazendas/ID/Coleta/2016", queryType: .Year)
            break
        default:
            break
        }
        
    }

}


// MARK: - TableView

extension MilkViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if chartToDetailSelection == "productionDetail" {
            return "Produção"
        }
        if chartToDetailSelection == "generalDetail" {
            return "Comercializado"
        }
        return "Error"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 8, y: 0, width: milkTableView.bounds.size.width , height: 13))
            headerView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 8, y: 38, width: milkTableView.bounds.size.width/2, height: 13))
        //reload the header selected
        if chartToDetailSelection == "productionDetail" {
            label.text = "Produção"
        }
        if chartToDetailSelection == "generalDetail" {
            label.text = "Comercializado"
        }
        
        headerView.addSubview(label)

        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return milksInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MilkTableViewCell
        
        if chartToDetailSelection == "productionDetail" {
            cell.configureCell(milksInfo[indexPath.row].date!, valueInfo: Double(milksInfo[indexPath.row].produced!), unitInfo: unitVector[0])
        }
        
        if chartToDetailSelection == "generalDetail"{
            cell.configureCell(milksInfo[indexPath.row].date!, valueInfo: Double(milksInfo[indexPath.row].sold!), unitInfo: unitVector[0])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -5, 0, 0)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 0.5, animations: {
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
            })
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
    
    func getWeekValues(day: String) {
        milksInfo.removeAll()
        var date = dateStringFunctions.getFormattedDay(day: day)
        let calendar = Calendar.current
        
        let group = DispatchGroup()
        for _ in 0..<7 {
            let dateString = dateStringFunctions.dateToStringPath(date: date)
            let path = dateStringFunctions.getPathFromDate(dateString: dateString)
            
            group.enter()
            service.takeValueFromDatabase(path: path, queryType: .Week) { [weak self] result in
                self?.milksInfo += result
                group.leave()
            }
            
            date = dateStringFunctions.decreaseDate(calendar: calendar, date: date)
        }
        
        group.notify(qos: .background, flags: .assignCurrentContext, queue: .main) { [weak self] in
            self?.milksInfo = (self?.milksInfo.sorted { (self?.dateStringFunctions.getFormattedDay(day: $0.date!))!  < (self?.dateStringFunctions.getFormattedDay(day: $1
                .date!))!  })!
            //self?.loadAllCharts(queryType: .Week)
            self?.milkTableView.reloadData()
        }
    }
}


