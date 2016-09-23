//
//  ViewBorderExtencion.swift
//  GreenTech
//
//  Created by Leonardo Maffei on 22/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
}
