//
//  ToBuyListDataStore.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/06/22.
//

import Foundation

protocol ToBuyListDataStoreProtocol {
    func create(_ toBuyList: ToBuyList)
    func update(handler: () -> Void)
    func delete(_ toBuyList: ToBuyList)
    func filter(_ toBuyListTerm: String) -> [ToBuyList]
}
