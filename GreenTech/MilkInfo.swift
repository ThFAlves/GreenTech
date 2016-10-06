//
//  MilkInfo.swift
//  GreenTech
//
//  Created by HyagoHirai on 17/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct MilkInfo {
    
    /*
     cbt : contaminação do leite
     ccs : quantidade de celulas somáticas (mastite)
     cr, esd, st quantidade das proteinas no leite
     empresa: empresa que compra o leite
     gor: quantidade de gordura no leite
     lact: quantidade de lactose total
     prot: quantidade de proteinas
     quantidade: quantidade de litros produzida
     */
//    let ref: FIRDatabaseReference?
//    let key: String
    let cbt: Int?
    let ccs: Int?
    let cr: Int?
    let esd: String?
    let empresa: String?
    let gor: String?
    let lact: String?
    let prot: String?
    let quantidade: Int?
    let st: String?
    
    
    init(snapshot: FIRDataSnapshot) {
        //key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        cbt = snapshotValue["CBT"] as? Int
        ccs = snapshotValue["CCS"] as? Int
        cr = snapshotValue["CR"] as? Int
        esd = snapshotValue["ESD"] as? String
        empresa = snapshotValue["Empresa"] as? String
        gor = snapshotValue["GOR"] as? String
        lact = snapshotValue["LACT"] as? String
        prot = snapshotValue["PROT"] as? String
        quantidade = snapshotValue["Quantidade"] as? Int
        st = snapshotValue["ST"] as? String
        //ref = snapshot.ref
    }
    
}
