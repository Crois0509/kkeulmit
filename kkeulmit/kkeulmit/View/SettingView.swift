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
    
    private var settingModels: [SettingModel] {
        [
            (title: "오늘의 추천 컬러", view: ColorView()),
            (title: "알람 시간", view: SettingLabelView(.time)),
            (title: "반복 주기", view: SettingLabelView(.week)),
            (title: "기온에 따른 옷차림 정보", view: nil),
            (title: "문의하기", view: nil),
            (title: "앱 리뷰하기", view: nil)
        ]
    }
    
    weak var modalDelegate: ModalPresentDelegate?
    weak var detailDelegate: PushViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadTableView(_ indexPath: IndexPath?) {
        guard let indexPath else {
            tableView.reloadData()
            return
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
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
        
        if let view = settingModels[indexPath.row].view as? SettingLabelView {
            let type = view.sendCurrentType()
            modalDelegate?.showModal(type, indexPath)
            
        } else if let _ = settingModels[indexPath.row].view as? ColorView {
            let detailVC = DetailViewController(view: RecommendColorView())
            detailDelegate?.push(detailVC)
            
        } else if indexPath.row == 3 {
            let detailVC = DetailViewController(view: RecommendClothesView())
            detailDelegate?.push(detailVC)
        } else if indexPath.row == 4 {
            modalDelegate?.showMailViewController()
            
        } else if indexPath.row == 5 {
            let pageUrl = "appstorePageLink" // TODO: AppStore 출시 후 링크 수정
            if let url = URL(string: pageUrl), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                debugPrint(url, "이동")
                
            } else {
                debugPrint("페이지 이동 실패", "\(pageUrl)은 이동할 수 없는 URL 입니다.")
            }
            
        }
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
