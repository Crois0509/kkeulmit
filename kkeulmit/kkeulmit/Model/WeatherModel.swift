//
//  WeatherModel.swift
//  kkeulmit
//
//  Created by 장상경 on 4/9/25.
//

import Foundation

struct WeatherModel: Decodable {
    let list: [ForecastItem]
}

struct ForecastItem: Decodable {
    let dt: TimeInterval        // 예보 시간의 타임스탬프
    let main: ForecastMain      // 이 시간대의 기온 관련 정보
    let weather: [Weather]      // 날씨 상태 배열
    let wind: Wind              // 풍속 정보
}

struct ForecastMain: Decodable {
    let temp: Double            // 이 시간대의 현재 기온
    let temp_min: Double        // 이 시간대의 최저 기온
    let temp_max: Double        // 이 시간대의 최고 기온
}

struct Weather: Decodable {
    let main: String            // 날씨 상태 요약
    let description: String     // 상세 설명
    let icon: String            // 날씨 아이콘 코드
}

struct Wind: Decodable {
    let speed: Double           // 풍속(m/s)
}

extension WeatherModel {
    func asText() -> String {
        list.map { $0.asText() }.joined(separator: "\n\n")
    }
}

extension ForecastItem {
    func asText() -> String {
        let date = Date(timeIntervalSince1970: dt)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        let dateString = formatter.string(from: date)
        let weatherText = weather.first?.main ?? "Unknown"
        let weatherDesc = weather.first?.description ?? "N/A"
        let icon = weather.first?.icon ?? "?"

        return """
        📅 시간: \(dateString)
        🌡️ 현재 기온: \(main.temp)℃
        🔻 최저 기온: \(main.temp_min)℃
        🔺 최고 기온: \(main.temp_max)℃
        ☁️ 날씨: \(weatherText) (\(weatherDesc))
        💨 풍속: \(wind.speed)m/s
        🖼️ 아이콘 코드: \(icon)
        """
    }
}

