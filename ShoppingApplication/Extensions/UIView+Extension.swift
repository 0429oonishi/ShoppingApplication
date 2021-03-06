//
//  UIView+Extension.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/06/16.
//

import UIKit

enum BorderPosition {
    case top
    case left
    case right
    case bottom
}

extension UIView {

    func addBorder(width: CGFloat, color: UIColor, position: BorderPosition) {
        let border = CALayer()
        switch position {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.height)
        case .bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        }
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
