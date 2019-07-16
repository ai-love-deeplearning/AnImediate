//
//  Work.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Work: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var animeId = ""
    @objc dynamic var title = ""
    @objc dynamic var episodesCount = 0
    @objc dynamic var seasonNameText = ""
    @objc dynamic var watchersCount = 0
    @objc dynamic var reviewsCount = 0
    @objc dynamic var imageUrl = ""
    @objc dynamic var officialSiteUrl = ""
    @objc dynamic var wikipediaUrl = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    init(value: [String: Any]) {
        super.init()
        let intId = value["id"] as? Int ?? 0
        self.animeId = String(intId)
        self.title = value["title"] as? String ?? ""
        self.episodesCount = value["episodesCount"] as? Int ?? 0
        self.seasonNameText = value["seasonNameText"] as? String ?? ""
        self.watchersCount = value["watchersCount"] as? Int ?? 0
        self.reviewsCount = value["reviewsCount"] as? Int ?? 0
        self.imageUrl = value["imageURL"] as? String ?? ""
        self.officialSiteUrl = value["officialSiteUrl"] as? String ?? ""
        self.wikipediaUrl = value["wikipediaUrl"] as? String ?? ""
    }
    
    required init() {
        super.init()
        self.animeId = ""
        self.title = ""
        self.episodesCount = 0
        self.seasonNameText = ""
        self.watchersCount = 0
        self.reviewsCount = 0
        self.imageUrl = ""
        self.officialSiteUrl = ""
        self.wikipediaUrl = ""
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}
