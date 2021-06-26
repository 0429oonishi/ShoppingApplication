//
//  DataStoreProtocol.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/06/22.
//

import Foundation

// 共通型
protocol DataStoreProtocol {
    func create(_ toBuyList: ToBuyList)
    func update(handler: () -> Void)
    func delete(_ toBuyList: ToBuyList)
    func filter(_ toBuyListTerm: String) -> [ToBuyList]
    func readAll() -> [ToBuyList]
}
