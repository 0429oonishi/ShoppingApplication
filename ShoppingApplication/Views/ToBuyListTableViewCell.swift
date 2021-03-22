
import UIKit
import RealmSwift

class ToBuyListTableViewCell: UITableViewCell {
    
    private enum ButtonType {
        case circle
        case checkmark
        var imageName: String {
            switch self {
            case .circle: return "circle"
            case .checkmark: return "checkmark"
            }
        }
    }
    private var objects: Results<ToBuyList>! { ToBuyListRealmRepository.shared.objects }
    var index: Int = 0
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var checkButton: UIButton!
    @IBOutlet weak private var numberOfToBuyLabel: UILabel!
    @IBOutlet weak private var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func checkButtonDidTapped(_ sender: Any) {
        let buttonType: ButtonType = objects[index].isButtonChecked ? .circle : .checkmark
        setImageToCellCheckButton(buttonType)
        ToBuyListRealmRepository.shared.update {
            objects[index].isButtonChecked = !objects[index].isButtonChecked
        }
    }
    
    func configure(object: ToBuyList) {
        separatorView.backgroundColor = UIColor.black.themeColor
        titleLabel.text = object.toBuyListName
        numberOfToBuyLabel.text = "×\(object.toBuyListNumber)"
        let buttonType: ButtonType = object.isButtonChecked ? .checkmark : .circle
        setImageToCellCheckButton(buttonType)
    }
   
    private func setImageToCellCheckButton(_ buttonType: ButtonType) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let image = UIImage(systemName: buttonType.imageName, withConfiguration: largeConfig)
        checkButton.setImage(image, for: .normal)
        guard let text = titleLabel.text else { return }
        titleLabel.attributedText = (buttonType == .circle) ? cancelStrikethrough(text) : strikethrough(text)
    }
    
}
