//
//  WatchData.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/02.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class WatchData : Object, NSCoding {
    
    @objc dynamic var id = ""
    @objc dynamic var userId = ""
    @objc dynamic var animeId = ""
    @objc dynamic var createdAt = ""
    @objc dynamic var udatedAt = ""
    
    // idをプライマリキーに設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.userId, forKey: "userId")
        aCoder.encode(self.animeId, forKey: "animeId")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.udatedAt, forKey: "udatedAt")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.userId = aDecoder.decodeObject(forKey: "userId") as! String
        self.animeId = aDecoder.decodeObject(forKey: "animeId") as! String
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as! String
        self.udatedAt = aDecoder.decodeObject(forKey: "udatedAt") as! String
    }
    
    required init() {
        super.init()
        self.id = ""
        self.userId = ""
        self.animeId = ""
        self.createdAt = ""
        self.udatedAt = ""
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
}
