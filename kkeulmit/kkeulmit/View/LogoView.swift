//
//  LogoView.swift
//  kkeulmit
//
//  Created by 장상경 on 4/11/25.
//

import UIKit

final class LogoView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        
        self.image = .logo
        self.contentMode = .scaleAspectFit
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
