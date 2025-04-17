//
//  ClothesCell.swift
//  kkeulmit
//
//  Created by 장상경 on 4/15/25.
//

import UIKit
import SnapKit

final class ClothesCell: UITableViewCell {
    
    private let contents = UILabel()
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
        
        contents.text = ""
    }
    
    func configCell(_ title: String) {
        contents.text = title
    }
    
}

// MARK: - UI Setting Method

private extension ClothesCell {
    
    func setupUI() {
        setupContainerView()
        setupContents()
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
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(41)
        }
        
        contents.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
    
    func setupContents() {
        contents.text = ""
        contents.textColor = .black
        contents.font = .SCDream(size: 12, weight: .regular)
        contents.numberOfLines = 1
        contents.textAlignment = .left
        contents.backgroundColor = .clear
    }
    
    func setupContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        containerView.clipsToBounds = true
        containerView.addSubview(contents)
    }
}
