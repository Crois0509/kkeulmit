//
//  TempProgressView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/15/25.
//

import UIKit
import SnapKit

final class TempProgressView: UIView {
    
    private lazy var maxTemp = createdLabel("35°C", color: .PersonalRed.point)
    private lazy var minTemp = createdLabel("-5°C", color: .PersonalBlue.dark)
    private lazy var temp = createdLabel("15°C", color: .black)
    private let progress = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupProgress()
    }
    
}

// MARK: - UI Setting Method

private extension TempProgressView {
    
    func setupUI() {
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        backgroundColor = .clear
        addSubviews(progress, maxTemp, temp, minTemp)
    }
    
    func setupLayout() {
        progress.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.equalTo(100)
            $0.bottom.equalToSuperview()
        }
        
        maxTemp.snp.makeConstraints {
            $0.top.equalTo(progress)
            $0.trailing.equalTo(progress.snp.leading).offset(-10)
            $0.leading.equalToSuperview()
            $0.width.equalTo(35)
        }
        
        temp.snp.makeConstraints {
            $0.centerY.equalTo(progress)
            $0.trailing.equalTo(progress.snp.leading).offset(-10)
            $0.leading.equalToSuperview()
            $0.width.equalTo(35)
        }
        
        minTemp.snp.makeConstraints {
            $0.bottom.equalTo(progress)
            $0.trailing.equalTo(progress.snp.leading).offset(-10)
            $0.leading.equalToSuperview()
            $0.width.equalTo(35)
        }
    }
    
    func createdLabel(_ title: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        label.numberOfLines = 1
        label.font = .SCDream(size: 14, weight: .bold)
        label.textAlignment = .right
        label.backgroundColor = .clear
        
        return label
    }
    
    func setupProgress() {
        progress.backgroundColor = .white
        progress.setGradientBackground([.PersonalRed.red, .white, .PersonalBlue.blue], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 1))
        progress.layer.cornerRadius = 16
        progress.layer.masksToBounds = true
    }
    
}
