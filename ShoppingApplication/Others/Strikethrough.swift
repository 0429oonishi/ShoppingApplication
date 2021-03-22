//
//  Strikethrough.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/22.
//

import UIKit

func strikethrough(_ text: String) -> NSMutableAttributedString {
    let attributeString =  NSMutableAttributedString(string: text)
    attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 25), range: NSMakeRange(0, attributeString.length))
    attributeString.addAttributes([.foregroundColor : UIColor.gray, .strikethroughStyle: 2], range: NSMakeRange(0, text.count))
    return attributeString
}

func cancelStrikethrough(_ text: String) -> NSMutableAttributedString {
    let attributeString =  NSMutableAttributedString(string: text)
    attributeString.removeAttribute(.font, range: NSMakeRange(0, attributeString.length))
    return attributeString
}
