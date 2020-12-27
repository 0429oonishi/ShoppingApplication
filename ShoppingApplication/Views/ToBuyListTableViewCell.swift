

import UIKit

class ToBuyListTableViewCell: UITableViewCell {

    @IBOutlet weak var toBuyListCellTitleLabel: UILabel!
    @IBOutlet weak var toBuyListCellCheckButton: UIButton!
    @IBOutlet weak var numberOfToBuyLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    private var toBuyListCellCheckButtonFlag = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        selectionStyle = .none
        separatorView.backgroundColor = .red
        setToBuyListCellButtonImage("circle")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func tappedToBuyListCellCheckButton(_ sender: Any) {
        if toBuyListCellCheckButtonFlag {
            setToBuyListCellButtonImage("checkmark")
            strikethrough()
        }else {
            setToBuyListCellButtonImage("circle")
            cancelStrikethrough()
        }
        toBuyListCellCheckButtonFlag = !toBuyListCellCheckButtonFlag
    }
   
    private func setToBuyListCellButtonImage(_ imageName: String) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: largeConfig)
        toBuyListCellCheckButton.setImage(image, for: .normal)
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
