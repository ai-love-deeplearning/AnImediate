//
//  DataManager.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/03.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import Firebase
import FirebaseAuth
import RealmSwift

class DataManager: NSObject {
    let realm = try! Realm()
    let realmPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/anime.realm"
    
    var ref: DatabaseReference!
    
    public func getData() {
        ref = Database.database().reference()
        
        // アニメ作品情報を取得＆realmに登録
        ref.child("works").observe(.value, with: { (snapshot) in
            guard let info = snapshot.value as? [Any] else {return}
            
            let value = info.compactMap { (info) -> [String: Any]? in
                return info as? [String: Any]
            }
            
            let work = value.map { (value: [String: Any]) -> AnimeModel in
                return AnimeModel(value: value)
            }
            
            for i in 0..<work.count {
                try! self.realm.write {
                    self.realm.add(work[i])
                }
            }
            print(work.count)
            print("100% Complete AnimeModels")
            
        }) { (error) in
            print(error)
        }
        
        // アニメのエピソード情報を取得＆realmに登録
        ref.child("episodes").observe(.value, with: { (snapshot) in
            guard let info = snapshot.value as? [Any] else {return}
            
            let value = info.compactMap { (info) -> [String: Any]? in
                return info as? [String: Any]
            }
            
            let episode = value.map { (value: [String: Any]) -> Episode in
                return Episode(value: value)
            }
                
            for i in 0..<episode.count {
                try! self.realm.write {
                    self.realm.add(episode[i])
                }
            }
            print(episode.count)
            print("100% CompleteAnimeModels Episodes")
            
        }) { (error) in
            print(error)
        }
        
        try! Realm().writeCopy(toFile: URL(string: realmPath)!, encryptionKey: Data(base64Encoded: "anime"))
    }
}
