//
//  ArchiveModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/25.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public class ArchiveModel: Object, NSCoding {
    
    @objc dynamic var id = ""
    @objc dynamic var userId = ""
    @objc dynamic var animeId = ""
    @objc dynamic var animeStatus = ""
    @objc dynamic var createdAt = ""
    @objc dynamic var udatedAt = ""
    
    override public static func primaryKey() -> String {
        return "id"
    }
    
    public static func read() -> Results<ArchiveModel> {
        let realm = try! Realm()
        return realm.objects(self)
    }
    
    public static func read(id: String) -> Results<ArchiveModel>{
        let realm = try! Realm()
        return realm.objects(self).filter("userId == %@", id)
    }
    
    public static func readAsData() -> Data {
        let model = read()
        guard let encoded = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false) else {
            // TODO:- 上手いエラーハンドリングを考える。
            return Data()
        }
        return encoded
    }
    
    public static func readAsData(uid: String) -> Data {
        let model = read(id: uid)
        guard let encoded = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false) else {
            // TODO:- 上手いエラーハンドリングを考える。
            return Data()
        }
        
        return encoded
    }
    
    public static func set(archives: [ArchiveModel]) {
        let realm = try! Realm()
        let model = read(id: archives.first!.userId)
        
        archives.forEach {
            $0.id = NSUUID().uuidString
        }
        
        try! realm.write {
            if !model.isEmpty {
                realm.delete(model)
            }
            realm.add(archives)
        }
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.userId, forKey: "userId")
        aCoder.encode(self.animeId, forKey: "animeId")
        aCoder.encode(self.animeStatus, forKey: "animeStatus")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.udatedAt, forKey: "udatedAt")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        self.userId = aDecoder.decodeObject(forKey: "userId") as! String
        self.animeId = aDecoder.decodeObject(forKey: "animeId") as! String
        self.animeStatus = aDecoder.decodeObject(forKey: "animeStatus") as! String
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as! String
        self.udatedAt = aDecoder.decodeObject(forKey: "udatedAt") as! String
    }
    
    required init() {
        super.init()
        self.id = ""
        self.userId = ""
        self.animeId = ""
        self.animeStatus = ""
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
