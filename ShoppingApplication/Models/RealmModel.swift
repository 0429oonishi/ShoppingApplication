
import UIKit
import RealmSwift

class ToBuyList: Object {
    @objc dynamic var toBuyListName: String = ""
    @objc dynamic var toBuyListNumber: Int = 0
    @objc dynamic var isButtonChecked: Bool = false
}

class Calculation: Object {
    @objc dynamic var price: String = ""
    @objc dynamic var isCalculationDeleted: Bool = false
    @objc dynamic var shoppingListCount: Int = 1
    @objc dynamic var shoppingListDiscount: Int = 0
}
