//
//  WeatherResponse.swift
//  kkeulmit
//
//  Created by 장상경 on 4/16/25.
//

import UIKit

struct WeatherResponse: Decodable {
    let minTemp: Double
    let maxTemp: Double
    let temp: Double
    let weather: String
    let recommendation: String
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
