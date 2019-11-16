//
//  HomeArchiveListVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/01.
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
import Firebase
import FirebaseAuth

class HomeArchiveListVC: UIViewController {
    
    @IBOutlet private weak var archiveTable: UITableView!
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.homeStore)
    
    private var viewState: HomeArchiveListViewState {
        return store.state.homeArchiveListViewState
    }
    
    private var dataSource: RxTableViewSectionedReloadDataSource<HomeArchiveSectionModel>!
    private var sectionModels: [HomeArchiveSectionModel]!
    private var dataRelay = BehaviorRelay<[HomeArchiveSectionModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        disposeBag = DisposeBag()
        print("read viewWillAppear")
        initSectionModels()
        initTable()
        bindViews()
        bindState()
        fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        disposeBag = DisposeBag()
    }
    
    private func bindViews() {
        
        //archiveTable.register(ArchiveCardCell.self, forCellReuseIdentifier: "ArchiveCardCell")
        
//        archiveTable.rx
//            .setDelegate(self)
//            .disposed(by: disposeBag)
        
        dataRelay.asObservable()
            .bind(to: archiveTable.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // アイテム削除時
        archiveTable.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self, let sectionModel = strongSelf.sectionModels.first else { return }
                var items = sectionModel.items
                items.remove(at: indexPath.row)
                
                strongSelf.sectionModels = [HomeArchiveSectionModel(items: items)]
                // dataRelayにデータを流し込む
                strongSelf.dataRelay.accept(strongSelf.sectionModels)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState() {
        store.statusType
            .drive(
                onNext: { [unowned self] statusType in
                    // TODO:- TableViewのデータソースを切り返る処理
//                    self.initSectionModels()
//                    self.fetch()
            })
            .disposed(by: disposeBag)
        
        store.error
            .drive(
                onNext: { [unowned self] error in
                    // TODO:- エラーハンドリング
            })
            .disposed(by: disposeBag)
    }
    
}

extension HomeArchiveListVC {
    private func initSectionModels() {
//        let items = [
//            HomeArchiveModel(title: "ソードアート・オンライン", synopsis: "", season: "2014年春", image: UIImage(), registerCount: ""),
//            HomeArchiveModel(title: "", synopsis: "", season: "", image: UIImage(), registerCount: ""),
//            HomeArchiveModel(title: "", synopsis: "", season: "", image: UIImage(), registerCount: "")]
        // TODO:- ここでarchiveが0だとクラッシュ?
        let items = Array(ArchiveModel.read(uid: AccountModel.read().userID).filter("animeStatus == %@", self.viewState.statusType.rawValue))
//        let items = Array(ArchiveModel.read(uid: AccountModel.read().userID))
        sectionModels = [HomeArchiveSectionModel(items: items)]
    }
    
    private func initTable() {
        
        archiveTable.tableFooterView = UIView(frame: .zero)
        
        dataSource = RxTableViewSectionedReloadDataSource<HomeArchiveSectionModel>(
            configureCell: { _, tableView, indexPath, item in
                // 引数名通り、与えられたデータを利用してcellを生成する
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveCardCell", for: IndexPath(row: indexPath.row, section: 0)) as! ArchiveCardCell
                
                cell.setArchive(item)
                
                return cell
        }, canEditRowAtIndexPath: { _, _ in
            return true
        })
    }
    
    // 初期表示用のデータフェッチする処理
    private func fetch() {
        // sectionModelsを利用して
        Observable.just(sectionModels)
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                
                // dataRelayにデータを流し込む
                strongSelf.dataRelay.accept(strongSelf.sectionModels)
            })
            .disposed(by: disposeBag)
    }
}

private extension RxStore where AnyStateType == HomeViewState {
    var state: Driver<HomeArchiveListViewState> {
        return stateDriver.mapDistinct { $0.homeArchiveListViewState }
    }
    
    var statusType: Driver<AnimeStatusType> {
        return state.mapDistinct { $0.statusType }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
