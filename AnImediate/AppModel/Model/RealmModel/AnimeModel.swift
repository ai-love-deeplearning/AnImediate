//
//  AnimeModel.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

public class AnimeModel: Object {
    // TODO:- 新しいデータ構造に対応
    @objc public dynamic var annictID = ""
    @objc public dynamic var title = ""
    @objc public dynamic var synopsis = ""
    @objc public dynamic var seasonNameText = ""
    @objc public dynamic var episodesCount = 0
    @objc public dynamic var watchersCount = 0
    @objc public dynamic var reviewsCount = 0
    @objc public dynamic var imageUrl = ""
    public var casts = List<String>()
    @objc public dynamic var manager = ""
    @objc public dynamic var company = ""
    @objc public dynamic var officialSiteUrl = ""
    @objc public dynamic var wikipediaUrl = ""
    
    override public static func primaryKey() -> String? {
        return "annictID"
    }
    
    public static func read(id: String) -> AnimeModel {
        let realm = try! Realm()
        
        if let model = realm.object(ofType: self, forPrimaryKey: id) {
            return model
        }
        
        let model = AnimeModel()
        try! realm.write {
            realm.add(model)
        }
        return model
        
    }
    
    public init(value: [String: Any]) {
        super.init()
        let intId = value["id"] as? Int ?? 0
        self.annictID = String(intId)
        self.title = value["title"] as? String ?? ""
        self.episodesCount = value["episodesCount"] as? Int ?? 0
        self.seasonNameText = value["seasonNameText"] as? String ?? ""
        self.watchersCount = value["watchersCount"] as? Int ?? 0
        self.reviewsCount = value["reviewsCount"] as? Int ?? 0
        self.imageUrl = value["imageURL"] as? String ?? ""
        self.casts = value["casts"] as? List<String> ?? List<String>()
        self.manager = value["manager"] as? String ?? ""
        self.company = value["company"] as? String ?? ""
        self.officialSiteUrl = value["officialSiteUrl"] as? String ?? ""
        self.wikipediaUrl = value["wikipediaUrl"] as? String ?? ""
    }
    
    required init() {
        super.init()
        self.annictID = ""
        self.title = ""
        self.episodesCount = 0
        self.seasonNameText = ""
        self.watchersCount = 0
        self.reviewsCount = 0
        self.imageUrl = ""
        self.casts = List<String>()
        self.manager = ""
        self.company = ""
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
