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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
