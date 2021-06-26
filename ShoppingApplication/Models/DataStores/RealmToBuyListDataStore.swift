//
//  RealmToBuyListDataStore.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/06/22.
//

import Foundation
import RealmSwift

final class RealmToBuyListDataStore: DataStoreProtocol {

    private let realm = try! Realm()
    private var objects: Results<RealmToBuyList> {
        return realm.objects(RealmToBuyList.self)
    }

    func create(_ toBuyList: ToBuyList) {
        let realmToBuyList = RealmToBuyList(toBuyList: toBuyList)
        try! realm.write {
            realm.add(realmToBuyList)
        }
    }

    func update(handler: () -> Void) {
        try! realm.write {
            handler()
        }
    }

    func delete(_ toBuyList: ToBuyList) {
        let realmToBuyList = RealmToBuyList(toBuyList: toBuyList)
        try! realm.write {
            realm.delete(realmToBuyList)
        }
    }

    func filter(_ toBuyListTerm: String) -> [ToBuyList] {
        try! realm.write {
            var toBuyLists = [ToBuyList]()
            let filteredObject = objects.filter(toBuyListTerm)
            for object in filteredObject {
                toBuyLists.append(ToBuyList(toBuyList: object))
            }
            return toBuyLists
        }
    }

    func readAll() -> [ToBuyList] {
        return objects.map { ToBuyList(toBuyList: $0) }
    }

}

private extension ToBuyList {
    init(toBuyList: RealmToBuyList) {
        self.title = toBuyList.title
        self.numberPurchased = toBuyList.numberPurchased
        self.isChecked = toBuyList.isChecked
    }
}

private extension RealmToBuyList {
    convenience init(toBuyList: ToBuyList) {
        self.init()
        self.title = toBuyList.title
        self.numberPurchased = toBuyList.numberPurchased
        self.isChecked = toBuyList.isChecked
    }
}
