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
                $0.value = NSDate(timeIntervalSinceNow: 0) as Date
            }
            <<< TimeInlineRow(){
                $0.title = "Hora"
                $0.value = NSDate(timeIntervalSinceNow: 0) as Date
            }
            +++ Section("Leite")
            <<< IntRow(){ row in
                row.title = "Produzido"
                row.placeholder = "0 Lts"
                row.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< IntRow(){ row in
                row.title = "Consumo Interno"
                row.placeholder = "0 Lts"
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
                row.add(rule: RuleRequired())
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
