//
//  DataManager.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/03.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import RealmSwift

class DataManager: NSObject {
    var ref: DatabaseReference!
    
    public func getWork() {
        ref = Database.database().reference()
        
        ref.child("works").observe(.value, with: { (snapshot) in
            guard let info = snapshot.value as? [Any] else {return}
            
            let value = info.compactMap { (info) -> [String: Any]? in
                return info as? [String: Any]
            }
            
            let work = value.map { (value: [String: Any]) -> Work in
                return Work(value: value)
            }
            
            DispatchQueue.global(qos: .background).async {
                let realm = try! Realm()
                
                for i in 0..<work.count {
                    print(work[i].title)
                    try! realm.write {
                        realm.add(work[i])
                    }
                }
                print(work.count)
            }
            
        }) { (error) in
            print(error)
        }
    }
}
