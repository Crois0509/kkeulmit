//
//  TempsView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/11/25.
//

import UIKit
import SnapKit

final class TempsStackView: UIStackView {
    
    private let minTempView = TempView(.min)
    private let maxTempView = TempView(.max)
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        spacing = 16
        clipsToBounds = true
        addArrangedSubview(minTempView)
        addArrangedSubview(maxTempView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configTempView(_ min: Double, _ max: Double) {
        minTempView.configTemp(min)
        maxTempView.configTemp(max)
    }
    
}
