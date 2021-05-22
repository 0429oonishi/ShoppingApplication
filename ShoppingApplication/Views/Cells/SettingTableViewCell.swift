//
//  SettingTableViewCell.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/21.
//

import UIKit

final class SettingTableViewCell: UITableViewCell {

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
