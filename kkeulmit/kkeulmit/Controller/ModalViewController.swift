//
//  ModelViewController.swift
//  kkeulmit
//
//  Created by 장상경 on 4/12/25.
//

import UIKit
import SnapKit

final class ModalViewController: UIViewController {
    
    private let modalView: ModalView
    private let buttons = ButtonStackView()
    
    private let modalHeight: CGFloat
    private let modalState: LabelType
    
    var deinitClosure: (() -> Void)?
    
    init(_ type: LabelType) {
        self.modalState = type
        self.modalView = ModalView(type)
        self.modalHeight = type == .time ? 320 : 180
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    deinit {
        debugPrint(Self.self, "deinit")
    }
}

// MARK: - UI Setting Method

private extension ModalViewController {
    
    func setupUI() {
        setupButtons()
        configureSelf()
        setupLayout()
    }
    
    func configureSelf() {
        modalPresentationStyle = .formSheet
        sheetPresentationController?.preferredCornerRadius = 16
        sheetPresentationController?.detents = [.custom(resolver: { _ in self.modalHeight })]
        sheetPresentationController?.prefersGrabberVisible = true
        
        view.backgroundColor = .white
        view.addSubviews(modalView, buttons)
    }
    
    func setupLayout() {
        modalView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.width.equalToSuperview().inset(20)
            $0.height.greaterThanOrEqualTo(45)
        }
        
        buttons.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }
    
    func setupButtons() {
        buttons.buttonDelegate = self
    }
    
}

extension ModalViewController: ButtonsDelegate {
    
    func cancelButtonTapped() {
        debugPrint(#function)
        self.dismiss(animated: true)
    }
    
    func activeButtonTapped() {
        debugPrint(#function)
        
        switch modalState {
        case .time:
            let time = modalView.sendInputData().first ?? ""
            UserDefaults.standard.set(time, forKey: modalState.rawValue)
            
        case .weak:
            var weaks: String
            let data = modalView.sendInputData()
            
            if data.count == 0 {
                weaks = "없음"
            } else if data.count == 7 {
                weaks = "매일 반복"
            } else {
                weaks = data.joined(separator: ", ")
            }
                
            UserDefaults.standard.set(weaks, forKey: modalState.rawValue)
        }
        
        deinitClosure?()
        self.dismiss(animated: true)
    }
    
}
