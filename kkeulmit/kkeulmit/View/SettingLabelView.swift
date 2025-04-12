//
//  TimeView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/11/25.
//

import UIKit

final class SettingLabelView: UILabel {
    
    private let type: LabelType
    
    init(_ type: LabelType) {
        self.type = type
        super.init(frame: .zero)
        
        if let label = UserDefaults.standard.string(forKey: type.rawValue) {
            text = label
        } else {
            text = ""
        }
        
        font = .SCDream(size: 14, weight: .regular)
        textColor = .PersonalBlue.base
        numberOfLines = 1
        textAlignment = .right
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendCurrentType() -> LabelType {
        return type
    }
    
}
