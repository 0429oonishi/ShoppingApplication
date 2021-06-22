//
//  RealmRepository.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/21.
//

import RealmSwift

final class ToBuyListRealmRepository {

    static let shared = ToBuyListRealmRepository()
    private init() {}

    let realm = try! Realm()
    lazy var toDoLists: Results<RealmToBuyList> = realm.objects(RealmToBuyList.self)

    func add(_ toBuyList: RealmToBuyList) {
        try! realm.write {
            realm.add(toBuyList)
        }
    }

    func delete(_ toBuyList: Results<RealmToBuyList>) {
        try! realm.write {
            realm.delete(toBuyList)
        }
    }

    func filter(_ toBuyListTerm: String) -> Results<RealmToBuyList> {
        try! realm.write {
            return toDoLists.filter(toBuyListTerm)
        }
    }

    func update(completion: () -> Void) {
        try! realm.write {
            completion()
        }
    }
}

final class CalculationRealmRepository {

    static let shared = CalculationRealmRepository()
    private init() {}

    let realm = try! Realm()
    lazy var calculations: Results<RealmCalculation> = realm.objects(RealmCalculation.self)

    func add(_ calculation: RealmCalculation) {
        try! realm.write {
            realm.add(calculation)
        }
    }

    func delete(_ calculation: Results<RealmCalculation>) {
        try! realm.write {
            realm.delete(calculation)
        }
    }

    func filter(_ calculationTerm: String) -> Results<RealmCalculation> {
        try! realm.write {
            return calculations.filter(calculationTerm)
        }
    }

    func update(completion: () -> Void) {
        try! realm.write {
            completion()
        }
    }
}
