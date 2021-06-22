//
//  ToBuyList.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/04/29.
//

import RealmSwift

// 共通型
struct ToBuyList {
    var title: String
    var numberPurchased: Int
    var isChecked: Bool
}

// Realmに依存した型
final class RealmToBuyList: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var numberPurchased: Int = 0
    @objc dynamic var isChecked = false
}
