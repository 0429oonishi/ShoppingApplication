//
//  RealmToBuyListRepository.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/06/22.
//

import Foundation

final class ToBuyListRepositoryImpl: ToBuyListRepositoryProtocol {

    private let dataStore: DataStoreProtocol
    init (dataStore: DataStoreProtocol) {
        self.dataStore = dataStore
    }

    func create(_ toBuyList: ToBuyList) {
        dataStore.create(toBuyList)
    }

    func update(handler: () -> Void) {
        dataStore.update {
            handler()
        }
    }

    func delete(_ toBuyList: ToBuyList) {
        dataStore.delete(toBuyList)
    }

    func filter(_ toBuyListTerm: String) -> [ToBuyList] {
        dataStore.filter(toBuyListTerm)
    }

    func readAll() -> [ToBuyList] {
        return dataStore.readAll()
    }

}
