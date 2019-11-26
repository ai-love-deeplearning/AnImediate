//
//  PeerModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/26.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//
import AppConfig
import Foundation
import Realm
import RealmSwift

public class PeerModel : Object, NSCoding, NSCopying {
    
    @objc private dynamic var id = ""
    @objc public dynamic var userID = ""
    @objc public dynamic var name = ""
    @objc public dynamic var comment = ""
    @objc public dynamic var excangedAt = ""
    @objc dynamic var _icon: UIImage? = nil
    @objc public dynamic var icon: UIImage? {
        set{
            self._icon = newValue
            if let value = newValue {
                self.iconData = value.pngData() as NSData?
            }
        }
        get{
            if let image = self._icon {
                return image
            }
            if let data = self.iconData {
                self._icon = UIImage(data: data as Data)
                return self._icon
            }
            return nil
        }
    }
    @objc dynamic var iconData: NSData? = nil
    
    @objc dynamic var _background: UIImage? = nil
    @objc public dynamic var background: UIImage? {
        set{
            self._background = newValue
            if let value = newValue {
                self.backData = value.pngData() as NSData?
            }
        }
        get{
            if let image = self._background {
                return image
            }
            if let data = self.backData {
                self._background = UIImage(data: data as Data)
                return self._background
            }
            return nil
        }
    }
    @objc dynamic var backData: NSData? = nil
    
    // idをプライマリキーに設定
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public static func read(id: String) -> Results<PeerModel> {
        let realm = try! Realm()
        let model = realm.objects(self).filter("userID == %@", id)
        
        return model
    }
    
    public static func readAll() -> Results<PeerModel> {
        let realm = try! Realm()
        return realm.objects(self)
    }
    
    public static func set(uid: String, name: String) {
        let realm = try! Realm()
        
        guard let model = read(id: uid).first else { return }
        try! realm.write {
            model.name = name
        }
    }
    
    public static func set(uid: String, comment: String) {
        let realm = try! Realm()
        
        guard let model = read(id: uid).first else { return }
        try! realm.write {
            model.comment = comment
        }
    }
    
    public static func set(uid: String, excangedAt: String) {
        let realm = try! Realm()
        
        guard let model = read(id: uid).first else { return }
        try! realm.write {
            model.excangedAt = excangedAt
        }
    }
    
    // TODO:- UIImage -> Data の変換をここら辺でできないか検討
    public static func set(uid: String, icon: UIImage) {
        let realm = try! Realm()
        
        guard let model = read(id: uid).first else { return }
        try! realm.write {
            model.icon = icon
        }
        //self.iconData = icon.pngData() as NSData?
    }
    
    public static func set(data: AccountModel) {
        let realm = try! Realm()
        let model: PeerModel
        if read(id: data.userID).first == nil {
            model = PeerModel()
        } else {
            model = read(id: data.userID).first!
        }
        
        try! realm.write {
            model.userID = data.userID
            model.name = data.name
            model.comment = data.comment
            model.icon = data.icon
            model.excangedAt = AnimediateConfig.dateString
            realm.add(model, update: .modified)
        }
    }
    
    public static func delete(uid: String) {
        let realm = try! Realm()
        guard let model = read(id: uid).first else { return }
        try! realm.write {
            realm.delete(model)
        }
    }
    
    override public static func ignoredProperties() -> [String] {
        return ["icon", "_icon", "background", "_background"]
    }
    
    // TODO:- readがあるからcopyいらないのではないか要検討
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = PeerModel()
        copy.id = id
        copy.userID = userID
        copy.name = name
        copy.comment = comment
        copy.excangedAt = excangedAt
        copy.iconData = iconData
        
        return copy
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.userID, forKey: "userID")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.comment, forKey: "comment")
        aCoder.encode(self.excangedAt, forKey: "excangedAt")
        aCoder.encode(self.iconData, forKey: "icon")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.userID = aDecoder.decodeObject(forKey: "userID") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.comment = aDecoder.decodeObject(forKey: "comment") as! String
        self.excangedAt = aDecoder.decodeObject(forKey: "excangedAt") as! String
        self.iconData = (aDecoder.decodeObject(forKey: "icon") as! NSData)
        
    }
    
    required init() {
        super.init()
        self.id = NSUUID().uuidString
        self.userID = ""
        self.name = ""
        self.comment = ""
        self.excangedAt = ""
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
}
