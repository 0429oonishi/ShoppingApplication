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
    
    static var delete: String {
        return "消去"
    }
    
    static var deleteAll: String {
        return "全て消去する"
    }
    
    static var deleteMemo: String {
        return "チェックしたメモを\n消去しますか？"
    }
    
    static var deleteList: String {
        return "これを消去しますか？"
    }
    
    static var deleteAttention: String {
        return "消去したものは元に戻せません。"
    }
    
    static var cancel: String {
        return "キャンセル"
    }
    
    static var close: String {
        return "閉じる"
    }
    
    static var error: String {
        return "エラー"
    }
    
    static var priceTooLarge: String {
        return "金額が大きすぎます"
    }
    
    static var resultFoundInSurrounding: String {
        return "周辺で探した結果"
    }
    
    static var searchResultIsZero: String {
        return "検索結果は0です"
    }
    
}
