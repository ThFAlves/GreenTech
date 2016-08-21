//
//  DataBaseViewController.swift
//  GreenTech
//
//  Created by HyagoHirai on 16/08/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DataBaseViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    var userName : String = ""
    
    
    let conditionRef = FIRDatabase.database().reference()
    let testeAlterar = FIRDatabase.database().referenceFromURL("https://green-tech-a72ed.firebaseio.com/leobmaffei/Fazendas/-KPTmWFusfM86QIpuuwK")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        conditionRef.observeEventType(.Value) { (snap: FIRDataSnapshot) in
            //self.conditionLabel.text = snap.value?.description
        }
    }
    

    @IBAction func button(sender: AnyObject) {
        data()
    }
    @IBAction func change(sender: AnyObject) {
        testeAlterar.child("producaoDiaria").setValue("300")
    }
    

    
    func data(){
        
        let nomeFazenda = ""
        let litrosXdia = ""
        
        let userColaborador = ""
        
        let user = emailTextField.text
        let nome = nameTextField.text

       
        
        conditionRef.child(user!)
        
        
        
        let info : [String : AnyObject] = ["nome" : nome!,
                                               "email" : user!]
        
        let colaboradores : [String : AnyObject] = ["email" : userColaborador]
        
        let fazendas : [String : AnyObject] = ["nomeDaFazenda" : nomeFazenda,
                                               "producao" : litrosXdia,
                                               "Colaboradores" : colaboradores]
        
        conditionRef.child(user!).child("userInfo").setValue(info)
        conditionRef.child(user!).child("Fazendas").childByAutoId().setValue(fazendas)
        
        
        
    }
}
