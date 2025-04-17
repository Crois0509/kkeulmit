//
//  AlarmManager.swift
//  kkeulmit
//
//  Created by 장상경 on 4/17/25.
//

import UIKit

final class AlarmManager {
    private let calendar = Calendar.current
    private let selectedDaysString = UserDefaults.standard.string(forKey: "week") ?? ""
    private let selectedTimeString = UserDefaults.standard.string(forKey: "time") ?? "오전 08:00"
    
    private let weekdayMap: [String: Int] = [
        "일": 1,
        "월": 2,
        "화": 3,
        "수": 4,
        "목": 5,
        "금": 6,
        "토": 7
    ]
    
    private lazy var selectedDays = selectedDaysString == "매일 반복" ? [1, 2, 3, 4, 5, 6, 7] : selectedDaysString.components(separatedBy: ", ").compactMap { weekdayMap[$0] }
    
    func scheduleAnAlarm() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // 기존 알람 전체 삭제
        debugPrint("🚨 기존 알람 전체 삭제...")
        
        let date = selectedTimeString.formattedDate()
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        for weekday in selectedDays {
            var dateComponents = DateComponents()
            dateComponents.weekday = weekday
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let recommend = UserDefaults.standard.string(forKey: "yesterdayRecommendation") ?? ""
            let temp = UserDefaults.standard.double(forKey: "yesterdayTemp").as1DecimalString
            
            let content = UNMutableNotificationContent()
            content.title = "오늘의 옷차림을 추천해 드릴게요!"
            content.body = "\(recommend)\n평균 기온: \(temp)°C"
            content.sound = .default
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            debugPrint("✅ 새로운 알람 등록됨", request.identifier)
        }
    }
}
