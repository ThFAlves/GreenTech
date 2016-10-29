//
//  MilkInfoTableViewCell.swift
//  GreenTech
//
//  Created by HyagoHirai on 17/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit

class MilkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var cellIdentifier: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.borderWidth = 1
        backView.layer.borderColor = Color.blueClear.cgColor
    }
    
    func configureCell(_ identifierInfo: String, valueInfo: Double, unitInfo: String) {
    
        cellIdentifier.text = identifierInfo
        value.text = String(valueInfo)
        unit.text = unitInfo
    }
    
}
