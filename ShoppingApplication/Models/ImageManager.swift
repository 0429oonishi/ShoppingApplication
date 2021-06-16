//
//  ImageManager.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/06/16.
//

import UIKit

struct ImageManager {
    func setImage(button: UIButton, imageName: String) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: largeConfig)!
        button.setImage(image, for: .normal)
    }
}
