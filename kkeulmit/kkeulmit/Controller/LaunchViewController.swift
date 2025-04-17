//
//  LaunchViewController.swift
//  kkeulmit
//
//  Created by 장상경 on 4/9/25.
//

import UIKit
import SnapKit

final class LaunchViewController: UIViewController {
    
    private let launchView = LaunchView()
    
    private let locationManager = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = launchView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        launchView.playLottie { [weak self] in
            UIView.animate(withDuration: 0.3, animations: {
                self?.launchView.alpha = 0
            }, completion: { _ in
                self?.launchView.snp.removeConstraints()
                self?.launchView.removeFromSuperview()
                self?.view.removeFromSuperview()
                self?.removeFromParent()
            })
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ 알림 권한 허용됨")
                UserDefaults.standard.set(true, forKey: "alarm")
            } else {
                print("❌ 알림 권한 거부됨: \(error?.localizedDescription ?? "")")
                UserDefaults.standard.set(false, forKey: "alarm")
            }
        }
        
        locationManager.onLocationUpdate = { location in
            if let location {
                UserDefaults.standard.set(location.latitude, forKey: "lat")
                UserDefaults.standard.set(location.longitude, forKey: "lon")
            } else {
                UserDefaults.standard.set(37.566, forKey: "lat")
                UserDefaults.standard.set(126.9784, forKey: "lon")
            }
        }
        
        locationManager.requestLocation()

    }

    deinit {
        debugPrint(Self.self, "deinit")
    }
}
