//
//  WeatherResponse.swift
//  kkeulmit
//
//  Created by 장상경 on 4/16/25.
//

import UIKit

struct WeatherResponse: Decodable {
    let todayMinTemp: Double
    let todayMaxTemp: Double
    let todayTemp: Double
    let yesterdayTemp: Double
    let weather: String
    let todayRecommendation: String
    let yesterdayRecommendation: String
    let color: ColorComponents

    struct ColorComponents: Decodable {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        let alpha: CGFloat

        var uiColor: UIColor {
            UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}
