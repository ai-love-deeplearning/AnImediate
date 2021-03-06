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
    @objc public dynamic var evalPoint = ""
    @objc public dynamic var predictPoint = ""
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
    
    public static func set(uid: String, animeID: String, evalPoint: String) -> Bool {
        let realm = try! Realm()
        guard let model = read(uid: uid, animeID: animeID) else { return false }
        
        try! realm.write {
            model.evalPoint = evalPoint
            model.updatedAt = AnimediateConfig.dateString
            realm.add(model, update: .modified)
        }
        return true
    }
    
    public static func set(uid: String, animeID: String, predictPoint: String) {
        let realm = try! Realm()
        guard let model = read(uid: uid, animeID: animeID) else {
            let archive = ArchiveModel()
            archive.userID = uid
            archive.annictID = animeID
            archive.animeStatus = AnimeStatusType.none.rawValue
            archive.evalPoint = ""
            archive.predictPoint = predictPoint
            archive.createdAt = AnimediateConfig.dateString
            
            try! realm.write {
                realm.add(archive)
            }
            
            return
        }
        
        try! realm.write {
            model.predictPoint = predictPoint
            model.updatedAt = AnimediateConfig.dateString
            realm.add(model, update: .modified)
        }
    }
    
    public static func set(userID: String, annictID: String, animeStatus: String, evalPoint: String, predictPoint: String) {
        let realm = try! Realm()
        guard let model = read(uid: userID, animeID: annictID) else {
            let archive = ArchiveModel()
            archive.userID = userID
            archive.annictID = annictID
            archive.animeStatus = animeStatus
            archive.evalPoint = evalPoint
            archive.predictPoint = predictPoint
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
        
        if model.isNotEmpty {
            try! realm.write {
                realm.delete(model)
            }
        }
        
        archives.forEach{ $0.id = NSUUID().uuidString }

        try! realm.write {
            realm.add(archives)
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
    
    // 配列同士の差集合を得る
    public static func except(_ base: [ArchiveModel], _ prepare: [ArchiveModel]) -> [ArchiveModel] {
        var ret = [ArchiveModel]()
        let baseIDs = base.map{ $0.annictID }
        let prepareIDs = prepare.map{ $0.annictID }
        
        for (i, prepareID) in prepareIDs.enumerated() {
            if !baseIDs.contains(prepareID) {
                ret.append(prepare[i])
            }
        }
        
        return ret
    }
    
    // 配列同士の積集合を得る
    public static func intersect(_ base: [ArchiveModel], _ prepare: [ArchiveModel]) -> [ArchiveModel] {
        var ret = [ArchiveModel]()
        let baseIDs = base.map{ $0.annictID }
        let prepareIDs = prepare.map{ $0.annictID }
        
        for (i, prepareID) in prepareIDs.enumerated() {
            if baseIDs.contains(prepareID) {
                ret.append(prepare[i])
            }
        }

        return ret
    }
    
    public static func reccomend(_ myID: String, _ peerID: String) -> [ArchiveModel] {
        let peerArchives = Array(ArchiveModel.read(uid: peerID).filter("animeStatus == %@", AnimeStatusType.done.rawValue))
        let myArchives = Array(ArchiveModel.read(uid: myID).filter("animeStatus == %@", AnimeStatusType.done.rawValue))
        let onlyMe = except(peerArchives, myArchives)
        var results: [ArchiveModel] = []
        let threshold = "5.0"
        
        onlyMe.forEach{
            let archive = ArchiveModel.read(uid: peerID, animeID: $0.annictID)!
            if archive.predictPoint == threshold {
                results.append(archive)
            }
        }
        return results
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.userID, forKey: "userID")
        aCoder.encode(self.annictID, forKey: "annictID")
        aCoder.encode(self.animeStatus, forKey: "animeStatus")
        aCoder.encode(self.evalPoint, forKey: "evalPoint")
        aCoder.encode(self.predictPoint, forKey: "predictPoint")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.updatedAt, forKey: "updatedAt")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        self.userID = aDecoder.decodeObject(forKey: "userID") as! String
        self.annictID = aDecoder.decodeObject(forKey: "annictID") as! String
        self.animeStatus = aDecoder.decodeObject(forKey: "animeStatus") as! String
        self.evalPoint = aDecoder.decodeObject(forKey: "evalPoint") as! String
        self.predictPoint = aDecoder.decodeObject(forKey: "predictPoint") as! String
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as! String
        self.updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as! String
    }
    
    required init() {
        super.init()
        self.id = NSUUID().uuidString
        self.userID = ""
        self.annictID = ""
        self.animeStatus = ""
        self.evalPoint = ""
        self.predictPoint = ""
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
