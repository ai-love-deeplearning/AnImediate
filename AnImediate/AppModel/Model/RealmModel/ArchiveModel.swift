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
    @objc public dynamic var userID = ""
    @objc public dynamic var annictID = ""
    @objc public dynamic var animeStatus = ""
    @objc dynamic var createdAt = ""
    @objc public dynamic var udatedAt = ""
    
    override public static func primaryKey() -> String {
        return "id"
    }
    
    public static func read(id: String) -> Results<ArchiveModel>{
        let realm = try! Realm()
        return realm.objects(self).filter("userId == %@", id)
    }
    
    public static func readAsData(id: String) -> Data? {
        let model = read(id: id)
        guard let encoded = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false) else {
            // TODO:- 上手いエラーハンドリングを考える。
            return nil
        }
        return encoded
    }
    
    // TODO:- Dataとして読めるのは自分のデータだけ
    public static func readAsData(uid: String) -> Data? {
        let model = read(id: uid)
        guard let encoded = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false) else {
            // TODO:- 上手いエラーハンドリングを考える。
            return nil
        }
        
        return encoded
    }
    
    public static func set(archives: [ArchiveModel]) {
        let realm = try! Realm()
        let model = read(id: archives.first!.userID)
        
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
        aCoder.encode(self.userID, forKey: "userId")
        aCoder.encode(self.annictID, forKey: "annictID")
        aCoder.encode(self.animeStatus, forKey: "animeStatus")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.udatedAt, forKey: "udatedAt")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        self.userID = aDecoder.decodeObject(forKey: "userId") as! String
        self.annictID = aDecoder.decodeObject(forKey: "annictID") as! String
        self.animeStatus = aDecoder.decodeObject(forKey: "animeStatus") as! String
        self.createdAt = aDecoder.decodeObject(forKey: "createdAt") as! String
        self.udatedAt = aDecoder.decodeObject(forKey: "udatedAt") as! String
    }
    
    required init() {
        super.init()
        self.id = ""
        self.userID = ""
        self.annictID = ""
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
