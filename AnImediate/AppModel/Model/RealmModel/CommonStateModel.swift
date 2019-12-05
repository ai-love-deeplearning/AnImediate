//
//  CommonStateModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/30.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import RealmSwift
import RxSwift

public class CommonStateModel: Object {
    @objc dynamic var id = "0"
    @objc public dynamic var isRegistered = false
    @objc public dynamic var isAnimeFetched = false
    @objc public dynamic var isEpisodeFetched = false
    @objc public dynamic var isPredictionFetched = false
    @objc dynamic var createdAt = ""
    @objc public dynamic var udatedAt = ""
    
    override public static func primaryKey() -> String {
        return "id"
    }
    
    public static func read() -> CommonStateModel {
        let realm = try! Realm()
        if let model = realm.object(ofType: self, forPrimaryKey: "0") {
            return model
        }
        
        let model = CommonStateModel()
        try! realm.write {
            realm.add(model)
        }
        return model
    }
    
    public static func set(isRegistered: Bool) {
        let realm = try! Realm()
        
        let model = read()
        try! realm.write {
            model.isRegistered = isRegistered
        }
    }
    
    public static func set(isAnimeFetched: Bool) {
        let realm = try! Realm()
        
        let model = read()
        try! realm.write {
            model.isAnimeFetched = isAnimeFetched
        }
    }
    
    public static func set(isEpisodeFetched: Bool) {
        let realm = try! Realm()
        
        let model = read()
        try! realm.write {
            model.isEpisodeFetched = isEpisodeFetched
        }
    }
    
    public static func set(isPredictionFetched: Bool) {
        let realm = try! Realm()
        
        let model = read()
        try! realm.write {
            model.isPredictionFetched = isPredictionFetched
        }
    }
    
}
