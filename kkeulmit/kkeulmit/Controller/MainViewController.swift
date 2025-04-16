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
    
    private let apiManager: APIManagable
    
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
        setupBottomView()
        configureSelf()
        setupLayout()
        setupLaunch()
    }
    
    func configureSelf() {
        navigationItem.title = ""
        view.backgroundColor = .white
        view.setGradientBackground([UIColor.PersonalBlue.light, .white], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 1))
        view.addSubviews(logo, topView, tempsView, bottomView)
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
    }
    
    func setupBottomView() {
        bottomView.modalDelegate = self
        bottomView.detailDelegate = self
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
    
    func geminiFetch() async throws {
        do {
            if let text = try await apiManager.geminiFetch(),
               let weather = apiManager.decodeWeather(from: text) {
                
                DispatchQueue.main.async {
                    self.topView.configDetailView(weather.temp, weather.recommendation, weather.weather)
                    self.tempsView.configTempView(weather.minTemp, weather.maxTemp)
                    self.bottomView.reloadTableView(nil)
                    
                    let bgColor = WeatherIconModel.customBgColor(weather.weather)
                    self.view.setGradientBackground([bgColor, .white], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 1))
                    
                    let color = weather.color.uiColor.encode()
                    UserDefaults.standard.set(weather.temp, forKey: "temp")
                    UserDefaults.standard.set(weather.recommendation, forKey: "recommendation")
                    UserDefaults.standard.set(color, forKey: "color")
                }
                
            } else {
                debugPrint("🚨 Gemini 호출 값이 비어있음")
            }
            
        } catch {
            debugPrint(error.localizedDescription)
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
