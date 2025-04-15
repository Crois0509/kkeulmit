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
    private lazy var weakView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    private let weaks: [String] = ["월", "화", "수", "목", "금", "토", "일"]
    
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
            
        case .weak:
            var select: [String] = []
            let items = weakView.numberOfItems(inSection: 0)
            
            for i in 0..<items {
                let indexPath = IndexPath(row: i, section: 0)
                
                guard let cell = weakView.cellForItem(at: indexPath) as? WeakCell,
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
        datePicker.overrideUserInterfaceStyle = .light
    }
    
    func setupWeakView() {
        guard modalType == .weak else { return }
        weakView.delegate = self
        weakView.dataSource = self
        weakView.isScrollEnabled = false
        weakView.showsVerticalScrollIndicator = false
        weakView.showsHorizontalScrollIndicator = false
        weakView.backgroundColor = .clear
        weakView.register(WeakCell.self, forCellWithReuseIdentifier: "WeakCell")
    }
    
}

extension ModalView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? WeakCell else { return }
        cell.toggleDidSelectedState()
    }
}

extension ModalView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weaks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeakCell", for: indexPath) as? WeakCell else { return UICollectionViewCell() }
        
        cell.configCell(weaks[indexPath.item])
        
        return cell
    }
    
}
