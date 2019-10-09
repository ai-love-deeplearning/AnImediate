//
//  AnimeEpisodeModel.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/17.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

public class AnimeEpisodeModel: Object {
    @objc dynamic var id = 0
    @objc dynamic var animeTitle = ""
    @objc dynamic var episodeTitle = ""
    @objc dynamic var sortNumber = 0
    @objc dynamic var numberText = ""
    @objc dynamic var anicctID = 0
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public init(value: [String: Any]) {
        super.init()
        self.id = value["id"] as? Int ?? 0
        self.anicctID = value["animeId"] as? Int ?? 0
        self.animeTitle = value["animeTitle"] as? String ?? ""
        self.episodeTitle = value["episodeTitle"] as? String ?? ""
        self.sortNumber = value["sortNumber"] as? Int ?? 0
        self.numberText = value["numberText"] as? String ?? ""
    }
    
    required init() {
        super.init()
        self.id = 0
        self.anicctID = 0
        self.animeTitle = ""
        self.episodeTitle = ""
        self.sortNumber = 0
        self.numberText = ""
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}
