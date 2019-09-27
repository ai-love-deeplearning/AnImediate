//
//  PeerModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/26.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public class PeerModel : Object, NSCoding, NSCopying {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var comment = ""
    @objc dynamic var excangedAt = ""
    @objc dynamic var _icon: UIImage? = nil
    @objc dynamic var icon: UIImage? {
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
    @objc dynamic var background: UIImage? {
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
    
    public static func read(id: String) -> PeerModel {
        let realm = try! Realm()
        if let model = realm.object(ofType: self, forPrimaryKey: id) {
            return model
        }
        
        let model = PeerModel()
        try! realm.write {
            realm.add(model)
        }
        return model
    }
    
    public static func readAsData(uid: String) -> Data {
        
        let model = read(id: uid)
        guard let encoded = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false) else {
            // TODO:- 上手いエラーハンドリングを考える。
            return Data()
        }
        
        return encoded
    }
    
    public static func set(uid: String, name: String) {
        let realm = try! Realm()
        
        let model = read(id: uid)
        try! realm.write {
            model.name = name
        }
    }
    
    public static func set(uid: String, comment: String) {
        let realm = try! Realm()
        
        let model = read(id: uid)
        try! realm.write {
            model.comment = comment
        }
    }
    
    public static func set(uid: String, excangedAt: String) {
        let realm = try! Realm()
        
        let model = read(id: uid)
        try! realm.write {
            model.excangedAt = excangedAt
        }
    }
    
    // TODO:- UIImage -> Data の変換をここら辺でできないか検討
    public static func set(uid: String, icon: UIImage) {
        let realm = try! Realm()
        
        let model = read(id: uid)
        try! realm.write {
            model.icon = icon
        }
        //self.iconData = icon.pngData() as NSData?
    }
    
    public static func set(uid: String, background: UIImage) {
        let realm = try! Realm()
        
        let model = read(id: uid)
        try! realm.write {
            model.background = background
        }
    }
    
    public static func set(uid: String, data: PeerModel) {
        let realm = try! Realm()
        
        let model = read(id: uid)
        try! realm.write {
            model.name = data.name
            model.comment = data.comment
            model.icon = data.icon
            model.background = data.background
            model.excangedAt = data.excangedAt
        }
    }
    
    override public static func ignoredProperties() -> [String] {
        return ["icon", "_icon", "background", "_background"]
    }
    
    // TODO:- readがあるからcopyいらないのではないか要検討
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = PeerModel()
        copy.id = id
        copy.name = name
        copy.comment = comment
        copy.excangedAt = excangedAt
        copy.iconData = iconData
        copy.backData = backData
        
        return copy
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.comment, forKey: "comment")
        aCoder.encode(self.excangedAt, forKey: "excangedAt")
        aCoder.encode(self.iconData, forKey: "icon")
        aCoder.encode(self.backData, forKey: "back")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.comment = aDecoder.decodeObject(forKey: "comment") as! String
        self.excangedAt = aDecoder.decodeObject(forKey: "excangedAt") as! String
        self.iconData = (aDecoder.decodeObject(forKey: "icon") as! NSData)
        self.backData = (aDecoder.decodeObject(forKey: "back") as! NSData)
        
    }
    
    required init() {
        super.init()
        self.id = ""
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