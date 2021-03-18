
import UIKit
import RealmSwift

//themeColorを共通化

protocol ShoppingListCollectionViewCellDelegate: class {
    func deleteButtonDidTapped(_ tag: Int)
    func discountButtonDidTapped(_ tag: Int)
}

class ShoppingListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var discountButton: UIButton!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var numberDecreaseButton: UIButton!
    @IBOutlet weak private var numberIncreaseButton: UIButton!
    @IBOutlet weak private var numberLabel: UILabel!
    
    private var realm = try! Realm()
    private var objects: Results<Calculation>!
    
    var delegate: ShoppingListCollectionViewCellDelegate?
    
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
    
    @IBAction func deleteButtonDidTapped(_ sender: UIButton) {
        delegate?.deleteButtonDidTapped(sender.tag)
    }
    
    @IBAction func discountButtonDidTapped(_ sender: UIButton) {
        delegate?.discountButtonDidTapped(sender.tag)
    }
    
    @IBAction func numberDecreaseButtonDidTapped(_ sender: UIButton) {
        if objects[sender.tag].shoppingListCount > 1 {
            try! realm.write {
                objects[sender.tag].shoppingListCount -= 1
            }
        }
        numberLabel.text = "×\(objects[sender.tag].shoppingListCount)"
    }
    
    @IBAction func numberIncreaseButtonDidTapped(_ sender: UIButton) {
        try! realm.write {
            objects[sender.tag].shoppingListCount += 1
        }
        numberLabel.text = "×\(objects[sender.tag].shoppingListCount)"
    }
    
    func setupCell(object: Calculation) {
        let discountButtonTitle = (object.shoppingListDiscount != 0) ? "-\(object.shoppingListDiscount)%" : "割引"
        discountButton.setTitle(discountButtonTitle, for: .normal)
        priceLabel.text = "\(String(object.price).addComma())円"
        numberLabel.text = "×\(object.shoppingListCount)"
        deleteButton.tintColor = themeColor
        layer.cornerRadius = 30
        layer.borderColor = themeColor.cgColor
        layer.borderWidth = 2
    }
    
    func setTag(index: Int) {
        deleteButton.tag = index
        discountButton.tag = index
        numberDecreaseButton.tag = index
        numberIncreaseButton.tag = index
    }
    
}
