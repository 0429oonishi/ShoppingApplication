
import UIKit
import RealmSwift

enum CellButtonImage: String {
    case circle = "circle"
    case checkmark = "checkmark"
}

class ToBuyListTableViewCell: UITableViewCell {

    @IBOutlet weak var toBuyListCellTitleLabel: UILabel!
    @IBOutlet weak var toBuyListCellCheckButton: UIButton!
    @IBOutlet weak var numberOfToBuyLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    private var realm = try! Realm()
    private var toBuyList = ToBuyList()
    private var objects: Results<ToBuyList>!
    var indexPathRow: Int = 0 {
        didSet { cancelStrikethrough() }
    }
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func tappedToBuyListCellCheckButton(_ sender: Any) {
        if !objects[indexPathRow].toBuyListCheckFlag {
            setToBuyListCellButtonImage(CellButtonImage.checkmark.rawValue)
        }else {
            setToBuyListCellButtonImage(CellButtonImage.circle.rawValue)
        }
        try! realm.write {
            objects[indexPathRow].toBuyListCheckFlag = !objects[indexPathRow].toBuyListCheckFlag
        }
    }
    
    func setCell(object: ToBuyList) {
        separatorView.backgroundColor = themeColor
        toBuyListCellTitleLabel.text = object.toBuyListName
        numberOfToBuyLabel.text = "×\(object.toBuyListNumber)"
        if !object.toBuyListCheckFlag {
            setToBuyListCellButtonImage(CellButtonImage.circle.rawValue)
        }else {
            setToBuyListCellButtonImage(CellButtonImage.checkmark.rawValue)
        }
    }
   
    private func setToBuyListCellButtonImage(_ imageName: String) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: largeConfig)
        toBuyListCellCheckButton.setImage(image, for: .normal)
        if imageName == CellButtonImage.circle.rawValue {
            cancelStrikethrough()
        }else {
            strikethrough()
        }
    }
    
    private func strikethrough() {
        guard let text = toBuyListCellTitleLabel.text else { return }
        let attributeString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 25), range: NSMakeRange(0, attributeString.length))
        attributeString.addAttributes([.foregroundColor : UIColor.gray, .strikethroughStyle: 2], range: NSMakeRange(0, text.count))
        toBuyListCellTitleLabel.attributedText = attributeString
    }
    
    private func cancelStrikethrough() {
        guard let text = toBuyListCellTitleLabel.text else { return }
        let attributeString =  NSMutableAttributedString(string: text)
        attributeString.removeAttribute(.font, range: NSMakeRange(0, attributeString.length))
        toBuyListCellTitleLabel.attributedText = attributeString
    }
}
