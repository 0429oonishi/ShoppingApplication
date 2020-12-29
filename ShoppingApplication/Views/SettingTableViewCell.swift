
import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var settingTitleLabel: UILabel!
    @IBOutlet weak var settingArrowLabel: UILabel!
    @IBOutlet weak var settingSeparatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        settingSeparatorView.backgroundColor = .red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
