
import UIKit
import RealmSwift

class ToBuyListTableViewCell: UITableViewCell {

    @IBOutlet weak var toBuyListCellTitleLabel: UILabel!
    @IBOutlet weak var toBuyListCellCheckButton: UIButton!
    @IBOutlet weak var numberOfToBuyLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    private var realm = try! Realm()
    private var toBuyList = ToBuyList()
    var objects: Results<ToBuyList>!
    var indexPathRow: Int = 0 {
        didSet { cancelStrikethrough() }
    }
    private var themeColor: UIColor {
        if let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") {
            return UIColor(code: themeColorString)
        }else {
            return .black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        objects = realm.objects(ToBuyList.self)
        selectionStyle = .none
        separatorView.backgroundColor = themeColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func tappedToBuyListCellCheckButton(_ sender: Any) {
        if !objects[indexPathRow].toBuyListCheckFlag {
            setToBuyListCellButtonImage("checkmark")
        }else {
            setToBuyListCellButtonImage("circle")
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
            setToBuyListCellButtonImage("circle")
        }else {
            setToBuyListCellButtonImage("checkmark")
        }
    }
   
    func setToBuyListCellButtonImage(_ imageName: String) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: largeConfig)
        toBuyListCellCheckButton.setImage(image, for: .normal)
        if imageName == "circle" {
            cancelStrikethrough()
        }else {
            strikethrough()
        }
    }
    
    func strikethrough() {
        guard let text = toBuyListCellTitleLabel.text else { return }
        let attributeString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 25), range: NSMakeRange(0, attributeString.length))
        attributeString.addAttributes([.foregroundColor : UIColor.gray, .strikethroughStyle: 2], range: NSMakeRange(0, text.count))
        toBuyListCellTitleLabel.attributedText = attributeString
    }
    
    func cancelStrikethrough() {
        guard let text = toBuyListCellTitleLabel.text else { return }
        let attributeString =  NSMutableAttributedString(string: text)
        attributeString.removeAttribute(.font, range: NSMakeRange(0, attributeString.length))
        toBuyListCellTitleLabel.attributedText = attributeString
    }
}
