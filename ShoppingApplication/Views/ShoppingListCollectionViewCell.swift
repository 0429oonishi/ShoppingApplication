
import UIKit

class ShoppingListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var shoppingListTrashButton: UIButton!
    @IBOutlet weak var shoppingListLabel: UILabel!
    @IBOutlet weak var shoppingListTaxRateButton: UIButton!
    @IBOutlet weak var shoppingListIncludeTaxOrNotButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(cellSize: CGFloat) {
        backgroundColor = .red
        layer.cornerRadius = 30
    }
    
    @IBAction func tappedShoppingListTrashButton(_ sender: Any) {
    }
    
    @IBAction func tappedShoppingListTaxRateButton(_ sender: Any) {
    }
    
    @IBAction func tappedShoppingListIncludeTaxOrNotButton(_ sender: Any) {
    }
}
