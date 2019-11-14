//
//  LaunchViewActionCreator.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/09.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import Foundation
import ReSwift
import RxSwift

public protocol LaunchViewActionCreatable {
    func startFetchingAnime(disposeBag: DisposeBag) -> Store<AppState>.AsyncActionCreator
    func startFetchingEpisode(disposeBag: DisposeBag) -> Store<AppState>.AsyncActionCreator
}

public class LaunchViewActionCreator: LaunchViewActionCreatable {
    
    private let request: FirebaseRequestable
    
    public init(request: FirebaseRequestable) {
        self.request = request
    }
    
    public func startFetchingAnime(disposeBag: DisposeBag) -> Store<AppState>.AsyncActionCreator {
        return { [weak self] state, store, callback in
            callback { _, _ in LaunchViewAction.FetchAllAnimeSuccess() }
            
            self?.request.fetchAllAnime()
                .subscribe(
                    onSuccess: { data in
                        CommonStateModel.set(isAnimeFetched: true)
                        let action = LaunchViewAction.FetchAllAnimeCompleted()
                        callback { _, _ in action }
                },
                    onError: { error in
                        print(error.localizedDescription)
                        print("エラー: 今期アニメの取得に失敗しました")
                })
                .disposed(by: disposeBag)
            
        }
    }
    
    public func startFetchingEpisode(disposeBag: DisposeBag) -> Store<AppState>.AsyncActionCreator {
        return { [weak self] state, store, callback in
            callback { _, _ in LaunchViewAction.FetchAllEpisodeSuccess() }
            
            self?.request.fetchAllEpisodes()
                .subscribe(
                    onSuccess: { data in
                        CommonStateModel.set(isEpisodeFetched: true)
                        let action = LaunchViewAction.FetchAllEpisodeCompleted()
                        callback { _, _ in action }
                },
                    onError: { error in
                        print(error.localizedDescription)
                        print("エラー: 今期アニメの取得に失敗しました")
                })
                .disposed(by: disposeBag)
            
        }
    }
    
}
