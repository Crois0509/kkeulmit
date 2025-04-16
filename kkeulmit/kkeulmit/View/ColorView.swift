//
//  ColorView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/11/25.
//

import UIKit

final class ColorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let color = UserDefaults.standard.data(forKey: "color") {
            backgroundColor = UIColor.decode(data: color)
        } else {
            backgroundColor = .white // 기본값
        }
        
        layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 12.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
