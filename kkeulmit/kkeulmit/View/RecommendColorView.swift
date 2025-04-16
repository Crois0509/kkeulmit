//
//  RecommendColorView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/15/25.
//

import UIKit
import SnapKit

final class RecommendColorView: UIView, DetailViewModel {
    
    private let text = UILabel()
    private let color = UIView()
    
    var navigationTitle = "오늘의 추천 컬러"
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Setting Method

private extension RecommendColorView {
    
    func setupUI() {
        setupColorView()
        setupText()
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        backgroundColor = .white
        addSubviews(text, color)
    }
    
    func setupLayout() {
        text.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        color.snp.makeConstraints {
            $0.top.equalTo(text.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
    func setupText() {
        text.text = "오늘의 추천 컬러는 AI가 날씨를 분석하여,\n날씨에 알맞는 색상을 추천해주는 서비스입니다."
        text.textColor = .black
        text.font = .SCDream(size: 14, weight: .regular)
        text.numberOfLines = 2
        text.textAlignment = .left
        text.backgroundColor = .clear
    }
    
    func setupColorView() {
        color.backgroundColor = .white
        color.layer.cornerRadius = 8
        color.layer.borderWidth = 1
        color.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        
        guard let data = UserDefaults.standard.data(forKey: "color") else { return }
        color.backgroundColor = UIColor.decode(data: data)
    }
    
}
