//
//  UICollectionViewCell+Extension.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/04/29.
//

import UIKit

extension UICollectionViewCell {

    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }

}
