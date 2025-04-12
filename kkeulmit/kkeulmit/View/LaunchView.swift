//
//  LaunchView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/9/25.
//

import UIKit
import SnapKit
import Lottie

final class LaunchView: UIView {
    
    private lazy var lottieAnimationView = LottieAnimationView(name: LottieModels.launch.lottieString)
    private let titleView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playLottie(_ completion: @escaping () -> Void) {
        lottieAnimationView.play { _ in
            completion()
        }
    }
    
}

// MARK: - UI Setting Method

private extension LaunchView {
    
    func setupUI() {
        setupTitle()
        setupLottieView()
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        backgroundColor = .white
        addSubviews(lottieAnimationView, titleView)
    }
    
    func setupLayout() {
        lottieAnimationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(lottieAnimationView).offset(-200)
            $0.width.equalTo(200)
            $0.height.equalTo(100)
        }
    }
    
    func setupTitle() {
        titleView.text = "끌밋"
        titleView.font = .SCDream(size: 80, weight: .bold)
        titleView.textColor = .PersonalBlue.dark
        titleView.numberOfLines = 1
        titleView.textAlignment = .center
        titleView.backgroundColor = .clear
    }
    
    func setupLottieView() {
        lottieAnimationView.alpha = 1
        lottieAnimationView.loopMode = .repeat(1)
    }
    
}
