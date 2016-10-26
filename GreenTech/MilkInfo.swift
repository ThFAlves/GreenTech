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
    var cbt: Float?
    var ccs: Float?
    var cr: Float?
    var internConsume: Float?
    var date: String?
    var esd: Float?
    var empresa: String?
    var hour: String?
    var gor: Float?
    var lact: Float?
    var prot: Float?
    var lost: Float?
    var produced: Float?
    var st: Float?
    var sold: Float?
    
    
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
    
    init(newInterConsume: Float, newDate: String, newLost: Float,newProduced: Float, newSold: Float) {
        cbt = 0
        ccs = 0
        cr = 0
        internConsume = newInterConsume
        date = newDate
        esd = 0
        empresa = ""
        hour = ""
        gor = 0
        lact = 0
        prot = 0
        lost = newLost
        produced = newProduced
        st = 0
        sold = newSold

    }
}
