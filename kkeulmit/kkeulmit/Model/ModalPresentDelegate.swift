//
//  ModalPresentDelegate.swift
//  kkeulmit
//
//  Created by 장상경 on 4/12/25.
//

import UIKit

protocol ModalPresentDelegate: AnyObject {
    func showModal(_ type: LabelType, _ indexPath: IndexPath)
    func showMailViewController()
}
