//
//  ButtonStackView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/12/25.
//

import UIKit
import SnapKit

final class ButtonStackView: UIStackView {
    
    private let cancelButton = ActiveButton("취소", .black, 16, .medium, bgColor: .white, corner: 8, setBorder: true)
    private let activeButton = ActiveButton("확인", .white, 16, .bold, bgColor: .PersonalBlue.dark, corner: 8, setBorder: false)
    
    weak var buttonDelegate: ButtonsDelegate?
    
    init() {
        super.init(frame: .zero)
        
        axis = .horizontal
        spacing = 8
        alignment = .fill
        distribution = .fillEqually
        backgroundColor = .clear
        [cancelButton, activeButton].forEach {
            addArrangedSubview($0)
        }
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        activeButton.addTarget(self, action: #selector(activeButtonTapped), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

@objc private extension ButtonStackView {
    
    func cancelButtonTapped() {
        buttonDelegate?.cancelButtonTapped()
    }
    
    func activeButtonTapped() {
        buttonDelegate?.activeButtonTapped()
    }
    
}
