//
//  RealmModel.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/04/29.
//

import RealmSwift

final class ToBuyList: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var numberPurchased: Int = 0
    @objc dynamic var isChecked = false
}

final class Calculation: Object {
    @objc dynamic var price: String = ""
    @objc dynamic var isDeleted = false
    @objc dynamic var shoppingListCount: Int = 1
    @objc dynamic var shoppingListDiscount: Int = 0
}
