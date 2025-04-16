//
//  String+Extension.swift
//  kkeulmit
//
//  Created by 장상경 on 4/16/25.
//

import UIKit

extension String {
    
    func formattedDate() -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        formatter.dateFormat = "a hh시 mm분"
        
        return formatter.date(from: self) ?? Date()
    }
    
}
