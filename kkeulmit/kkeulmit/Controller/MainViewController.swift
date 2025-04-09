//
//  ViewController.swift
//  kkeulmit
//
//  Created by 장상경 on 4/9/25.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

}

// MARK: - UI Setting Method

private extension MainViewController {
    
    func setupUI() {
        setupLaunch()
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        view.backgroundColor = .cyan
    }
    
    func setupLayout() {

    }
    
    func setupLaunch() {
        let launchVC = LaunchViewController()
        addChild(launchVC)
        view.addSubview(launchVC.view)
        launchVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        launchVC.didMove(toParent: self)
    }
    
}
