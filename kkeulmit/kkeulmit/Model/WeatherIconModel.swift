//
//  WeatherIconModel.swift
//  kkeulmit
//
//  Created by 장상경 on 4/11/25.
//

import UIKit

enum WeatherIconModel {
    static func customWeatherIcons(_ iconString: String) -> String? {
        guard weatherIcons.keys.contains(iconString) else { return nil }
        
        return weatherIcons[iconString]
    }
    
    static func customBgColor(_ iconString: String) -> UIColor {
        let icon = customWeatherIcons(iconString) ?? ""
        
        if icon.contains("rain") || icon.contains("snow") || icon.contains("thunderstorms") {
            return UIColor.Sky.rainNight
        } else if icon.contains("extreme") || icon.contains("overcast") {
            return UIColor.Sky.sunnyNight
        } else {
            return UIColor.PersonalBlue.light
        }
    }
    
    private static var weatherIcons: [String: String] {
        return [
            "01d": "clear-day",
            "01n": "clear-night",
            "02d": "overcast-day",
            "02n": "extreme-night",
            "03d": "overcast",
            "03n": "extreme",
            "04d": "overcast",
            "04n": "extreme",
            "09d": "overcast-rain",
            "09n": "extreme-rain",
            "10d": "overcast-day-rain",
            "10n": "extreme-night-rain",
            "11d": "thunderstorms-overcast",
            "11n": "thunderstorms-extreme",
            "13d": "overcast-snow",
            "13n": "extreme-snow",
            "50d": "wind",
            "50n": "wind"
        ]
    }
}
