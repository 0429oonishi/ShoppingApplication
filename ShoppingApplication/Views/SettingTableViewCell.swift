
import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet private weak var settingTitleLabel: UILabel!
    @IBOutlet private weak var settingSeparatorView: UIView!
    private var themeColor: UIColor {
        guard let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") else {
            return .black
        }
        return UIColor(code: themeColorString)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(text: String) {
        settingTitleLabel.text = text
        settingSeparatorView.backgroundColor = themeColor
    }
    
}
