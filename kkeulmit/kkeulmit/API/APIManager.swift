//
//  APIManager.swift
//  kkeulmit
//
//  Created by 장상경 on 4/9/25.
//

import Foundation
import Alamofire

protocol APIManagable: AnyObject {
    func fetch() async throws -> WeatherModel
}

final class APIManager: APIManagable {
    
    func fetch() async throws -> WeatherModel {
        let url = "https://api.openweathermap.org/data/2.5/forecast"
        
        guard let apiKey = Bundle.main.infoDictionary?["APIKey"] as? String else {
            throw NSError(domain: "APIKeyError", code: 0, userInfo: [NSLocalizedDescriptionKey: "APIKey가 없습니다."])
        }
        
        let parameters: Parameters = [
            "lat": "37.566",               // 위도 (서울 기준)
            "lon": "126.9784",             // 경도 (서울 기준)
            "appid": apiKey,               // OpenWeather API 키
            "units": "metric",             // 섭씨(℃) 단위로 받기
            "lang": "kr"                   // 한국어 설명 받기 (선택)
        ]
        
        let request = AF.request(url, method: .get, parameters: parameters)
        let response = await request.serializingDecodable(WeatherModel.self).response
        
        switch response.result {
        case .success(let weather):
            debugPrint("✅ API 호출 성공")
            return weather
            
        case .failure(let error):
            debugPrint("🚨 API 호출 실패", error.localizedDescription)
            throw error
        }
    }
    
}
