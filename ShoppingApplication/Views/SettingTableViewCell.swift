
import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(text: String) {
        titleLabel.text = text
        separatorView.backgroundColor = UIColor.black.themeColor
    }
    
}
