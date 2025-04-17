//
//  DetailViewController.swift
//  kkeulmit
//
//  Created by 장상경 on 4/15/25.
//

import UIKit
import SnapKit

final class DetailViewController: UIViewController {
    
    private let detailView: DetailViewModel
    private let navigationTitleView = UILabel()
    
    init(view: DetailViewModel) {
        self.detailView = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(Self.self, "deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = detailView
        navigationTitleView.text = detailView.navigationTitle
        navigationTitleView.textColor = .PersonalBlue.dark
        navigationTitleView.font = .SCDream(size: 24, weight: .bold)
        navigationTitleView.numberOfLines = 1
        navigationTitleView.textAlignment = .center
        navigationTitleView.backgroundColor = .clear
        navigationItem.titleView = navigationTitleView
        navigationController?.navigationBar.tintColor = .PersonalBlue.dark
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
}
