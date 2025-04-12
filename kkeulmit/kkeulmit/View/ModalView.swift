//
//  ModalView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/12/25.
//

import UIKit
import SnapKit

final class ModalView: UIView {
    
    private let datePicker = UIDatePicker()
    private let weakView = UIStackView()
    
    private let modalType: LabelType
    
    init(_ type: LabelType) {
        self.modalType = type
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Setting Method

private extension ModalView {
    
    func setupUI() {
        setupDatePicker()
        setupWeakView()
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        backgroundColor = .clear
        if modalType == .time {
            addSubview(datePicker)
        } else {
            addSubview(weakView)
        }
    }
    
    func setupLayout() {
        if modalType == .time {
            datePicker.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
        } else {
            weakView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    func setupDatePicker() {
        guard modalType == .time else { return }
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.setDate(Date(), animated: true)
        datePicker.backgroundColor = .clear
    }
    
    func setupWeakView() {
        guard modalType == .weak else { return }
        weakView.axis = .horizontal
        weakView.spacing = 8
        weakView.alignment = .fill
        weakView.distribution = .fillEqually
        weakView.backgroundColor = .clear
        
        createSubViews().forEach {
            weakView.addArrangedSubview($0)
        }
    }
    
    func createSubViews() -> [UIButton] {
        let weaks = ["월", "화", "수", "목", "금", "토", "일"]
        var buttons = [UIButton]()
        
        weaks.forEach {
            let button = UIButton()
            button.setTitle($0, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .SCDream(size: 12, weight: .regular)
            button.backgroundColor = .white
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
            
            buttons.append(button)
        }
        
        return buttons
    }
    
}
