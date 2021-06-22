//
//  Calculation.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/06/22.
//

import Foundation
import RealmSwift

struct Calculation {
    var price: String
    var isDeleted: Bool
    var shoppingListCount: Int
    var shoppingListDiscount: Int
}

final class RealmCalculation: Object {
    @objc dynamic var price: String = ""
    @objc dynamic var isDeleted = false
    @objc dynamic var shoppingListCount: Int = 1
    @objc dynamic var shoppingListDiscount: Int = 0
}
