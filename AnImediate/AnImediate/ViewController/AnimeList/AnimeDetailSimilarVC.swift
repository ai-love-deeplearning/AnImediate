//
//  AnimeDetailSimilarVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/11/18.
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

class AnimeDetailSimilarVC: UIViewController {

    @IBOutlet weak var animeList: UITableView!
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.animeListStore)
    
    private var viewState: AnimeDetailSimilarViewState {
        return store.state.detailSimilarViewState
    }
    
    private var dataSource: RxTableViewSectionedReloadDataSource<AnimeTableSectionModel>!
    private var sectionModels: [AnimeTableSectionModel]!
    private var dataRelay = BehaviorRelay<[AnimeTableSectionModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        initSectionModels()
        initTable()
        bindViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func bindViews() {
        
        dataRelay.asObservable()
            .bind(to: animeList.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // TODO:- アイテムの削除を無効化したい
        animeList.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self, let sectionModel = strongSelf.sectionModels.first else { return }
                var items = sectionModel.items
                items.remove(at: indexPath.row)
                
                strongSelf.sectionModels = [AnimeTableSectionModel(items: items)]
                // dataRelayにデータを流し込む
                strongSelf.dataRelay.accept(strongSelf.sectionModels)
            })
            .disposed(by: disposeBag)
        
        animeList.rx.itemSelected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    let model = (self.animeList.cellForRow(at: indexPath) as! AnimeListTableViewCell).anime
                    self.store.dispatch(AnimeDetailInfoViewAction.Initialize(animeModel: model!))
                    self.store.dispatch(AnimeDetailEpisodeViewAction.Initialize(animeModel: model!))
                    self.store.dispatch(AnimeDetailURLViewAction.Initialize(animeModel: model!))
                    self.performSegue(withIdentifier: "toDetails", sender: nil)
                    self.animeList.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
        
        animeList.rx.itemDeselected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    
            })
            .disposed(by: disposeBag)
    }
}

extension AnimeDetailSimilarVC {
    private func initSectionModels() {
        var items: [AnimeModel] = []
        
        items = Array(AnimeModel.readAllRanking())
        
        sectionModels = [AnimeTableSectionModel(items: items)]
        fetch()
    }
    
    private func initTable() {
        
        animeList.tableFooterView = UIView(frame: .zero)
        
        dataSource = RxTableViewSectionedReloadDataSource<AnimeTableSectionModel>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnimeTableCell", for: IndexPath(row: indexPath.row, section: 0)) as! AnimeListTableViewCell
                
                // TODO:- setメソッドに変更
                cell.anime = item
                
                return cell
                
        }, canEditRowAtIndexPath: { _, _ in
            return true
        })
    }
    
    private func fetch() {
        Observable.just(sectionModels)
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.dataRelay.accept(strongSelf.sectionModels)
            })
            .disposed(by: disposeBag)
    }
}

private extension RxStore where AnyStateType == AnimeListViewState {
    var state: Driver<AnimeDetailSimilarViewState> {
        return stateDriver.mapDistinct { $0.detailSimilarViewState }
    }
    
    var animeModel: Driver<AnimeModel> {
        return state.mapDistinct { $0.animeModel }.skipNil()
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
