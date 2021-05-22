//
//  Strikethrough.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/22.
//

import UIKit

struct Strikethrough {

    func draw(_ text: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.font, value: UIFont.systemFont(ofSize: 25), range: NSRange(location: 0, length: attributeString.length))
        attributeString.addAttributes([.foregroundColor: UIColor.gray, .strikethroughStyle: 2], range: NSRange(location: 0, length: text.count))
        return attributeString
    }

    func erase(_ text: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.removeAttribute(.font, range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }

}
