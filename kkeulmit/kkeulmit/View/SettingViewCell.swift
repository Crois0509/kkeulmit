//
//  SettingViewCell.swift
//  kkeulmit
//
//  Created by 장상경 on 4/11/25.
//

import UIKit
import SnapKit

final class SettingViewCell: UITableViewCell {
    
    private let titleView = UILabel()
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleView.text = ""
        if containerView.subviews.count > 1 {
            let view = containerView.subviews.last
            view?.snp.removeConstraints()
            view?.removeFromSuperview()
        }
    }
    
    func configCell(_ title: String) {
        titleView.text = title
    }
    
    func configExtraView(_ view: UIView?) {
        guard let view else { return }
        
        containerView.addSubview(view)
        
        view.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.lessThanOrEqualTo(titleView.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(25)
            $0.width.greaterThanOrEqualTo(25)
        }
    }
    
}

// MARK: - UI Setting Method

private extension SettingViewCell {
    
    func setupUI() {
        setupTitle()
        setupContainerView()
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        titleView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setupTitle() {
        titleView.font = .SCDream(size: 16, weight: .medium)
        titleView.textColor = .black
        titleView.numberOfLines = 1
        titleView.textAlignment = .left
        titleView.backgroundColor = .clear
    }
    
    func setupContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 32
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        containerView.layer.shadowOffset = .init(width: 0, height: 0)
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOpacity = 0.3
        
        containerView.addSubview(titleView)
    }
    
}
