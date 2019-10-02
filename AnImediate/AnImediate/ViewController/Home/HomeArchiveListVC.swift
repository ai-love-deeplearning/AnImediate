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
    }
    
    private func bindViews() {
        
    }
    
    private func bindState() {
        store.statusType
            .drive(
                onNext: { [unowned self] statusType in
                    // TODO:- TableViewのデータソースを切り返る処理
                    
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
        let items = [
            HomeArchiveModel(title: "", synopsis: "", season: "", image: UIImage(), registerCount: ""),
            HomeArchiveModel(title: "", synopsis: "", season: "", image: UIImage(), registerCount: ""),
            HomeArchiveModel(title: "", synopsis: "", season: "", image: UIImage(), registerCount: "")]
        sectionModels = [HomeArchiveSectionModel(items: items)]
    }
    
    private func initTable() {
        dataSource = RxTableViewSectionedReloadDataSource<HomeArchiveSectionModel>(
            configureCell: { _, tableView, indexPath, item in
                // 引数名通り、与えられたデータを利用してcellを生成する
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnimeCardCell", for: IndexPath(row: indexPath.row, section: 0)) as! ArchiveCardCell
                let archives = ArchiveModel.read(id: AccountModel.read().userID).filter("animeStatus == %@", self.viewState.statusType)
                let item =  AnimeModel.read(id: archives[indexPath.row].annictID)
                cell.anime = item
                cell.accessoryType = .disclosureIndicator
                
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
