//
//  ActiveButton.swift
//  kkeulmit
//
//  Created by 장상경 on 4/12/25.
//

import UIKit

final class ActiveButton: UIButton {
    
    init(_ title: String, _ titleColor: UIColor, _ titleSize: CGFloat, _ titleWeight: UIFont.Weight, bgColor: UIColor, corner: CGFloat = 0, setBorder: Bool = false) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        titleLabel?.font = .SCDream(size: titleSize, weight: titleWeight)
        backgroundColor = bgColor
        layer.cornerRadius = corner
        
        if setBorder {
            layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
            layer.borderWidth = 1
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
