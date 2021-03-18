//
//  String+Extension.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/19.
//

import Foundation

extension String {
    
    func addComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        let commaPrice = numberFormatter.string(from: NSNumber(integerLiteral: Int(self)!)) ?? "\(self)"
        return commaPrice
    }
    
}
