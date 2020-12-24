

import UIKit

class ToBuyListTableViewCell: UITableViewCell {

    @IBOutlet weak var toBuyTitleLabel: UILabel!
    @IBOutlet weak var toBuyCheckButton: UIButton!
    @IBOutlet weak var numberOfToBuyLabel: UILabel!
    private var toBuyCheckButtonFlag = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        setToBuyListCellButtonImage("circle")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func tappedToBuyListCellButton(_ sender: Any) {
        if toBuyCheckButtonFlag {
            setToBuyListCellButtonImage("checkmark")
            strikethrough()
            
        }else {
            setToBuyListCellButtonImage("circle")
            cancelStrikethrough()
            
        }
        toBuyCheckButtonFlag = !toBuyCheckButtonFlag
    }
    
    private func setToBuyListCellButtonImage(_ imageName: String) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let checkmarkImage = UIImage(systemName: imageName, withConfiguration: largeConfig)
        toBuyCheckButton.setImage(checkmarkImage, for: .normal)
    }
    
    private func strikethrough() {
        guard let text = toBuyTitleLabel.text else { return }
        let attributeString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 25), range: NSMakeRange(0, attributeString.length))
        attributeString.addAttributes([.foregroundColor : UIColor.gray, .strikethroughStyle: 2], range: NSMakeRange(0, text.count))
        toBuyTitleLabel.attributedText = attributeString
    }
    
    private func cancelStrikethrough() {
        guard let text = toBuyTitleLabel.text else { return }
        let attributeString =  NSMutableAttributedString(string: text)
        attributeString.removeAttribute(.font, range: NSMakeRange(0, attributeString.length))
        toBuyTitleLabel.attributedText = attributeString
    }
}
