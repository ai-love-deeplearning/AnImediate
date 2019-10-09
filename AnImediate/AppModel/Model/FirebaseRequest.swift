//
//  FirebaseRequest.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/03.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import Foundation
import Firebase
import RxSwift
import RxCocoa
import RealmSwift

public protocol FirebaseRequestable {
    func fetchCurrentTermAnime(term: String) -> Single<[AnimeModel]>
    func fetchRankingAnime(term: String) -> Single<[AnimeModel]>
    func getData()
}

public class FirebaseRequest: NSObject, FirebaseRequestable {
    let realm = try! Realm()
    let realmPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/anime.realm"
    
    var ref: DatabaseReference!
    
    override public init() {
        super.init()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
    }

    public func fetchCurrentTermAnime(term: String) -> Single<[AnimeModel]> {
        return Single.create { singleEvent in
            
            let disposable = Disposables.create()
            
            self.ref = Database.database().reference()

            self.ref.child(FirebaseTables.works)
                .queryOrdered(byChild: FirebaseWorks.seasonNameText)
                .queryEqual(toValue: term)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let info = snapshot.value as? [String: Any] else {
                        // TODO:- Errorの内容を設定
                        singleEvent(.error(AnimediateError.unknown))
                        return
                    }
                    // TODO:- キャストをList<String>に変換する処理
                    let values = info.compactMap { info[$0.key] as? [String: Any] }
                    let animes = values.map { (value: [String: Any]) -> AnimeModel in
                        return AnimeModel(value: value)
                    }
                    singleEvent(.success(animes))
                })
            return disposable
        }
    }
    
    // TODO:- ランキング用のクエリを設定
    public func fetchRankingAnime(term: String) -> Single<[AnimeModel]> {
        return Single.create { singleEvent in
            let disposable = Disposables.create()
            
            self.ref = Database.database().reference()
            
            self.ref.child(FirebaseTables.works)
                .queryOrdered(byChild: FirebaseWorks.seasonNameText)
                .queryEqual(toValue: term)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let info = snapshot.value as? [Any] else {
                        // TODO:- Errorの内容を設定
                        singleEvent(.error(AnimediateError.unknown))
                        return
                    }
                    
                    let values = info.compactMap { (info) -> [String: Any]? in
                        return info as? [String: Any]
                    }
                    
                    let animes = values.map { (value: [String: Any]) -> AnimeModel in
                        return AnimeModel(value: value)
                    }
                    singleEvent(.success(animes))
                })
            return disposable
        }
    }
    
    public func getData() {
        ref = Database.database().reference()
        // アニメ作品情報を取得＆realmに登録
        ref.child(FirebaseTables.works).observe(.value, with: { (snapshot) in
            guard let info = snapshot.value as? [Any] else {return}
            
            let values = info.compactMap { (info) -> [String: Any]? in
                return info as? [String: Any]
            }
            
            let works = values.map { (value: [String: Any]) -> AnimeModel in
                return AnimeModel(value: value)
            }
            
            // TODO:- firebaseから持ってくるのよりここが重い
            // TODO:- Rx化して差分更新したい
//            for i in 0..<works.count {
//                try! self.realm.write {
//                    self.realm.add(works[i])
//                }
//            }
            try! self.realm.write {
                self.realm.add(works, update: .all)
            }
            print(works.count)
            print("100% Complete AnimeModels")
            
        }) { (error) in
            print(error)
        }
        
        // アニメのエピソード情報を取得＆realmに登録
        ref.child(FirebaseTables.episodes).observe(.value, with: { (snapshot) in
            guard let info = snapshot.value as? [Any] else {return}
            
            let values = info.compactMap { (info) -> [String: Any]? in
                return info as? [String: Any]
            }
            
            let episodes = values.map { (value: [String: Any]) -> AnimeEpisodeModel in
                return AnimeEpisodeModel(value: value)
            }
            
            try! self.realm.write {
                self.realm.add(episodes, update: .all)
            }
                
//            for i in 0..<episodes.count {
//                try! self.realm.write {
//                    self.realm.add(episodes[i])
//                }
//            }
            print(episodes.count)
            print("100% CompleteAnimeModels Episodes")
            
        }) { (error) in
            print(error)
        }
        
        try! Realm().writeCopy(toFile: URL(string: realmPath)!, encryptionKey: Data(base64Encoded: "anime"))
    }
}
