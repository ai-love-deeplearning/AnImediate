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
    func fetchAllAnime() -> Single<[AnimeModel]>
    func fetchAllEpisodes() -> Single<[AnimeEpisodeModel]>
    func fetchPredictions() -> Single<[Int]>
}

public class FirebaseRequest: NSObject, FirebaseRequestable {
//    let realm = try! Realm()
//    let realmPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/anime.realm"
    
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
    
    public func fetchAllAnime() -> Single<[AnimeModel]> {
        return Single.create { singleEvent in
            let disposable = Disposables.create()
            
            self.ref = Database.database().reference()
            
            self.ref.child(FirebaseTables.works).observe(.value, with: { (snapshot) in
                guard let info = snapshot.value as? [Any] else {return}
                
                let values = info.compactMap { (info) -> [String: Any]? in
                    return info as? [String: Any]
                }
                
                let anime = values.map { (value: [String: Any]) -> AnimeModel in
                    return AnimeModel(value: value)
                }
                
                AnimeModel.set(models: anime)
                
                singleEvent(.success(anime))
                print("100% Complete AnimeModels")
            
            }) { (error) in
                singleEvent(.error(AnimediateError.unknown))
            }
            return disposable
        }
    }
    
    public func fetchAllEpisodes() -> Single<[AnimeEpisodeModel]> {
        return Single.create { singleEvent in
            let disposable = Disposables.create()
            
            self.ref = Database.database().reference()
            
            // アニメのエピソード情報を取得＆realmに登録
            self.ref.child(FirebaseTables.episodes).observe(.value, with: { (snapshot) in
                guard let info = snapshot.value as? [Any] else {return}
                
                let values = info.compactMap { (info) -> [String: Any]? in
                    return info as? [String: Any]
                }
                
                let episodes = values.map { (value: [String: Any]) -> AnimeEpisodeModel in
                    return AnimeEpisodeModel(value: value)
                }
                
                AnimeEpisodeModel.set(models: episodes)
                
                singleEvent(.success(episodes))
                print("100% Complete Episodes")
                
            }) { (error) in
                singleEvent(.error(AnimediateError.unknown))
            }
            
            return disposable
        }
    }
    
    public func fetchPredictions() -> Single<[Int]> {
        return Single.create { singleEvent in
            let disposable = Disposables.create()
            
            self.ref = Database.database().reference()
            
            // 予測結果情報を取得＆realmに登録
            self.ref.child(FirebaseTables.predictions).observe(.value, with: { (snapshot) in
                guard let info = snapshot.value as? [Any] else {return}
                
                // indexに対応したanimeIDの予測評価
                let values = info.compactMap { (info) -> Int? in
                    return info as? Int
                }
                
                let uid = AccountModel.read().userID
                for (i, value) in values.enumerated() {
                    ArchiveModel.set(uid: uid, animeID: String(i+1), predictPoint: String(Float(value)))
                }
                
                singleEvent(.success(values))
                print("100% CompleteAnimeModels Predictions")
                
            }) { (error) in
                singleEvent(.error(AnimediateError.unknown))
            }
            
            return disposable
        }
    }
    
}
