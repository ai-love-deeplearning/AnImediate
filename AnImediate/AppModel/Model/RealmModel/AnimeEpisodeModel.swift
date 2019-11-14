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
    @objc dynamic var id = ""
    @objc public dynamic var animeTitle = ""
    @objc public dynamic var anicctID = 0
    @objc public dynamic var episodeTitle = ""
    @objc public dynamic var sortNumber = 0
    @objc public dynamic var numberText = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    // TODO:- annictIDをStringに変更(Firebaseから直す必要あり)
    public static func read(annictID: String) -> Results<AnimeEpisodeModel>{
        let realm = try! Realm()
        return realm.objects(self).filter("anicctID == %@", Int(annictID)!)
    }
    
    public static func set(models: [AnimeEpisodeModel]) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(models, update: .modified)
        }
    }
    
    public init(value: [String: Any]) {
        super.init()
        self.id = value["id"] as? String ?? NSUUID().uuidString
        self.anicctID = value["animeId"] as? Int ?? 0
        self.animeTitle = value["animeTitle"] as? String ?? ""
        self.episodeTitle = value["title"] as? String ?? ""
        self.sortNumber = value["sortNumber"] as? Int ?? 0
        self.numberText = value["numberText"] as? String ?? ""
    }
    
    required init() {
        super.init()
        self.id = NSUUID().uuidString
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
