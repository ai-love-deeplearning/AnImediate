//
//  Episode.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/17.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Episode: Object {
    @objc dynamic var id = 0
    @objc dynamic var sortNumber = 0
    @objc dynamic var numberText = ""
    @objc dynamic var title = ""
    @objc dynamic var animeId = 0
    @objc dynamic var animeTitle = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    init(value: [String: Any]) {
        super.init()
        
        self.id = value["id"] as? Int ?? 0
        self.sortNumber = value["sortNumber"] as? Int ?? 0
        self.numberText = value["numberText"] as? String ?? ""
        self.title = value["title"] as? String ?? ""
        self.animeId = value["animeId"] as? Int ?? 0
        self.animeTitle = value["animeTitle"] as? String ?? ""
    }
    
    required init() {
        super.init()
        self.id = 0
        self.sortNumber = 0
        self.numberText = ""
        self.title = ""
        self.animeId = 0
        self.animeTitle = ""
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}
