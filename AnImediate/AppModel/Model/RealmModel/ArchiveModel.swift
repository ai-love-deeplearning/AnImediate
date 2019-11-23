//
//  ArchiveModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/25.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import Foundation
import Realm
import RealmSwift

public class ArchiveModel: Object, NSCoding {
    
    @objc dynamic var id = ""
    @objc public dynamic var userID = ""
    @objc public dynamic var annictID = ""
    @objc public dynamic var animeStatus = ""
    @objc dynamic var createdAt = ""
    @objc public dynamic var updatedAt = ""
    
    override public static func primaryKey() -> String {
        return "id"
    }
    
    public static func read(uid: String) -> Results<ArchiveModel> {
        let realm = try! Realm()
        return realm.objects(self).filter("userID == %@", uid)
    }
    
    public static func read(uid: String, animeID: String) -> ArchiveModel? {
        let realm = try! Realm()
        return realm.objects(self).filter("userID == %@ && annictID == %@", uid, animeID).first
    }
    
    // TODO:- Dataとして読めるのは自分のデータだけ
    public static func readAsData(uid: String) -> Data? {
        let model = read(uid: uid)
        guard let encoded = try? NSKeyedArchiver.archivedData(withRootObject: Array(model), requiringSecureCoding: false) else {
            // TODO:- 上手いエラーハンドリングを考える。
            print("@@@ アーカイブのデータ化に失敗 @@@")
            return Data()
        }
        
        return encoded
    }
    
    public static func set(userID: String, annictID: String, animeStatus: String) {
        let realm = try! Realm()
        guard let model = read(uid: userID, animeID: annictID) else {
            let archive = ArchiveModel()
            archive.userID = userID
            archive.annictID = annictID
            archive.animeStatus = animeStatus
            archive.createdAt = AnimediateConfig.dateString
            
            try! realm.write {
                realm.add(archive)
            }
            return
        }
        
        try! realm.write {
            model.animeStatus = animeStatus
            model.updatedAt = AnimediateConfig.dateString
            realm.add(model, update: .modified)
        }
        
    }
    
    public static func set(archive: ArchiveModel) {
        let realm = try! Realm()
        let model = read(uid: archive.userID)
        
        if model.isEmpty {
            archive.createdAt = AnimediateConfig.dateString
        } else {
            archive.updatedAt = AnimediateConfig.dateString
        }
        
        try! realm.write {
            realm.add(archive, update: .modified)
        }
        
    }
    
    public static func set(archives: [ArchiveModel]) {
        let realm = try! Realm()
        guard let archive = archives.first else { return }
        let model = read(uid: archive.userID)
        
        print("@@@ archivemodel set @@@: \(model)")
        
        if model.isEmpty {
            archives.forEach {
                $0.id = NSUUID().uuidString
            }
            
            try! realm.write {
                realm.add(archives, update: .modified)
            }
            return
        }
        
        try! realm.write {
            realm.delete(model)
            realm.add(model, update: .modified)
        }
        
    }
    
    public static func delete(uid: String) {
        let realm = try! Realm()
        let model = read(uid: uid)
        try! realm.write {
            if !model.isEmpty {
                realm.delete(model)
            }
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.userID, forKey: "userID")
        aCoder.encode(self.annictID, forKey: "annictID")
        aCoder.encode(self.animeStatus, forKey: "animeStatus")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.updatedAt, forKey: "updatedAt")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        self.userID = aDecoder.decodeObject(forKey: "userID") as! String
        self.annictID = aDecoder.decodeObject(forKey: "annictID") as! String
        self.animeStatus = aDecoder.decodeObject(forKey: "animeStatus") as! String
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as! String
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as! String
    }
    
    required init() {
        super.init()
        self.id = NSUUID().uuidString
        self.userID = ""
        self.annictID = ""
        self.animeStatus = ""
        self.createdAt = ""
        self.updatedAt = ""
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

}
