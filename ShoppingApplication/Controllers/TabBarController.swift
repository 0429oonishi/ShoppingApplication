//
//  TabBarController.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/21.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UITabBar.appearance().tintColor = UIColor.black.themeColor
    }
    
}
