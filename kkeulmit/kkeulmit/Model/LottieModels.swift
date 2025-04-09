//
//  LottieModels.swift
//  kkeulmit
//
//  Created by 장상경 on 4/9/25.
//

import Foundation

enum LottieModels {
    case launch
    case clearDay
    case clearNight
    case extreme
    case extremeRain
    case overcast
    case overcastRain
    
    var lottieString: String {
        switch self {
        case .launch:
            return "kkeulmit"
        case .clearDay:
            return "clear-day"
        case .clearNight:
            return "clear-night"
        case .extreme:
            return "extreme"
        case .extremeRain:
            return "extreme-rain"
        case .overcast:
            return "overcast"
        case .overcastRain:
            return "overcast-rain"
        }
    }
}
