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
}
