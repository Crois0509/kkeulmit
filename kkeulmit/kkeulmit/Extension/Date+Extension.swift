//
//  Date+Extension.swift
//  kkeulmit
//
//  Created by 장상경 on 4/14/25.
//

import UIKit

extension Date {
    
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        formatter.dateFormat = "a hh시 mm분"
        return formatter.string(from: self)
    }
    
}
