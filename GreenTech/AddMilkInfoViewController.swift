//
//  AddMilkInfoViewController.swift
//  GreenTech
//
//  Created by Thiago Alves on 26/10/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import Eureka

class AddMilkInfoViewController: FormViewController {

    let service = FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadForm()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadForm(){
        
        form = Section("Data e Hora")
            <<< DateInlineRow(){
                $0.title = "Data"
                $0.tag = "Data"
                $0.value = NSDate(timeIntervalSinceNow: 0) as Date
            }
            <<< TimeInlineRow(){
                $0.title = "Hora"
                $0.tag = "Hora"
                $0.value = NSDate(timeIntervalSinceNow: 0) as Date
            }
            +++ Section("Leite")
            <<< IntRow(){ row in
                row.title = "Produzido"
                row.placeholder = "0 Lts"
                row.tag = "Produzido"
                row.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< IntRow(){ row in
                row.title = "Consumo Interno"
                row.placeholder = "0 Lts"
                row.tag = "ConsumoInterno"
                row.add(rule: RuleRequired())
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }

            <<< IntRow(){ row in
                row.title = "Descarte"
                row.placeholder = "0 Lts"
                row.tag = "Descarte"
                row.add(rule: RuleRequired())
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
    }
    
    @IBAction func saveData(_ sender: AnyObject) {
        
        var dictionary = [String: String]()
        
        dictionary["CBT"] = "0"
        dictionary["CCS"] = "0"
        dictionary["CR"] = "0"
        dictionary["ESD"] = "0"
        dictionary["Empresa"] = ""
        dictionary["GOR"] = "0"
        dictionary["LACT"] = "0"
        dictionary["PROT"] = "0"
        dictionary["ST"] = "0"
        dictionary["Vendido"] = "0"
        
        if let date = form.rowBy(tag: "Data")?.baseValue {
            dictionary["Data"] = String(describing: date)
        }
        
        if let hour = form.rowBy(tag: "Hora")?.baseValue {
            dictionary["Hora"] = String(describing: hour)
        }
        
        if let produced = form.rowBy(tag: "Produzido")?.baseValue {
            dictionary["Produzido"] = String(describing: produced)
        }
        
        if let internConsume = form.rowBy(tag: "ConsumoInterno")?.baseValue {
            dictionary["ConsumoInterno"] = String(describing: internConsume)
        }
        
        if let lost = form.rowBy(tag: "Descarte")?.baseValue {
            dictionary["Perdido"] = String(describing: lost)
        }

        print(dictionary)
        
        var theData: Date
        
        if let dateForFirebase = form.rowBy(tag: "Data")?.baseValue {
            theData = dateForFirebase as! Date
            service.saveMilkInfoDatabase(dictionary: dictionary, data: theData)
        }
    }

}
