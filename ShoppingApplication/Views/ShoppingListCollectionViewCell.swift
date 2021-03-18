
import UIKit
import RealmSwift

//themeColorを分離

class ShoppingListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var discountButton: UIButton!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var numberDecreaseButton: UIButton!
    @IBOutlet weak private var numberIncreaseButton: UIButton!
    @IBOutlet weak private var numberLabel: UILabel!
    
    private var realm = try! Realm()
    private var objects: Results<Calculation>!
    
    private var themeColor: UIColor {
        if let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") {
            return UIColor(code: themeColorString)
        } else {
            return .black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        objects = realm.objects(Calculation.self)
    }
    
    @IBAction func numberDecreaseButtonDidTapped(_ sender: UIButton) {
        if objects[sender.tag].shoppingListNumber > 1 {
            try! realm.write {
                objects[sender.tag].shoppingListNumber -= 1
            }
        }
        numberLabel.text = "×\(objects[sender.tag].shoppingListNumber)"
    }
    
    @IBAction func numberIncreaseButtonDidTapped(_ sender: UIButton) {
        try! realm.write {
            objects[sender.tag].shoppingListNumber += 1
        }
        numberLabel.text = "×\(objects[sender.tag].shoppingListNumber)"
    }
    
    func setupCell(object: Calculation) {
        priceLabel.text = "\(String(object.calculationPrice).addComma())円"
        numberLabel.text = "×\(object.shoppingListNumber)"
        deleteButton.tintColor = themeColor
        layer.cornerRadius = 30
        layer.borderColor = themeColor.cgColor
        layer.borderWidth = 2
    }
    
}
