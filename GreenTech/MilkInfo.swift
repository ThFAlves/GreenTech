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
    let cbt: Float?
    let ccs: Float?
    let cr: Float?
    let internConsume: Float?
    let date: String?
    let esd: Float?
    let empresa: String?
    let hour: String?
    let gor: Float?
    let lact: Float?
    let prot: Float?
    let lost: Float?
    let produced: Float?
    let st: Float?
    let sold: Float?
    
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        cbt = snapshotValue["CBT"] as? Float
        ccs = snapshotValue["CCS"] as? Float
        cr = snapshotValue["CR"] as? Float
        internConsume = snapshotValue["ConsumoInterno"] as? Float
        date = snapshotValue["Data"] as? String
        esd = snapshotValue["ESD"] as? Float
        empresa = snapshotValue["Empresa"] as? String
        gor = snapshotValue["GOR"] as? Float
        hour = snapshotValue["Hora"] as? String
        lact = snapshotValue["LACT"] as? Float
        prot = snapshotValue["PROT"] as? Float
        lost = snapshotValue["Perdido"] as? Float
        produced = snapshotValue["Produzido"] as? Float
        st = snapshotValue["ST"] as? Float
        sold = snapshotValue["Vendido"] as? Float
    }
}
