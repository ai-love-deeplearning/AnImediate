//
//  ExchangeResultTableVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import ReSwift
import RxCocoa
import RxSwift
import RxDataSources
import RealmSwift

class ExchangeResultTableVC: UIViewController {

    @IBOutlet private weak var archiveTable: UITableView!
    @IBOutlet private weak var emptyView: UIView!
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.exchangeStore)
    
    private var viewState: ExchangeResultViewState {
        return store.state.resultViewState
    }
    
    private var dataSource: RxTableViewSectionedReloadDataSource<AnimeTableSectionModel>!
    private var sectionModels: [AnimeTableSectionModel]!
    private var dataRelay = BehaviorRelay<[AnimeTableSectionModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initSectionModels()
        initTable()
        bindViews()
        bindState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func bindViews() {
        
        dataRelay.asObservable()
            .bind(to: archiveTable.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        archiveTable.rx.itemSelected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    let cell = self.archiveTable.cellForRow(at: indexPath) as! AnimeListTableViewCell
                    // TODO:- 詳細への画面遷移
                    self.archiveTable.deselectRow(at: indexPath, animated: false)
                    
            })
            .disposed(by: disposeBag)
        
        archiveTable.rx.itemDeselected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    
            })
            .disposed(by: disposeBag)
        
        // TODO:- ここで登録できるようなUIを作る
    }
    
    private func bindState() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
        }
    }
}

extension ExchangeResultTableVC {
    private func initSectionModels() {
        var items: [AnimeModel] = []
        items = Array(AnimeModel.readCurrentTerm())
        
        sectionModels = [AnimeTableSectionModel(items: items)]
        fetch()
    }
    
    private func initTable() {
        
        archiveTable.tableFooterView = UIView(frame: .zero)
        
        dataSource = RxTableViewSectionedReloadDataSource<AnimeTableSectionModel>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnimeTableCell", for: IndexPath(row: indexPath.row, section: 0)) as! AnimeListTableViewCell
                
                cell.anime = item
                
                return cell
        }, canEditRowAtIndexPath: { _, _ in
            return false
        })
    }
    
    // 初期表示用のデータフェッチする処理
    private func fetch() {
        Observable.just(sectionModels)
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.dataRelay.accept(strongSelf.sectionModels)
            })
            .disposed(by: disposeBag)
    }
}

private extension RxStore where AnyStateType == ExchangeViewState {
    var state: Driver<ExchangeResultViewState> {
        return stateDriver.mapDistinct { $0.resultViewState }
    }
    
    var peerID: Driver<String> {
        return state.mapDistinct { $0.peerID }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}