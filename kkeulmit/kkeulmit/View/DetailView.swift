//
//  DetailView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/11/25.
//

import UIKit
import SnapKit
import Lottie

final class DetailView: UIView {
    
    private lazy var tempView = createdLabel("평균 기온: 0°C", 20, .bold)
    private lazy var detailView = createdLabel("오늘 날씨에 맞는 옷차림을 추천해 드릴게요", 14, .regular)
    private let lottieIcon = LottieAnimationView(name: LottieModels.clearDay.lottieString) // 기본값 = 맑음
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configDetailView(_ data: DetailModel) {
        lottieIcon.stop()
        tempView.text = "평균 기온: \(data.temp)°C"
        detailView.text = data.detail
        lottieIcon.animation = LottieAnimation.named(WeatherIconModel.customWeatherIcons(data.icon) ?? LottieModels.clearDay.lottieString)
        lottieIcon.play()
    }
    
}

// MARK: - UI Setting Method

private extension DetailView {
    
    func setupUI() {
        setupLottie()
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        backgroundColor = .clear
        clipsToBounds = true
        addSubviews([tempView, detailView, lottieIcon])
    }
    
    func setupLayout() {
        tempView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.height.equalTo(24)
            $0.trailing.lessThanOrEqualTo(lottieIcon.snp.leading)
        }
        
        detailView.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
            $0.trailing.equalTo(tempView)
            $0.height.equalTo(40)
        }
        
        lottieIcon.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.height.equalTo(72)
        }
    }
    
    func createdLabel(_ text: String, _ size: CGFloat, _ weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .SCDream(size: size, weight: weight)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .left
        label.backgroundColor = .clear
        
        return label
    }
    
    func setupLottie() {
        lottieIcon.loopMode = .loop
        lottieIcon.animationSpeed = 4.0
        lottieIcon.play()
    }
    
}
