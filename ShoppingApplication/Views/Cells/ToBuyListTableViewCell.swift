//
//  ToBuyListTableViewCell.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/21.
//

import UIKit

final class ToBuyListTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var numberOfToBuyLabel: UILabel!

    var onTapEvent: (() -> Void)?

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.attributedText = Strikethrough().erase(titleLabel.text!)

    }

    @IBAction private func checkButtonDidTapped(_ sender: Any) {
        onTapEvent?()
    }

    func configure(toBuyList: ToBuyList, onTapEvent: (() -> Void)?) {
        self.onTapEvent = onTapEvent
        titleLabel.text = toBuyList.title
        numberOfToBuyLabel.text = "×\(toBuyList.numberPurchased)"
        checkButton(toBuyList: toBuyList)
    }

    func checkButton(toBuyList: ToBuyList) {
        if toBuyList.isChecked {
            ImageManager().setImage(button: checkButton, imageName: "checkmark")
            titleLabel.attributedText = Strikethrough().draw(titleLabel.text!)
        } else {
            ImageManager().setImage(button: checkButton, imageName: "circle")
            titleLabel.attributedText = Strikethrough().erase(titleLabel.text!)
        }
    }

}
