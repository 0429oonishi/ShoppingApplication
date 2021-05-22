//
//  RealmModel.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/04/29.
//

import RealmSwift

final class ToBuyList: Object {
    @objc dynamic var toBuyListName: String = ""
    @objc dynamic var toBuyListNumber: Int = 0
    @objc dynamic var isButtonChecked = false
}

final class Calculation: Object {
    @objc dynamic var price: String = ""
    @objc dynamic var isCalculationDeleted = false
    @objc dynamic var shoppingListCount: Int = 1
    @objc dynamic var shoppingListDiscount: Int = 0
}
