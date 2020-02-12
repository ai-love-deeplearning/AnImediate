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
    @objc public dynamic var genre = ""
    @objc public dynamic var episodesCount = 0
    @objc public dynamic var watchersCount = 0
    @objc public dynamic var reviewsCount = 0
    @objc public dynamic var imageUrl = ""
    public var casts = List<String?>()
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
    
    public static func readSFGenre() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("genre == %@", AnimediateConfig.sfGenre).sorted(byKeyPath: "watchersCount", ascending: false)
    }
    
    public static func readBattleGenre() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("genre == %@", AnimediateConfig.battleGenre).sorted(byKeyPath: "watchersCount", ascending: false)
    }
    
    public static func readHorrorGenre() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("genre == %@", AnimediateConfig.horrorGenre).sorted(byKeyPath: "watchersCount", ascending: false)
    }
    
    public static func readRobotGenre() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("genre == %@", AnimediateConfig.robotGenre).sorted(byKeyPath: "watchersCount", ascending: false)
    }
    
    public static func readLoveGenre() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("genre == %@ OR genre == %@", AnimediateConfig.loveGenre, AnimediateConfig.loveComeGenre).sorted(byKeyPath: "watchersCount", ascending: false)
    }
    
    public static func readComedyGenre() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("genre == %@", AnimediateConfig.comedyGenre).sorted(byKeyPath: "watchersCount", ascending: false)
    }
    
    public static func readDailyGenre() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("genre == %@", AnimediateConfig.dailyGenre).sorted(byKeyPath: "watchersCount", ascending: false)
    }
    
    public static func readSportsGenre() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("genre == %@", AnimediateConfig.sportsGenre).sorted(byKeyPath: "watchersCount", ascending: false)
    }
    
    public static func readDramaGenre() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("genre == %@", AnimediateConfig.dramaGenre).sorted(byKeyPath: "watchersCount", ascending: false)
    }
    
    public static func readHistGenre() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("genre == %@", AnimediateConfig.histGenre).sorted(byKeyPath: "watchersCount", ascending: false)
    }
    
    public static func readWarGenre() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("genre == %@", AnimediateConfig.warGenre).sorted(byKeyPath: "watchersCount", ascending: false)
    }
    
    public static func readOtherGenre() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("genre == %@", AnimediateConfig.otherGenre).sorted(byKeyPath: "watchersCount", ascending: false)
    }
    
    // TODO :- ランキング取得処理
    public static func readAllRanking() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self).sorted(byKeyPath: "watchersCount", ascending: false)
    }
    
    public static func readAll() -> Results<AnimeModel> {
        let realm = try! Realm()
        return realm.objects(self)
    }
    
    public static func read(annictID: String) -> AnimeModel {
        let realm = try! Realm()
        
        if let model = realm.object(ofType: self, forPrimaryKey: annictID) {
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
        self.genre = value[FirebaseWorks.genre] as? String ?? ""
        self.episodesCount = value[FirebaseWorks.episodesCount] as? Int ?? 0
        self.seasonNameText = value[FirebaseWorks.seasonNameText] as? String ?? ""
        self.watchersCount = value[FirebaseWorks.watchersCount] as? Int ?? 0
        self.reviewsCount = value[FirebaseWorks.reviewsCount] as? Int ?? 0
        self.imageUrl = value[FirebaseWorks.imageURL] as? String ?? ""
        self.casts = value[FirebaseWorks.cast] as? List<String?> ?? List<String?>()
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
        self.casts = List<String?>()
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
