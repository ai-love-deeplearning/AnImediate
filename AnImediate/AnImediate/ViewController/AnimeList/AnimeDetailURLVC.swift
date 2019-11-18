//
//  AnimeDetailURLVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/11/19.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import ReSwift
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift

class AnimeDetailURLVC: UIViewController {

    @IBOutlet weak var wikiUrlBtn: UIButton!
    @IBOutlet weak var officialUrlBtn: UIButton!
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.animeListStore)
    
    private var viewState: AnimeDetailURLViewState {
        return store.state.detailURLViewState
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disposeBag = DisposeBag()
        bindState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func bindState() {
        if viewState.animeModel != nil {
            wikiUrlBtn.setTitle(viewState.animeModel!.wikipediaUrl, for: .normal)
            officialUrlBtn.setTitle(viewState.animeModel!.officialSiteUrl, for: .normal)
        }
                
        store.animeModel
            .drive(
                onNext: { [unowned self] anime in
                    self.wikiUrlBtn.setTitle(self.viewState.animeModel!.wikipediaUrl, for: .normal)
                    self.officialUrlBtn.setTitle(self.viewState.animeModel!.officialSiteUrl, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}

private extension RxStore where AnyStateType == AnimeListViewState {
    var state: Driver<AnimeDetailURLViewState> {
        return stateDriver.mapDistinct { $0.detailURLViewState }
    }
    
    var animeModel: Driver<AnimeModel> {
        return state.mapDistinct { $0.animeModel }.skipNil()
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
