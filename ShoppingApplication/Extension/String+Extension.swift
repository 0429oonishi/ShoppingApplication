//
//  String+Extension.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/19.
//

import Foundation

extension String {
    
    var commaFormated: String {
        guard let number = Int(self) else { return self }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        return numberFormatter.string(from: NSNumber(integerLiteral: number))!
    }
    
}
