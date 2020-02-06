//
//  LaunchViewController.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/09.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import Realm
import RealmSwift
import RxSwift
import RxCocoa
import Firebase
import ReSwift

class LaunchViewController: UIViewController {
    
    private var transisionType =  "toLogin"
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.store)
    
    private var viewState: LaunchViewState {
        return store.state.launchViewState
    }
    
    private var LaunchViewActionCreator: LaunchViewActionCreatable! = nil {
        willSet {
            if LaunchViewActionCreator != nil {
                fatalError()
            }
        }
    }
    
    func inject(LaunchViewActionCreator: LaunchViewActionCreatable) {
        self.LaunchViewActionCreator = LaunchViewActionCreator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bind()
        
        // firebaseのログイン判定
//        if Auth.auth().currentUser != nil {
//            transisionType = "toMain"
//        }
        // 強制的にログイン処理をスキップ
        transisionType = "toMain"
        
        // CommonModelの値をViewStateに反映
        self.store.dispatch(LaunchViewAction.Initialize())
        
        transition()
//        performSegue(withIdentifier: transisionType, sender: nil)
        fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func bind() {
        store.isAnimeFetched
            .drive(
                onNext: { [unowned self] _ in
                    self.transition()
            })
            .disposed(by: disposeBag)
        
        store.isEpisodeFetched
            .drive(
                onNext: { [unowned self] _ in
                    self.transition()
            })
            .disposed(by: disposeBag)
        
        store.isPredictionFetched
            .drive(
                onNext: { [unowned self] _ in
                    self.transition()
            })
            .disposed(by: disposeBag)
    }
    
    private func transition() {
        if !CommonStateModel.read().isRegistered {
            if viewState.isAnimeFetched, viewState.isEpisodeFetched {
                performSegue(withIdentifier: transisionType, sender: nil)
            }
        }
        if viewState.isAnimeFetched, viewState.isEpisodeFetched, viewState.isPredictionFetched {
            performSegue(withIdentifier: transisionType, sender: nil)
        }
    }
    
    // TODO:- データ読み込み中はUIでProgressを出したり、何かしら表示したい
    private func fetch() {
        if !viewState.isAnimeFetched {
            self.store.dispatch(LaunchViewActionCreator.startFetchingAnime(disposeBag: disposeBag))
        }
        if !viewState.isEpisodeFetched {
            self.store.dispatch(LaunchViewActionCreator.startFetchingEpisode(disposeBag: disposeBag))
        }
        if !viewState.isPredictionFetched, CommonStateModel.read().isRegistered {
            self.store.dispatch(LaunchViewActionCreator.startFetchingPrediction(disposeBag: disposeBag))
        }
    }
    
}

private extension RxStore where AnyStateType == AppState {
    var state: Driver<LaunchViewState> {
        return stateDriver.mapDistinct { $0.launchViewState }
    }
    
    var isAnimeFetched: Driver<Bool> {
        return state.mapDistinct { $0.isAnimeFetched }
    }
    
    var isEpisodeFetched: Driver<Bool> {
        return state.mapDistinct { $0.isEpisodeFetched }
    }
    
    var isPredictionFetched: Driver<Bool> {
        return state.mapDistinct { $0.isPredictionFetched }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
