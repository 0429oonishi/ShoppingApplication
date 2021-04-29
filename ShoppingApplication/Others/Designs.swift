//
//  Designs.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/22.
//

import UIKit

func viewDesign(view: UIView, shadowHeight: Int) {
    view.layer.borderWidth = 2
    view.layer.borderColor = UIColor.white.cgColor
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 5, height: shadowHeight)
    view.layer.shadowRadius = 5
    view.layer.shadowOpacity = 0.8
}

func viewDesign(view: UIView, x: CGFloat, y: CGFloat) {
    view.transform = CGAffineTransform(translationX: x, y: y)
    view.backgroundColor = .white
    view.layer.borderWidth = 3
    view.layer.cornerRadius = 30
    view.layer.shadowOpacity = 0.8
    view.layer.shadowRadius = 5
    view.layer.shadowOffset = CGSize(width: 3, height: 3)
    view.layer.shadowColor = UIColor.black.cgColor
}

func setButtonLayout(button: UIButton) {
    let buttonWidth = (UIScreen.main.bounds.width - 80) / 4
    button.layer.cornerRadius = buttonWidth / 2
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor.white.cgColor
}
