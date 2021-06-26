//
//  RealmRepository.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/21.
//

import RealmSwift

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
