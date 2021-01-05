
import UIKit
import RealmSwift

class ShoppingListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shoppingListDeleteButton: UIButton!
    @IBOutlet weak var shoppingListDiscountButton: UIButton!
    @IBOutlet weak var shoppingListPriceLabel: UILabel!
    @IBOutlet weak var shoppingListNumberDecreaseButton: UIButton!
    @IBOutlet weak var shoppingListNumberIncreaseButton: UIButton!
    @IBOutlet weak var shoppingListNumberLabel: UILabel!
    
    var realm = try! Realm()
    var calculation = Calculation()
    var objects: Results<Calculation>!
    private var themeColor: UIColor {
        if let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") {
            return UIColor(code: themeColorString)
        }else {
            return .black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        objects = realm.objects(Calculation.self)
    }
    
    @IBAction func tappedShoppingListNumberDecreaseButton(_ sender: UIButton) {
        if objects[sender.tag].shoppingListNumber > 1 {
            try! realm.write {
                objects[sender.tag].shoppingListNumber -= 1
            }
        }
        shoppingListNumberLabel.text = "×\(objects[sender.tag].shoppingListNumber)"
    }
    
    @IBAction func tappedShoppingListNumberIncreaseButton(_ sender: UIButton) {
        try! realm.write {
            objects[sender.tag].shoppingListNumber += 1
        }
        shoppingListNumberLabel.text = "×\(objects[sender.tag].shoppingListNumber)"
    }
    
    func setupCell(object: Calculation) {
        shoppingListPriceLabel.text = "\(addComma(object.calculationPrice))円"
        shoppingListNumberLabel.text = "×\(object.shoppingListNumber)"

        layer.cornerRadius = 30
        layer.borderColor = themeColor.cgColor
        layer.borderWidth = 2
    }
    
   
    
    private func addComma(_ wantToAddCommaString: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        let commaPrice = numberFormatter.string(from: NSNumber(integerLiteral: Int(wantToAddCommaString)!)) ?? "\(wantToAddCommaString)"
        return commaPrice
    }
}
