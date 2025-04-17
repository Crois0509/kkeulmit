//
//  ViewController.swift
//  kkeulmit
//
//  Created by 장상경 on 4/9/25.
//

import UIKit
import SnapKit
import MessageUI

final class MainViewController: UIViewController {
    
    private let logo = LogoView()
    private let topView = DetailView()
    private let tempsView = TempsStackView()
    private let bottomView = SettingView()
    private let refreshButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView()
    
    private let apiManager: APIManagable
    
    private var isFetched: Bool = false
    
    init(_ managable: APIManagable) {
        self.apiManager = managable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        Task {
             try await geminiFetch()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }

}

// MARK: - UI Setting Method

private extension MainViewController {
    
    func setupUI() {
        setupActivityView()
        setupRefreshButton()
        setupBottomView()
        configureSelf()
        setupLayout()
        setupLaunch()
    }
    
    func configureSelf() {
        navigationItem.title = ""
        view.backgroundColor = .white
        view.setGradientBackground([UIColor.PersonalBlue.light, .white], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 1))
        view.addSubviews(logo, topView, tempsView, bottomView, refreshButton, activityIndicator)
    }
    
    func setupLayout() {
        logo.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(40)
        }
        
        topView.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(72)
        }
        
        tempsView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(88)
        }
        
        bottomView.snp.makeConstraints {
            $0.top.equalTo(tempsView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        refreshButton.snp.makeConstraints {
            $0.centerY.equalTo(logo)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(30)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupBottomView() {
        bottomView.modalDelegate = self
        bottomView.detailDelegate = self
    }
    
    func setupRefreshButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "arrow.clockwise", withConfiguration: config)
        refreshButton.setImage(image, for: .normal)
        refreshButton.tintColor = .PersonalBlue.dark
        refreshButton.backgroundColor = .clear
        refreshButton.addTarget(self, action: #selector(refreshFetch), for: .touchUpInside)
    }
    
    @objc func refreshFetch() {
        isFetched = true
        showActivityIndicator()
        
        Task {
            try await geminiFetch()
            DispatchQueue.main.async {
                self.showActivityIndicator()
            }
        }
    }
    
    func setupLaunch() {
        let launchVC = LaunchViewController()
        addChild(launchVC)
        view.addSubview(launchVC.view)
        launchVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        view.bringSubviewToFront(launchVC.view)
        launchVC.didMove(toParent: self)
    }
    
    func setupActivityView() {
        activityIndicator.alpha = 0
        activityIndicator.color = .white
        activityIndicator.style = .large
        activityIndicator.backgroundColor = .black.withAlphaComponent(0.3)
        activityIndicator.isHidden = true
    }
    
    func showActivityIndicator() {
        UIView.animate(withDuration: 0.3) {
            if self.isFetched {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                self.activityIndicator.alpha = 1
                
            } else {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.alpha = 0
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    func geminiFetch() async throws {
        isFetched = true
        
        do {
            if let text = try await apiManager.geminiFetch(),
               let weather = apiManager.decodeWeather(from: text) {
                
                DispatchQueue.main.async {
                    self.topView.configDetailView(weather.todayTemp, weather.todayRecommendation, weather.weather)
                    self.tempsView.configTempView(weather.todayMinTemp, weather.todayMaxTemp)
                    self.bottomView.reloadTableView(nil)
                    
                    let bgColor = WeatherIconModel.customBgColor(weather.weather)
                    self.view.setGradientBackground([bgColor, .white], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 1))
                    
                    let color = weather.color.uiColor.encode()
                    UserDefaults.standard.set(weather.todayTemp, forKey: "temp")
                    UserDefaults.standard.set(weather.todayRecommendation, forKey: "recommendation")
                    UserDefaults.standard.set(color, forKey: "color")
                    UserDefaults.standard.set(weather.yesterdayTemp, forKey: "yesterdayTemp")
                    UserDefaults.standard.set(weather.yesterdayRecommendation, forKey: "yesterdayRecommendation")
                    
                    self.isFetched = false
                }
                
            } else {
                debugPrint("🚨 Gemini 호출 값이 비어있음")
                DispatchQueue.main.async {
                    self.isFetched = false
                    
                    let alert = UIAlertController(title: "알림", message: "현재 날씨 데이터를 받아올 수 없습니다.\n잠시 후 다시 시도해 주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                    
                    self.present(alert, animated: true)
                }
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            self.isFetched = false
        }
    }
    
}

extension MainViewController: ModalPresentDelegate {
    
    func showModal(_ type: LabelType, _ indexPath: IndexPath) {
        let modalVC = ModalViewController(type)
        
        modalVC.deinitClosure = { [weak self] in
            self?.bottomView.reloadTableView(indexPath)
        }
        
        self.present(modalVC, animated: true)
    }
    
    func showMailViewController() {
        guard MFMailComposeViewController.canSendMail() else {
            print("📭 이메일을 보낼 수 없습니다. 디바이스에 메일 계정이 설정되어 있지 않을 수 있어요.")
            return
        }

        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["crois0509@icloud.com"]) // 받는 사람
        mail.setSubject("끌밋 문의사항") // 제목
        mail.setMessageBody("요약:\n\n내용:", isHTML: false) // 본문

        present(mail, animated: true)
    }
    
}

extension MainViewController: PushViewControllerDelegate {
    func push(_ VC: UIViewController) {
        navigationController?.pushViewController(VC, animated: true)
    }
}

extension MainViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }
}
