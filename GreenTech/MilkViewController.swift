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
    let unitVector: [String] = ["Lts", "UFC/mL", "mil/mL", "oH", ""]
    var milksInfo = [MilkInfo]()
    var chartToDetailSelection = ""
    var segmentedSelection = ""
    weak var chartsViewController: ChartsViewController?

    
    let dateStringFunctions = DateString()

    
    
    
    // MARK: - database Declaration
    
    let service  = FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         // takeValue(path: "Fazendas/ID/Coleta/2016/10/07", queryType: .Week)
        getWeekValues(day: "07/10/2016")
        print(chartToDetailSelection)
        print(segmentedSelection)
        segmentedViewOutlet.selectedSegmentIndex = Int(segmentedSelection)!
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let returnSegmentedPosition = segue.destination as? ChartsViewController {
            segmentedViewOutlet.selectedSegmentIndex = returnSegmentedPosition.segmentedViewOutlet.selectedSegmentIndex
        }
    }
    
    

}


// MARK: - TableView

extension MilkViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Produção"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: milkTableView.bounds.size.width , height: 10))
            headerView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 0, y: 38, width: milkTableView.bounds.size.width/2, height: 10))
        label.text = "Produção"
        
        headerView.addSubview(label)

        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return milksInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MilkTableViewCell
        cell.configureCell(milksInfo[indexPath.row].date!, valueInfo: Double(milksInfo[indexPath.row].produced!), unitInfo: unitVector[0])
        
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
            let dateString = dateStringFunctions.dateToString(calendar: calendar, date: date)
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


