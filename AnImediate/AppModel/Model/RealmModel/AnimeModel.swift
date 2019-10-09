//
//  AnimeModel.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import UIKit
import Realm
import RealmSwift

public class AnimeModel: Object {
    // TODO:- 新しいデータ構造に対応
    @objc public dynamic var id = ""
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
    
    public static func readCurrentTerm() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("seasonNameText == %@", AnimediateConfig.CurrentTerm)
    }
    // TODO :- ランキング取得処理
//    public static func readRanking() -> Results<AnimeModel> {
//        let realm = try! Realm()
//        return realm.objects(self).filter("seasonNameText == %@", AnimediateConfig.CurrentTerm)
//    }
    
    public static func read(id: String) -> AnimeModel {
        let realm = try! Realm()
        
        if let model = realm.object(ofType: self, forPrimaryKey: id) {
            return model
        }
        
        let model = AnimeModel()
        try! realm.write {
            realm.add(model, update: .modified)
        }
        return model
        
    }
    
    public static func set(models: [AnimeModel]) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(models, update: .modified)
        }
    }
    
    public init(value: [String: Any]) {
        super.init()
        self.id = value[FirebaseWorks.animeID] as? String ?? ""
        self.annictID = value[FirebaseWorks.animeID] as? String ?? ""
        self.title = value[FirebaseWorks.title] as? String ?? ""
        self.synopsis = value[FirebaseWorks.synopsis] as? String ?? ""
        self.episodesCount = value[FirebaseWorks.episodesCount] as? Int ?? 0
        self.seasonNameText = value[FirebaseWorks.seasonNameText] as? String ?? ""
        self.watchersCount = value[FirebaseWorks.watchersCount] as? Int ?? 0
        self.reviewsCount = value[FirebaseWorks.reviewsCount] as? Int ?? 0
        self.imageUrl = value[FirebaseWorks.imageURL] as? String ?? ""
        self.casts = value[FirebaseWorks.cast] as? List<String> ?? List<String>()
        self.manager = value[FirebaseWorks.manager] as? String ?? ""
        self.company = value[FirebaseWorks.company] as? String ?? ""
        self.officialSiteUrl = value[FirebaseWorks.officialSiteURL] as? String ?? ""
        self.wikipediaUrl = value[FirebaseWorks.wikipediaURL] as? String ?? ""
    }
    
    required init() {
        super.init()
        self.id = NSUUID().uuidString
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
