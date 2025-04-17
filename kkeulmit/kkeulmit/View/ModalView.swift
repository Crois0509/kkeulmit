//
//  ModalView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/12/25.
//

import UIKit
import SnapKit

final class ModalView: UIView {
    
    private lazy var datePicker = UIDatePicker()
    private lazy var weekView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    private let weeks: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    
    private var layout: UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/7),
                                              heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       repeatingSubitem: item,
                                                       count: 7
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private let modalType: LabelType
    
    init(_ type: LabelType) {
        self.modalType = type
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendInputData() -> [String] {
        switch modalType {
        case .time:
            let date = datePicker.date.formattedString()
            return [date]
            
        case .week:
            var select: [String] = []
            let items = weekView.numberOfItems(inSection: 0)
            
            for i in 0..<items {
                let indexPath = IndexPath(row: i, section: 0)
                
                guard let cell = weekView.cellForItem(at: indexPath) as? WeekCell,
                      let time = cell.cellSelected()
                else { continue }
                
                select.append(time)
            }
            
            return select
        }
    }
    
}

// MARK: - UI Setting Method

private extension ModalView {
    
    func setupUI() {
        setupDatePicker()
        setupWeekView()
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        backgroundColor = .clear
        if modalType == .time {
            addSubview(datePicker)
        } else {
            addSubview(weekView)
        }
    }
    
    func setupLayout() {
        if modalType == .time {
            datePicker.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
        } else {
            weekView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    func setupDatePicker() {
        guard modalType == .time else { return }
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.backgroundColor = .clear
        datePicker.overrideUserInterfaceStyle = .light
        
        let date = UserDefaults.standard.string(forKey: "time")
        let time = date == nil ? Date() : date!.formattedDate()
        datePicker.setDate(time, animated: true)
    }
    
    func setupWeekView() {
        guard modalType == .week else { return }
        weekView.delegate = self
        weekView.dataSource = self
        weekView.isScrollEnabled = false
        weekView.showsVerticalScrollIndicator = false
        weekView.showsHorizontalScrollIndicator = false
        weekView.backgroundColor = .clear
        weekView.register(WeekCell.self, forCellWithReuseIdentifier: "WeekCell")
    }
    
}

extension ModalView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? WeekCell else { return }
        cell.toggleDidSelectedState()
    }
}

extension ModalView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath) as? WeekCell else { return UICollectionViewCell() }
        
        cell.configCell(weeks[indexPath.item])
        
        return cell
    }
    
}
