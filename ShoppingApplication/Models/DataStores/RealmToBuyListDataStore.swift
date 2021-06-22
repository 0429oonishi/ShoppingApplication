//
//  RealmDataStore.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/06/22.
//

import Foundation
import RealmSwift

final class RealmDataStore: DataStoreProtocol {
    
    private let realm = try! Realm()
    private var objects: Results<RealmToBuyList> {
        return realm.objects(RealmToBuyList.self)
    }
    
    func create(_ toBuyList: ToBuyList) {
        <#code#>
    }
    
    func update(handler: () -> Void) {
        <#code#>
    }
    
    func delete(_ toBuyList: ToBuyList) {
        <#code#>
    }
    
    func filter(_ toBuyListTerm: String) -> [ToBuyList] {
        <#code#>
    }
    
}
