
import UIKit

class ShoppingListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var shoppingListTrashButton: UIButton!
    @IBOutlet weak var shoppingListLabel: UILabel!
    @IBOutlet weak var shoppingListTaxRateButton: UIButton!
    @IBOutlet weak var shoppingListIncludeTaxOrNotButton: UIButton!
    private var themeColor: UIColor {
        if let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") {
            return UIColor(code: themeColorString)
        }else {
            return .black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(cellSize: CGFloat) {
        layer.cornerRadius = 30
        layer.borderColor = themeColor.cgColor
        layer.borderWidth = 2
    }
    
    @IBAction func tappedShoppingListTrashButton(_ sender: Any) {
    }
    
    @IBAction func tappedShoppingListTaxRateButton(_ sender: Any) {
        if shoppingListTaxRateButton.currentTitle == "10%" {
            shoppingListTaxRateButton.setTitle("8%", for: .normal)
        }else {
            shoppingListTaxRateButton.setTitle("10%", for: .normal)
        }
    }
    
    @IBAction func tappedShoppingListIncludeTaxOrNotButton(_ sender: Any) {
        if shoppingListIncludeTaxOrNotButton.currentTitle == "税込" {
            shoppingListIncludeTaxOrNotButton.setTitle("税抜", for: .normal)
        }else {
            shoppingListIncludeTaxOrNotButton.setTitle("税込", for: .normal)
        }
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
