//
//  APIManager.swift
//  kkeulmit
//
//  Created by 장상경 on 4/9/25.
//

import Foundation
import Alamofire
import GoogleGenerativeAI

protocol APIManagable: AnyObject {
    func weatherFetch() async throws -> WeatherModel
    func geminiFetch() async throws -> String?
    func decodeWeather(from jsonString: String) -> WeatherResponse?
}

final class APIManager: APIManagable {
    
    func geminiFetch() async throws -> String? {
        guard let apiKey = Bundle.main.infoDictionary?["GeminiKey"] as? String else {
            throw NSError(domain: "GeminiKeyError", code: 0, userInfo: [NSLocalizedDescriptionKey: "GeminiKey가 없습니다."])
        }
        
        let model = GenerativeModel(name: "gemini-2.0-flash", apiKey: apiKey)
        
        do {
            let data = try await weatherFetch()
            
            debugPrint("✅ Gemini 호출을 시작합니다")
            
            let weathers = data.asText()
            let prompt = """
                \(weathers)
                
                위의 날씨 데이터를 분석해서 Swift에서 decoding 가능한 JSON 형태로 요약해줘.
                
                다음과 같은 JSON 형식을 지켜줘. 다른 텍스트는 포함하지 마.
                
                만약 비나 눈이 예상된다면 recommendation에 옷차림 추천과 함께 우산을 챙기는 걸 추천한다는 문구도 추가해.
                
                weather는 평균을 계산해서 코드를 반환하되, 01~04, 09~13, 50 범위 내에서 d 혹은 n을 추가해서 입력해.
                
                JSON 데이터는 단 하나만 반환하도록 해.
                
                {                  
                  "todayMinTemp": Double, // 오늘의 최저 기온
                  "todayMaxTemp": Double, // 오늘의 최고 기온
                  "todayTemp": Double, // 오늘의 평균 기온
                  "yesterdayTemp": Double, // 내일의 평균 기온
                  "weather": String, // 날씨 코드(예시: 01d)
                  "todayRecommendation": String, // 오늘 날씨를 분석해서 추천 옷차림을 서술어 형식으로 공손하고 구체적으로, 최대 공백 포함 50글자 이내로(ex: 날씨가 좋으니 긴팔 옷을 추천해요)
                  "yesterdayRecommendation": String, // 내일 날씨를 분석해서 추천 옷차림을 서술어 형식으로 공손하고 구체적으로, 최대 공백 포함 50글자 이내로(ex: 날씨가 좋으니 긴팔 옷을 추천해요)
                  "color": {
                    "red": CGFloat,
                    "green": CGFloat,
                    "blue": CGFloat,
                    "alpha": CGFloat
                  } // UIColor에 넣을 수 있는 값으로 추천하는 컬러
                }
                """
            
            let response = try await model.generateContent(prompt)
            
            if let text = response.text {
                debugPrint(text)
                return text
            } else {
                return nil
            }
            
        } catch {
            debugPrint("🚨 Gemini 호출 실패", error.localizedDescription)
            return nil
        }
    }
    
    func weatherFetch() async throws -> WeatherModel {
        guard let apiKey = Bundle.main.infoDictionary?["APIKey"] as? String else {
            throw NSError(domain: "APIKeyError", code: 0, userInfo: [NSLocalizedDescriptionKey: "APIKey가 없습니다."])
        }
        
        var lat: Double = UserDefaults.standard.double(forKey: "lat")
        var lon: Double = UserDefaults.standard.double(forKey: "lon")
        
        let url = "https://api.openweathermap.org/data/2.5/forecast"
        let parameters: Parameters = [
            "lat": "\(lat)",               // 위도 (서울 기준)
            "lon": "\(lon)",             // 경도 (서울 기준)
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
    
    func decodeWeather(from jsonString: String) -> WeatherResponse? {
        let response = cleanJSON(from: jsonString)
        
        guard let data = response.data(using: .utf8) else {
            print("❌ JSON 문자열을 Data로 변환 실패")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(WeatherResponse.self, from: data)
            return result
        } catch {
            print("❌ 디코딩 실패:", error)
            return nil
        }
    }
    
    private func cleanJSON(from rawResponse: String) -> String {
        return rawResponse
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
