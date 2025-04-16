//
//  UIView+Extension.swift
//  kkeulmit
//
//  Created by 장상경 on 4/11/25.
//

import UIKit

extension UIView {
    func setGradientBackground(_ colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
