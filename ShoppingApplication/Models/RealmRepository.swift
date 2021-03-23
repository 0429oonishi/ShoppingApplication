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
    lazy var toDoLists: Results<ToBuyList> = realm.objects(ToBuyList.self)
    
    func add(_ toBuyList: ToBuyList) {
        try! realm.write {
            realm.add(toBuyList)
        }
    }

    func delete(_ toBuyList: Results<ToBuyList>) {
        try! realm.write {
            realm.delete(toBuyList)
        }
    }

    func filter(_ toBuyListTerm: String) -> Results<ToBuyList> {
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
    lazy var calculations: Results<Calculation> = realm.objects(Calculation.self)

    func add(_ calculation: Calculation) {
        try! realm.write {
            realm.add(calculation)
        }
    }

    func delete(_ calculation: Results<Calculation>) {
        try! realm.write {
            realm.delete(calculation)
        }
    }

    func filter(_ calculationTerm: String) -> Results<Calculation> {
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
