
import UIKit
import RealmSwift

class ToBuyList: Object {
    @objc dynamic var toBuyListName: String = ""
    @objc dynamic var toBuyListNumber: Int = 0
    @objc dynamic var toBuyListCheckFlag: Bool = false
}

class Calculation: Object {
    @objc dynamic var calculationPrice: String = ""
    @objc dynamic var calculationDeleteFlag: Bool = false
    @objc dynamic var shoppingListNumber: Int = 1
    @objc dynamic var shoppingListDiscount: Int = 0
}
