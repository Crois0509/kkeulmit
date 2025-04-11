//
//  SettingView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/11/25.
//

import UIKit
import SnapKit

final class SettingView: UIView {
    typealias SettingModel = (title: String, view: UIView?)
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let settingModels: [SettingModel] = [
        (title: "오늘의 추천 컬러", view: ColorView()),
        (title: "알람 시간", view: SettingLabelView(.time)),
        (title: "반복 주기", view: SettingLabelView(.weak)),
        (title: "기온에 따른 옷차림 정보", view: nil),
        (title: "문의하기", view: nil),
        (title: "앱 리뷰하기", view: nil)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.reloadData()
    }
    
}

// MARK: - UI Setting Method

private extension SettingView {
    
    func setupUI() {
        setupTableView()
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        backgroundColor = .clear
        addSubview(tableView)
    }
    
    func setupLayout() {
        tableView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 72
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(SettingViewCell.self, forCellReuseIdentifier: "SettingViewCell")
    }
    
}

extension SettingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("\(indexPath.row) 선택")
    }
}

extension SettingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingViewCell", for: indexPath) as? SettingViewCell else { return UITableViewCell() }
        
        let item = settingModels[indexPath.row]
        cell.configCell(item.title)
        cell.configExtraView(item.view)
        cell.selectionStyle = .none
        
        return cell
    }
    
}
