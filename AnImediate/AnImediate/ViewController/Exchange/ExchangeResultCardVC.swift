//
//  ExchangeResultCardVC.swift
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

class ExchangeResultCardVC: UIViewController {

    @IBOutlet private weak var cardTable: UITableView!
    @IBOutlet private weak var implementingView: UIView!
    @IBOutlet private weak var emptyView: UIView!
    
//    let realm = try! Realm()
    
//    public var works: [AnimeModel] = []
    
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
            .bind(to: cardTable.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // TODO:- アイテムの削除を無効化したい
        cardTable.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self, let sectionModel = strongSelf.sectionModels.first else { return }
                var items = sectionModel.items
                items.remove(at: indexPath.row)
                
                strongSelf.sectionModels = [AnimeTableSectionModel(items: items)]
                // dataRelayにデータを流し込む
                strongSelf.dataRelay.accept(strongSelf.sectionModels)
            })
            .disposed(by: disposeBag)
        
        cardTable.rx.itemSelected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    let cell = self.cardTable.cellForRow(at: indexPath) as! AnimeListTableViewCell
                    // TODO:- 詳細への画面遷移
                    if self.viewState.isRegisterMode == false {
                        self.cardTable.deselectRow(at: indexPath, animated: false)
                    }
            })
            .disposed(by: disposeBag)
        
        cardTable.rx.itemDeselected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    
            })
            .disposed(by: disposeBag)
        
        // TODO:- ここで登録できるようなUIを作る
    }
    
    private func bindState() {
        store.isRegisterMode
            .drive(
                onNext: { [unowned self] isRegisterMode in
//                    self.floatingView.isHidden = !isRegisterMode
//                    self.registerModeBtn.title = isRegisterMode ? "キャンセル" : "登録"
//                    self.registerModeBtn.tintColor = isRegisterMode ? .lightGray : .deepMagenta()
                    // 複数選択可にする
                    self.cardTable.allowsMultipleSelectionDuringEditing = isRegisterMode
                    self.cardTable.isEditing = isRegisterMode
                    self.cardTable.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
        }
    }
}

extension ExchangeResultCardVC {
    private func initSectionModels() {
        var items: [AnimeModel] = []
        
        switch viewState.contentType {
        case .currentTerm:
            items = Array(AnimeModel.readCurrentTerm())
        case .ranking:
            items = Array(AnimeModel.readAllRanking())
        case .similar:
            // TODO:- 似ている作品取得メソッドを実装
            items = Array(AnimeModel.readAllRanking())
        case .broadcast:
            // TODO:- 放送年取得メソッドを実装
            items = Array(AnimeModel.readAllRanking())
        }
        
        sectionModels = [AnimeTableSectionModel(items: items)]
        fetch()
    }
    
    private func initTable() {
        
        cardTable.tableFooterView = UIView(frame: .zero)
        
        dataSource = RxTableViewSectionedReloadDataSource<AnimeTableSectionModel>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnimeTableCell", for: IndexPath(row: indexPath.row, section: 0)) as! AnimeListTableViewCell
                
                cell.anime = item
                
                return cell
        }, canEditRowAtIndexPath: { _, _ in
            return true
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
    
    var isRegisterMode: Driver<Bool> {
        return state.mapDistinct { $0.isRegisterMode }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
