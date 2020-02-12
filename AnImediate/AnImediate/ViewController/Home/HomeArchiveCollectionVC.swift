//
//  HomeArchiveCollectionVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2020/02/13.
//  Copyright © 2020 AI_Love_DeepLearning. All rights reserved.
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

class HomeArchiveCollectionVC: UIViewController {
    
    @IBOutlet weak var archiveCollectionView: UICollectionView!

    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.homeStore)
    private let animeListStore = RxStore(store: AppStore.instance.animeListStore)
    
    private var viewState: HomeArchiveListViewState {
        return store.state.homeArchiveListViewState
    }
    
    private var archiveDatasource: RxCollectionViewSectionedReloadDataSource<HomeArchiveSectionModel>!
    private var sectionModels: [HomeArchiveSectionModel]!
    private var dataRelay = BehaviorRelay<[HomeArchiveSectionModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        disposeBag = DisposeBag()
        initSectionModels()
        initCollectionView()
        bindViews()
//        bindState()
        fetch()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        disposeBag = DisposeBag()
    }
    
    private func bindViews() {
        
        archiveCollectionView.register(UINib(nibName: "ArchiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "archiveCell")
        
        dataRelay.asObservable()
            .bind(to: archiveCollectionView.rx.items(dataSource: archiveDatasource))
            .disposed(by: disposeBag)
        
        // アイテム削除時
//        archiveCollectionView.rx.itemDeleted
//            .subscribe(onNext: { [weak self] indexPath in
//                guard let strongSelf = self, let sectionModel = strongSelf.sectionModels.first else { return }
//                var items = sectionModel.items
//                items.remove(at: indexPath.row)
//                
//                strongSelf.sectionModels = [HomeArchiveSectionModel(items: items)]
//                // dataRelayにデータを流し込む
//                strongSelf.dataRelay.accept(strongSelf.sectionModels)
//            })
//            .disposed(by: disposeBag)
//        
        archiveCollectionView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                let model = self.sectionModels.first!.items[indexPath.row]
                let anime = AnimeModel.read(annictID: model.annictID)
                self.animeListStore.dispatch(AnimeDetailInfoViewAction.Initialize(animeModel: anime))
                self.animeListStore.dispatch(AnimeDetailEpisodeViewAction.Initialize(animeModel: anime))
                self.animeListStore.dispatch(AnimeDetailURLViewAction.Initialize(animeModel: anime))
                self.performSegue(withIdentifier: "toDetails", sender: nil)
            })
            .disposed(by: disposeBag)
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

extension HomeArchiveCollectionVC {
    private func initSectionModels() {
        // TODO:- ここでarchiveが0だとクラッシュ?
        let uid = AccountModel.read().userID
        let items = Array(ArchiveModel.read(uid: uid).filter("animeStatus == %@", self.viewState.statusType.rawValue))
        sectionModels = [HomeArchiveSectionModel(items: items)]
    }
    
    private func initCollectionView() {
        let layout = UICollectionViewFlowLayout()
        // TODO:- animeList:0.25(4個表示)、Exchange:0.3(3個表示)
//        layout.itemSize = CGSize(width: self.bounds.width*0.25, height: self.bounds.height)
        layout.itemSize = CGSize(width: ScreenConfig.mainBoundSize.width*0.2, height: ScreenConfig.mainBoundSize.width*0.2 * 1.68)
//        layout.minimumLineSpacing = 0.3
        layout.minimumLineSpacing = 22
        layout.sectionInset = UIEdgeInsets(top: 22, left: 16, bottom: 12, right: 16)
        
        archiveCollectionView.showsHorizontalScrollIndicator = false
        archiveCollectionView.showsVerticalScrollIndicator = false
        archiveCollectionView.collectionViewLayout = layout
        
        archiveDatasource = RxCollectionViewSectionedReloadDataSource<HomeArchiveSectionModel>(
            configureCell: { [weak self] (_, collectinView, indexPath, item) in
                guard let strongSelf = self else { return UICollectionViewCell() }
                // 引数名通り、与えられたデータを利用してcellを生成する
                let cell = collectinView.dequeueReusableCell(withReuseIdentifier: "archiveCell", for: IndexPath(row: indexPath.row, section: 0)) as! ArchiveCollectionViewCell
                
                cell.setData(item)
                cell.setImage("iconImages/\(item.annictID).jpg")
                
                return cell
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
