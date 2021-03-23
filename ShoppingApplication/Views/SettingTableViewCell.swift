import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configure(text: String) {
        titleLabel.text = text
        separatorView.backgroundColor = UIColor.black.themeColor
    }

}
