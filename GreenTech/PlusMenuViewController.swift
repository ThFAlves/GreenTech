//
//  PlusMenuViewController.swift
//  GreenTech
//
//  Created by Leonardo Maffei on 01/11/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit

class PlusMenuViewController: UIViewController {

    @IBOutlet weak var insertVendaOutlet: UIButton!
    @IBOutlet weak var insertColetaOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateButtons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        returnAnimateButtons()
    }
    
    func returnAnimateButtons(){
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 250 , 0)
        
        insertVendaOutlet.layer.transform = CATransform3DIdentity
        insertColetaOutlet.layer.transform = CATransform3DIdentity
        
        UIView.animate(withDuration: 0.3, animations: {
            self.insertVendaOutlet.layer.transform = transform
            self.insertColetaOutlet.layer.transform = transform
        })
        
        
    }
    
    func animateButtons(){
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 250 , 0)
        
        insertVendaOutlet.layer.transform = transform
        insertColetaOutlet.layer.transform = transform
        
        UIView.animate(withDuration: 0.3, animations: {
            self.insertVendaOutlet.layer.transform = CATransform3DIdentity
            self.insertColetaOutlet.layer.transform = CATransform3DIdentity
        })
        
        
    }


}
