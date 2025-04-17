//
//  WeekCell.swift
//  kkeulmit
//
//  Created by 장상경 on 4/12/25.
//

import UIKit
import SnapKit

final class WeekCell: UICollectionViewCell {
    
    private let label = UILabel()
    
    private var didSelect: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(label)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(_ text: String) {
        label.text = text
        let week = UserDefaults.standard.string(forKey: "week")
        
        if week?.contains(text) == true || week == "매일 반복" {
            didSelect = true
            selectCell()
        }
    }
    
    func toggleDidSelectedState() {
        didSelect.toggle()
        
        if didSelect {
            selectCell()
        } else {
            deSelectCell()
        }
    }
    
    func cellSelected() -> String? {
        guard didSelect else { return nil }
        return label.text
    }
    
    private func selectCell() {
        label.font = .SCDream(size: 14, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .PersonalBlue.base
        label.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func deSelectCell() {
        label.font = .SCDream(size: 14, weight: .regular)
        label.textColor = .black
        label.backgroundColor = .white
        label.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
    }
    
    private func setupLabel() {
        label.font = .SCDream(size: 14, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .center
        label.backgroundColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        label.layer.borderWidth = 0.5
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
