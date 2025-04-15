//
//  RecommendClothesView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/15/25.
//

import UIKit
import SnapKit

final class RecommendClothesView: UIView, DetailViewModel {
    
    private let titleView = UILabel()
    private let progress = TempProgressView()
    private let clothesView = UITableView(frame: .zero, style: .plain)
    private let indicator = UIView()
    
    private let clothes: [String] = [
        "민소매, 반바지, 얇은 린넨류",
        "반팔 티셔츠, 반바지, 얇은 셔츠",
        "반팔, 얇은 긴팔, 면바지",
        "긴팔 셔츠, 가디건, 얇은 니트",
        "맨투맨, 자켓, 얇은 바람막이",
        "트렌치코트, 가죽자켓, 니트+이너",
        "울 코트, 히트텍, 두꺼운 니트",
        "패딩, 두꺼운 코트, 머플러, 장갑",
        "두꺼운 패딩, 내복, 방한용품",
        "롱패딩, 방한부츠, 목도리",
    ]
    
    var navigationTitle = "기온에 따른 옷차림 정보"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        UIView.animate(withDuration: 0.3) {
            let defaultTemp: Double = 15
            let maxTemp: Double = 35.0
            let minTemp: Double = -5.0
            let totalRange = maxTemp - minTemp
            let progressHeihgt = self.progress.bounds.height
            let negativeRangeHeight = progressHeihgt * 0.125
            
            let temp = UserDefaults.standard.object(forKey: "temp") as? Double ?? defaultTemp
            var constraint: CGFloat = 0
            
            if temp >= 0 {
                // 0°C 이상인 경우, 상단으로 올라가도록 처리
                let ratio = temp >= maxTemp ? 0.865 : temp / totalRange
                constraint = -((progressHeihgt * ratio) + negativeRangeHeight)
                
            } else {
                // 0°C 미만인 경우, progress 하단 일부만 사용 (0도 ~ -5도 구간을 1/8 정도로 표현)
                let ratio = temp <= minTemp ? 0 : (temp - minTemp) / abs(minTemp) // temp가 -5이면 0, temp가 0이면 1
                constraint = -(negativeRangeHeight * ratio)
            }
            
            self.indicator.snp.updateConstraints {
                $0.bottom.equalTo(self.progress).offset(constraint)
            }
            
        }
    }
    
}

// MARK: - UI Setting Method

private extension RecommendClothesView {
    
    func setupUI() {
        setupTitle()
        setupIndicator()
        setupClothesView()
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        backgroundColor = .white
        addSubviews(titleView, progress, clothesView, indicator)
    }
    
    func setupLayout() {
        titleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(24)
        }
        
        progress.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(500)
        }
        
        clothesView.snp.makeConstraints {
            $0.top.equalTo(progress)
            $0.height.greaterThanOrEqualTo(progress)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalTo(progress.snp.trailing).offset(16)
        }
        
        indicator.snp.makeConstraints {
            $0.height.equalTo(5)
            $0.width.equalTo(110)
            $0.bottom.equalTo(progress)
            $0.centerX.equalTo(progress).offset(22.5)
        }
    }
    
    func setupTitle() {
        titleView.text = "오늘의 옷차림 추천"
        titleView.font = .SCDream(size: 20, weight: .bold)
        titleView.textColor = .PersonalBlue.base
        titleView.numberOfLines = 1
        titleView.textAlignment = .center
        titleView.backgroundColor = .clear
    }
    
    func setupIndicator() {
        indicator.backgroundColor = .PersonalBlue.dark
        indicator.layer.cornerRadius = 2.5
    }
    
    func setupClothesView() {
        clothesView.dataSource = self
        clothesView.rowHeight = 51
        clothesView.separatorStyle = .none
        clothesView.backgroundColor = .clear
        clothesView.showsVerticalScrollIndicator = false
        clothesView.showsHorizontalScrollIndicator = false
        clothesView.isScrollEnabled = false
        clothesView.register(ClothesCell.self, forCellReuseIdentifier: "clothesCell")
    }
    
}

extension RecommendClothesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "clothesCell", for: indexPath) as? ClothesCell else {
            return UITableViewCell()
        }
        
        cell.configCell(clothes[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}
