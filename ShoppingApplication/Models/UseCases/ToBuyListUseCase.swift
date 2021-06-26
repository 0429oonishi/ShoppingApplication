//
//  ToBuyListUseCase.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/06/26.
//

import Foundation

final class ToBuyListUseCase {

    private let repository: ToBuyListRepositoryProtocol
    init(repository: ToBuyListRepositoryProtocol) {
        self.repository = repository
    }

    var toBuyLists: [ToBuyList] {
        return repository.readAll()
    }

    func add(_ toBuyList: ToBuyList) {
        repository.create(toBuyList)
    }

    func filter(_ term: String) -> [ToBuyList] {
        repository.filter(term)
    }

    func delete(_ tobuyLists: [ToBuyList]) {
        toBuyLists.forEach {
            repository.delete($0)
        }
    }

    func update(handler: () -> Void) {
        repository.update {
            handler()
        }
    }

}
