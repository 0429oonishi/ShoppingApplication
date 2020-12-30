
import UIKit
import RealmSwift

class ToBuyList: Object {
    @objc dynamic var toBuyListName: String = ""
    @objc dynamic var toBuyListNumber: Int = 0
    @objc dynamic var toBuyListCheckFlag: Bool = false
    @objc dynamic var toBuyListStrikethrough: Bool = false
}
