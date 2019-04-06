//
//  OfflineData.swift
//  Weather Forecast
//
//  Created by Emre Çelikörs on 5.04.2019.
//  Copyright © 2019 Emre Çelikörs. All rights reserved.
//

import Foundation
import RealmSwift

class OfflineData : Object {
    @objc dynamic var screenKey : String!
    @objc dynamic var lastSucceedData : Data!
    
    override static func primaryKey() -> String? {
        return "screenKey"
    }
    
    static func getOfflineData(primaryKey : String) -> OfflineData? {
        let realm = RealmManager.instance.defaultRealm
        return realm.object(ofType: OfflineData.self, forPrimaryKey: primaryKey)
    }
}

enum OfflineDataPrimaryKeyList : String {
    case TodayData
    case ForecastData
}
