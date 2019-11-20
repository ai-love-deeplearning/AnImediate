//
//  AccountModel.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/01.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public class AccountModel : Object, NSCoding, NSCopying {
    
    @objc dynamic var id = "0"
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
    
    public static func read() -> AccountModel {
        let realm = try! Realm()
        if let model = realm.object(ofType: self, forPrimaryKey: "0") {
            return model
        }
        
        let model = AccountModel()
        try! realm.write {
            realm.add(model)
        }
        return model
    }
    
    public static func readAsData() -> Data {
        
        let model = read()
        guard let encoded = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false) else {
            // TODO:- 上手いエラーハンドリングを考える。
            return Data()
        }
        
        return encoded
    }
    
    public static func set(uid: String) {
        let realm = try! Realm()
        
        let model = read()
        try! realm.write {
            model.userID = uid
        }
    }
    
    public static func set(name: String) {
        let realm = try! Realm()
        
        let model = read()
        try! realm.write {
            model.name = name
        }
    }
    
    public static func set(comment: String) {
        let realm = try! Realm()
        
        let model = read()
        try! realm.write {
            model.comment = comment
        }
    }
    
    public static func set(excangedAt: String) {
        let realm = try! Realm()
        
        let model = read()
        try! realm.write {
            model.excangedAt = excangedAt
        }
    }
    
    // TODO:- UIImage -> Data の変換をここら辺でできないか検討
    public static func set(icon: UIImage) {
        let realm = try! Realm()
        
        let model = read()
        try! realm.write {
            model.icon = icon
        }
        //self.iconData = icon.pngData() as NSData?
    }
    
    public static func set(background: UIImage) {
        let realm = try! Realm()
        
        let model = read()
        try! realm.write {
            model.background = background
        }
    }
    
    public static func set(data: AccountModel) {
        let realm = try! Realm()
        
        let model = read()
        try! realm.write {
            model.userID = data.userID
            model.name = data.name
            model.comment = data.comment
            model.icon = data.icon
            model.excangedAt = data.excangedAt
        }
    }
    /*
    public static func set(uid: String, data: Data) {
        let realm = try! Realm()
        if let decoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? AccountModel {
            set(uid: decoded.id, data: decoded)
        } else if let decoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [ArchiveModel] {
            //self.isRecieveWatch = true
            // クエリによるデータの取得
            let model = read(id: decoded.first.userId)
            try! realm.write {
                model.background = background
            }
            
            let results = realm.objects(ArchiveModel.self).filter("userId == %@", decoded[0].userId)
            
            if results.isEmpty {
                decoded.forEach {
                    $0.id = NSUUID().uuidString
                }
                
                try! realm.write {
                    realm.add(decoded)
                }
            } else {
                decoded.forEach {
                    $0.id = NSUUID().uuidString
                }
                // データの更新
                try! realm.write {
                    realm.delete(results)
                    realm.add(decoded)
                }
            }
        } else {
            // TODO:- 予期せぬデータが送られてきたときのエラーハンドリング
            fatalError()
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toPopUpModal", sender: nil)
        }
    }*/
    
    override public static func ignoredProperties() -> [String] {
        return ["icon", "_icon", "background", "_background"]
    }
    
    // TODO:- readがあるからcopyいらないのではないか要検討
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = AccountModel()
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
        self.id = "0"
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
