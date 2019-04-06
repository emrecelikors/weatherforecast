//
//  RealmManager.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 5.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    static let instance = RealmManager()
    
    fileprivate(set) var defaultRealm: Realm
    
    init() {
        defaultRealm = try! Realm()
        
    }
}

extension Object {
    
    func realmInst() -> Realm {
        return self.realm ?? RealmManager.instance.defaultRealm
    }
    
    /** Must be called from main thread */
    func save(_ update: Bool = true) throws {
        let realm = self.realmInst()
        try realm.write {
            realm.add(self, update: update)
        }
    }
    
}
