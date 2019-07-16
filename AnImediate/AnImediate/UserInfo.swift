//
//  UserInfo.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/01.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class UserInfo : Object, NSCoding {
    
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
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["icon", "_icon", "background", "_background"]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.comment, forKey: "comment")
        aCoder.encode(self.excangedAt, forKey: "excangedAt")
        aCoder.encode(self.iconData, forKey: "icon")
        aCoder.encode(self.backData, forKey: "back")
    }
    
    required init?(coder aDecoder: NSCoder) {
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
