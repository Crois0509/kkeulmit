//
//  TempViewState.swift
//  kkeulmit
//
//  Created by 장상경 on 4/11/25.
//

import UIKit

enum TempViewState {
    case min, max
    
    var bgColor: UIColor {
        switch self {
        case .min:
            return .PersonalBlue.light
        case .max:
            return .PersonalRed.background
        }
    }
    
    var tempColor: UIColor {
        switch self {
        case .min:
            return .PersonalBlue.dark
        case .max:
            return .PersonalRed.point
        }
    }
    
    var title: String {
        switch self {
        case .min:
            return "최저 온도"
        case .max:
            return "최고 온도"
        }
    }
}
