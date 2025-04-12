//
//  TempView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/11/25.
//

import UIKit
import SnapKit

final class TempView: UIView {
    
    private let temp = UILabel()
    private let info = UILabel()
    
    private let state: TempViewState
    
    init(_ state: TempViewState) {
        self.state = state
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Setting Method

private extension TempView {
    
    func setupUI() {
        setupInfo()
        setupTemp()
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        backgroundColor = state.bgColor
        layer.cornerRadius = 16
        addSubviews(info, temp)
    }
    
    func setupLayout() {
        info.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        temp.snp.makeConstraints {
            $0.top.equalTo(info.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupTemp() {
        temp.text = "0°C" // 기본값
        temp.textColor = state.tempColor
        temp.font = .SCDream(size: 24, weight: .bold)
        temp.numberOfLines = 1
        temp.textAlignment = .center
        temp.backgroundColor = .clear
    }
    
    func setupInfo() {
        info.text = state.title
        info.textColor = .black
        info.font = .SCDream(size: 16, weight: .regular)
        info.numberOfLines = 1
        info.textAlignment = .center
        info.backgroundColor = .clear
    }
}
