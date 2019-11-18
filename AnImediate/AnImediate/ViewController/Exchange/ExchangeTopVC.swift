//
//  ExchangeTopVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppModel
import UIKit
import ReSwift
import RxCocoa
import RxSwift
import RxDataSources
import RealmSwift
import MXParallaxHeader

class ExchangeTopVC: UIViewController {


    @IBOutlet weak var peerTable: UITableView!
    @IBOutlet weak var emptyView: UIView!
    //    @IBOutlet weak var peerCollectionView: AnimeHorizontalCollectionView!
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.exchangeStore)
    
    private var viewState: ExchangeTopViewState {
        return store.state.topViewState
    }
    
    private var dataSource: RxTableViewSectionedReloadDataSource<ExchangeTopTableSectionModel>!
    private var sectionModels: [ExchangeTopTableSectionModel]!
    private var dataRelay = BehaviorRelay<[ExchangeTopTableSectionModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peerTable.estimatedRowHeight = 88
        peerTable.rowHeight = UITableView.automaticDimension
        
        // TODO:- PeerModelを検索して交換済みユーザーがいるかいないかをviewStateに反映
        
//        if !self.resultUserInfo.isEmpty {
//            UserDefaults.standard.set(self.resultUserInfo[0].id, forKey: "userID")
//        }
//        UserDefaults.standard.set(0, forKey: "userNum")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emptyView.isHidden = PeerModel.readAll().isNotEmpty
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
            .bind(to: peerTable.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
        peerTable.rx.itemSelected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    let cell = self.peerTable.cellForRow(at: indexPath) as! ExchangeTopTableViewCell
                    
                    // TODO:- 次の画面へ値を渡す処理
//                    self.performSegue(withIdentifier: "toDetails", sender: nil)

            })
            .disposed(by: disposeBag)
        
        peerTable.rx.itemDeselected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    
            })
            .disposed(by: disposeBag)
        
    }
    
}

extension ExchangeTopVC {
    
    private func initSectionModels() {
        var items: [PeerModel] = []
        items = Array(PeerModel.readAll())
        
        sectionModels = [ExchangeTopTableSectionModel(items: items)]
        fetch()
    }
    
    private func initTable() {
        
        peerTable.tableFooterView = UIView(frame: .zero)
        
        dataSource = RxTableViewSectionedReloadDataSource<ExchangeTopTableSectionModel>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "PeerTableCell", for: IndexPath(row: indexPath.row, section: 0)) as! ExchangeTopTableViewCell
                
                // TODO:- setメソッドに変更
                cell.setData(peer: item)
                
                return cell
                
        }, canEditRowAtIndexPath: { _, _ in
            return false
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

private extension RxStore where AnyStateType == ExchangeViewState {
    var state: Driver<ExchangeTopViewState> {
        return stateDriver.mapDistinct { $0.topViewState }
    }
    
    var isExchanged: Driver<Bool> {
        return state.mapDistinct { $0.isExchanged }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
