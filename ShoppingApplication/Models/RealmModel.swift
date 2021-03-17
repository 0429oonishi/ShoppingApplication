
import UIKit
import RealmSwift

class ToBuyList: Object {
    @objc dynamic var toBuyListName: String = ""
    @objc dynamic var toBuyListNumber: Int = 0
    @objc dynamic var isToBuyListCheck: Bool = false
}

class Calculation: Object {
    @objc dynamic var calculationPrice: String = ""
    @objc dynamic var isCalculationDelete: Bool = false
    @objc dynamic var shoppingListNumber: Int = 1
    @objc dynamic var shoppingListDiscount: Int = 0
}
