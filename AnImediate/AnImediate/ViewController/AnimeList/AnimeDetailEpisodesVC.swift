//
//  AnimeDetailEpisodesVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/19.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import ReSwift
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift

class AnimeDetailEpisodesVC: UIViewController {

    @IBOutlet weak var episodeTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.animeListStore)
    
    private var viewState: AnimeDetailEpisodeViewState {
        return store.state.detailEpisodeViewState
    }
    
    private var episodeDataSource: RxTableViewSectionedReloadDataSource<AnimeEpisodeTableSectionModel>!
    private var episodeSectionModels: [AnimeEpisodeTableSectionModel]!
    private var episodeDataRelay = BehaviorRelay<[AnimeEpisodeTableSectionModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disposeBag = DisposeBag()
        initSectionModels()
        initTable()
        bindViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func bindViews() {
        episodeDataRelay.asObservable()
            .bind(to: episodeTableView.rx.items(dataSource: episodeDataSource))
            .disposed(by: disposeBag)
    }
    
}

extension AnimeDetailEpisodesVC {
    private func initSectionModels() {
        let animeID = viewState.animeModel?.annictID
        let items = Array(AnimeEpisodeModel.read(annictID: animeID!))
        
        emptyView.isHidden = !items.isEmpty
        
        episodeSectionModels = [AnimeEpisodeTableSectionModel(items: items)]
        
        Observable.just(episodeSectionModels)
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.episodeDataRelay.accept(strongSelf.episodeSectionModels)
            })
            .disposed(by: disposeBag)
    }

    private func initTable() {
        
        episodeTableView.tableFooterView = UIView(frame: .zero)
        episodeTableView.allowsSelection = false
        
        episodeDataSource = RxTableViewSectionedReloadDataSource<AnimeEpisodeTableSectionModel>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: IndexPath(row: indexPath.row, section: 0))
                
                cell.textLabel?.text = item.numberText + "：" + item.episodeTitle
                
                return cell
        }, canEditRowAtIndexPath: { _, _ in
            return true
        })
    }

}

private extension RxStore where AnyStateType == AnimeListViewState {
    var state: Driver<AnimeDetailEpisodeViewState> {
        return stateDriver.mapDistinct { $0.detailEpisodeViewState }
    }
    
    var animeModel: Driver<AnimeModel> {
        return state.mapDistinct { $0.animeModel }.skipNil()
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
