//
//  MilkInfoTableViewCell.swift
//  GreenTech
//
//  Created by HyagoHirai on 17/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit

class MilkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cbtLabel: UILabel!
    @IBOutlet weak var ccsLabel: UILabel!
    @IBOutlet weak var crLabel: UILabel!
    @IBOutlet weak var esdLabel: UILabel!
    @IBOutlet weak var empresaLabel: UILabel!
    @IBOutlet weak var lactLabel: UILabel!
    @IBOutlet weak var protLabel: UILabel!
    @IBOutlet weak var quantidadeLabel: UILabel!
    @IBOutlet weak var stLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell(milkInfo: MilkInfo) {
        cbtLabel.text = milkInfo.cbt
        ccsLabel.text = milkInfo.ccs
        crLabel.text = milkInfo.cr
        esdLabel.text = milkInfo.esd
        empresaLabel.text = milkInfo.empresa
        lactLabel.text = milkInfo.lact
        protLabel.text = milkInfo.prot
        quantidadeLabel.text = milkInfo.quantidade
        stLabel.text = milkInfo.st
    }
    
    
}
