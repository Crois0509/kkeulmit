//
//  UIColor+Extension.swift
//  kkeulmit
//
//  Created by 장상경 on 4/11/25.
//

import UIKit

extension UIColor {
    /// UIColor → Data
    func encode() -> Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
    }

    /// Data → UIColor
    static func decode(data: Data) -> UIColor? {
        try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
}

