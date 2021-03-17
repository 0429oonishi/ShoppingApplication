
import UIKit
import RealmSwift

//themeColorを共通化
//realmの処理を切り分ける

class ToBuyListTableViewCell: UITableViewCell {
    private enum CellButtonType {
        case circle
        case checkmark
        var imageName: String {
            switch self {
            case .circle: return "circle"
            case .checkmark: return "checkmark"
            }
        }
    }
    @IBOutlet weak private var cellTitleLabel: UILabel!
    @IBOutlet weak private var cellCheckButton: UIButton!
    @IBOutlet weak private var numberOfToBuyLabel: UILabel!
    @IBOutlet weak private var separatorView: UIView!
    private var realm = try! Realm()
    private var toBuyList = ToBuyList()
    private var objects: Results<ToBuyList>!
    var index: Int = 0
    private var themeColor: UIColor {
        guard let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") else {
            return .black
        }
        return UIColor(code: themeColorString)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        objects = realm.objects(ToBuyList.self)
        selectionStyle = .none
    }
    
    @IBAction func cellCheckButtonDidTapped(_ sender: Any) {
        let buttonType: CellButtonType = objects[index].isButtonChecked ? .circle : .checkmark
        setImageToCellCheckButton(buttonType)
        try! realm.write {
            objects[index].isButtonChecked = !objects[index].isButtonChecked
        }
    }
    
    func setupCell(object: ToBuyList) {
        separatorView.backgroundColor = themeColor
        cellTitleLabel.text = object.toBuyListName
        numberOfToBuyLabel.text = "×\(object.toBuyListNumber)"
        let buttonType: CellButtonType = object.isButtonChecked ? .checkmark : .circle
        setImageToCellCheckButton(buttonType)
    }
   
    private func setImageToCellCheckButton(_ imageType: CellButtonType) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let image = UIImage(systemName: imageType.imageName, withConfiguration: largeConfig)
        cellCheckButton.setImage(image, for: .normal)
        imageType == .circle ? cancelStrikethrough() : strikethrough()
    }
    
    private func strikethrough() {
        guard let text = cellTitleLabel.text else { return }
        let attributeString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 25), range: NSMakeRange(0, attributeString.length))
        attributeString.addAttributes([.foregroundColor : UIColor.gray, .strikethroughStyle: 2], range: NSMakeRange(0, text.count))
        cellTitleLabel.attributedText = attributeString
    }
    
    private func cancelStrikethrough() {
        guard let text = cellTitleLabel.text else { return }
        let attributeString =  NSMutableAttributedString(string: text)
        attributeString.removeAttribute(.font, range: NSMakeRange(0, attributeString.length))
        cellTitleLabel.attributedText = attributeString
    }
}
