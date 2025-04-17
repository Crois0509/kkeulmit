//
//  LocationManager.swift
//  kkeulmit
//
//  Created by 장상경 on 4/17/25.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var onLocationUpdate: ((CLLocationCoordinate2D?) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            onLocationUpdate?(location.coordinate) // 위도, 경도 콜백 전달
            debugPrint("📍 위치 정보 가져오기 성공", location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onLocationUpdate?(nil)
        debugPrint("❌ 위치 정보 가져오기 실패: \(error.localizedDescription)")
    }
}
