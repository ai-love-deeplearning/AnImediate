// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AppConfig
import Foundation
import Firebase
import FirebaseAuth
import ReSwift
import RxSwift

public protocol AnimeListTopViewActionCreatable {
    func getCurrentTerm(disposeBag: DisposeBag) -> Store<AnimeListViewState>.AsyncActionCreator
    func getRanking(disposeBag: DisposeBag) -> Store<AnimeListViewState>.AsyncActionCreator
}

public class AnimeListTopViewActionCreator: AnimeListTopViewActionCreatable {

        private let request: FirebaseRequestable

        public init(request: FirebaseRequestable) {
            self.request = request
        }

    public func getCurrentTerm(disposeBag: DisposeBag) -> Store<AnimeListViewState>.AsyncActionCreator {

        return { [weak self] state, store, callback in
            callback { _, _ in AnimeListTopViewAction.CurrentTermRequestComplete() }
            self?.request.fetchCurrentTermAnime(term: AnimediateConfig.CurrentTerm)
                .subscribe(
                    onSuccess: { data in
                        AnimeModel.set(models: data)
                        let action = AnimeListTopViewAction.CurrentTermRequestSuccess(currentTerm: data)
                            callback { _, _ in action }
                    },
                        onError: { error in
                            print(error.localizedDescription)
                            print("エラー: 今期アニメの取得に失敗しました")
                    })
                    .disposed(by: disposeBag)
        }
    }
    
    public func getRanking(disposeBag: DisposeBag) -> Store<AnimeListViewState>.AsyncActionCreator {
        
        return { [weak self] state, store, callback in
            callback { _, _ in AnimeListTopViewAction.RankingRequestComplete() }
            
            self?.request.fetchRankingAnime(term: AnimediateConfig.CurrentTerm)
                .subscribe(
                    onSuccess: { data in
                        AnimeModel.set(models: data)
                        let action = AnimeListTopViewAction.RankingRequestSuccess(ranking: data)
                        callback { _, _ in action }
                },
                    onError: { error in
                        print(error.localizedDescription)
                        print("エラー: ランキングの取得に失敗しました")
                })
                .disposed(by: disposeBag)
        }
    }

}
