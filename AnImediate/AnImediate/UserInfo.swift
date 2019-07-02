//
//  UserInfo.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/01.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class UserInfo : Object, NSCoding {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var comment = ""
    
    // idをプライマリキーに設定
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.comment, forKey: "comment")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.comment = aDecoder.decodeObject(forKey: "comment") as! String
    }
    
    required init() {
        super.init()
        self.id = ""
        self.name = ""
        self.comment = ""
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
}
