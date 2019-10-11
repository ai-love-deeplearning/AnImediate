//
//  AnimeListTopVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import Realm
import RealmSwift
import RxSwift
import RxCocoa
import RxDataSources
import ReSwift
import Firebase
import MXParallaxHeader
import CenteredCollectionView

protocol AnimeListTopVCDelegate: AnyObject {
    func animeListTopVCDidSelectList(_ list: AnimeCardContentType)
}

class AnimeListTopVC: UIViewController {
    
    @IBOutlet weak var recomCollectionView: UICollectionView!
    @IBOutlet weak var currentTermCollectionView: UICollectionView!
    @IBOutlet weak var rankingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var currentTermBtn: UIButton!
    @IBOutlet weak var rankingBtn: UIButton!
    
    weak var delegate: AnimeListTopVCDelegate?
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.animeListStore)
    
    private var viewState: AnimeListTopViewState {
        return store.state.topViewState
    }
    
    private var AnimeListTopViewActionCreator: AnimeListTopViewActionCreatable! = nil {
        willSet {
            if AnimeListTopViewActionCreator != nil {
                fatalError()
            }
        }
    }
    
    func inject(AnimeListTopViewActionCreator: AnimeListTopViewActionCreatable) {
        self.AnimeListTopViewActionCreator = AnimeListTopViewActionCreator
    }
    
    // TODO:- 各セクションモデルの実装
    private var recomDataSource:  RxCollectionViewSectionedReloadDataSource<AnimeListRecomCollectionSectionModel>!
    private var recomSectionModels: [AnimeListRecomCollectionSectionModel]!
    private var recomDataRelay = BehaviorRelay<[AnimeListRecomCollectionSectionModel]>(value: [])
    
    private var currentDataSource:  RxCollectionViewSectionedReloadDataSource<AnimeHorizontalCollectionSectionModel>!
    private var currentSectionModels: [AnimeHorizontalCollectionSectionModel]!
    private var currentDataRelay = BehaviorRelay<[AnimeHorizontalCollectionSectionModel]>(value: [])
    
    private var rankingDataSource:  RxCollectionViewSectionedReloadDataSource<AnimeHorizontalCollectionSectionModel>!
    private var rankingSectionModels: [AnimeHorizontalCollectionSectionModel]!
    private var rankingDataRelay = BehaviorRelay<[AnimeHorizontalCollectionSectionModel]>(value: [])
    
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    var autoScrollTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disposeBag = DisposeBag()
        
        // TODO:- ActionCreatorの処理を変更
//        self.store.dispatch(self.AnimeListTopViewActionCreator.getCurrentTerm(disposeBag: disposeBag))
        // TODO:- 今は同じ処理だから除外
        //self.store.dispatch(self.AnimeListTopViewActionCreator.getRanking(disposeBag: disposeBag))
        
//        fetchRecom()
        fetchRanking()
        fetchCurrentTerm()
        initCollectionViews()
        setupCCView()
        setupCV(cv: self.currentTermCollectionView)
        setupCV(cv: self.rankingCollectionView)
        bindViews()
        bindState()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func bindViews() {
        recomCollectionView.register(UINib(nibName: "RecomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "recomCell")
        
        currentTermCollectionView.register(UINib(nibName: "AnimeHorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "thisTermCell")
        
        rankingCollectionView.register(UINib(nibName: "AnimeHorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rankingCell")
        
        recomDataRelay.asObservable()
            .bind(to: recomCollectionView.rx.items(dataSource: recomDataSource))
            .disposed(by: disposeBag)
        
        currentDataRelay.asObservable()
            .bind(to: currentTermCollectionView.rx.items(dataSource: currentDataSource))
            .disposed(by: disposeBag)
        
        rankingDataRelay.asObservable()
            .bind(to: rankingCollectionView.rx.items(dataSource: rankingDataSource))
            .disposed(by: disposeBag)
        
        recomCollectionView.rx.itemSelected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    let cell = self.recomCollectionView.cellForItem(at: indexPath) as! RecomCollectionViewCell
                    
                    // TODO:- この謎の処理の解明
//                    let recomAnimeModel = recomAnimeModels[indexPath.row]
//                    cell.setData(anime: recomAnimeModel)
                    
                    // TODO:- 値が取得できているか判定
                    
                    self.recomCollectionView.deselectItem(at: indexPath, animated: false)
                    
                    // TODO:- 次の画面へ値を渡す処理
                    self.performSegue(withIdentifier: "toDetails", sender: nil)
            })
            .disposed(by: disposeBag)
        
        recomCollectionView.rx.didEndDecelerating
            .subscribe(
                onNext: { [unowned self] _ in
                    self.pageControl.currentPage = Int(self.recomCollectionView.contentOffset.x) / Int(self.recomCollectionView.frame.width)
            })
            .disposed(by: disposeBag)
        
        recomCollectionView.rx.didEndScrollingAnimation
            .subscribe(
                onNext: { [unowned self] _ in
                    self.pageControl.currentPage = Int(self.recomCollectionView.contentOffset.x) / Int(self.recomCollectionView.frame.width)
            })
            .disposed(by: disposeBag)
        
        currentTermCollectionView.rx.itemSelected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    guard let anime = self.currentSectionModels.first?.items[indexPath.row] else { return }
                    self.store.dispatch(AnimeDetailInfoViewAction.Initialize(animeModel: anime))
                    self.performSegue(withIdentifier: "toDetails", sender: nil)
            })
            .disposed(by: disposeBag)
        
        rankingCollectionView.rx.itemSelected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    guard let anime = self.rankingSectionModels.first?.items[indexPath.row] else { return }
                    self.store.dispatch(AnimeDetailInfoViewAction.Initialize(animeModel: anime))
                    self.performSegue(withIdentifier: "toDetails", sender: nil)
            })
            .disposed(by: disposeBag)
        
        currentTermBtn.rx.tap.asDriver()
            .coolTime()
            .drive(
                onNext: { [unowned self] in
                    // TODO:- 画面遷移の処理もこっちで書くべきか検討
                    self.store.dispatch(AnimeListCardViewAction.Initialize(contentType: .currentTerm))
            })
            .disposed(by: disposeBag)
        
        rankingBtn.rx.tap.asDriver()
            .coolTime()
            .drive(
                onNext: { [unowned self] in
                    self.store.dispatch(AnimeListCardViewAction.Initialize(contentType: .ranking))
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState() {
        store.recommend
            .drive(
                onNext: { [unowned self] reccomend in
                    self.startAutoScroll(duration: 7.0)
            })
            .disposed(by: disposeBag)
        
        store.currentTerm
            .drive(
                onNext: { [unowned self] currentTerm in
                    // collectionViewに反映
//                    self.fetchCurrentTerm()
            })
            .disposed(by: disposeBag)
        
        store.ranking
            .drive(
                onNext: { [unowned self] ranking in
                    // TODO:- 受け取ったのでStateに反映
//                    self.fetchRanking()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCCView() {
        recomCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        //recomCollectionView.delegate = self
        recomCollectionView.showsVerticalScrollIndicator = false
        recomCollectionView.showsHorizontalScrollIndicator = false
        
        centeredCollectionViewFlowLayout = recomCollectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout
        centeredCollectionViewFlowLayout.itemSize = CGSize(width: recomCollectionView.bounds.width,
                                                           height: recomCollectionView.bounds.height)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 0
    }
    
    private func startAutoScroll(duration: TimeInterval){
        var indexPath = recomCollectionView.indexPathsForVisibleItems.sorted { $0.item < $1.item }.first ?? IndexPath(item: 0, section: 0)
        
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            indexPath.row += 1
            
            if indexPath.row == 5 {
                indexPath.row = 0
            }
            
            DispatchQueue.main.async {
                self.recomCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            }
        })
    }
    
    private func setupCV(cv: UICollectionView) {
        //cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cv.bounds.width*0.25, height: cv.bounds.height)
        layout.minimumLineSpacing = 0.3
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        cv.collectionViewLayout = layout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toDetails":
            break
        case "fromThisTerm":
            let nextVC = segue.destination as! AnimeListCardVC
            nextVC.navigationItem.title = "今期アニメ"
            break
        case "fromRank":
            let nextVC = segue.destination as! AnimeListCardVC
            nextVC.navigationItem.title = "ランキング"
            break
        default:
            break
        }
    }
}

extension AnimeListTopVC: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension AnimeListTopVC {
    
    private func fetchCurrentTerm() {
        let currentItem = Array(AnimeModel.readCurrentTerm())
        currentSectionModels = [AnimeHorizontalCollectionSectionModel(items: currentItem)]
        
        Observable.just(currentSectionModels)
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.currentDataRelay.accept(strongSelf.currentSectionModels)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func fetchRanking() {
        let rankingItems = Array(AnimeModel.readAllRanking()[0 ..< 50])
        
        rankingSectionModels = [AnimeHorizontalCollectionSectionModel(items: rankingItems)]
        
        Observable.just(rankingSectionModels)
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.rankingDataRelay.accept(strongSelf.rankingSectionModels)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func fetchRecom() {
        guard let recomItems = viewState.recommend else {
            return
        }
        
        recomSectionModels = [AnimeListRecomCollectionSectionModel(items: Array(recomItems))]
        
        Observable.just(rankingSectionModels)
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.rankingDataRelay.accept(strongSelf.rankingSectionModels)
            })
            .disposed(by: disposeBag)
    }
    
    private func initCollectionViews() {
        recomDataSource = RxCollectionViewSectionedReloadDataSource<AnimeListRecomCollectionSectionModel>(
            configureCell: { [weak self] (_, collectinView, indexPath, item) in
                guard let strongSelf = self else { return UICollectionViewCell() }
                // 引数名通り、与えられたデータを利用してcellを生成する
                let cell = collectinView.dequeueReusableCell(withReuseIdentifier: "recomCell", for: IndexPath(row: indexPath.row, section: 0)) as! RecomCollectionViewCell
                
                cell.setData(anime: item)
                
                return cell
        })
        
        currentDataSource = RxCollectionViewSectionedReloadDataSource<AnimeHorizontalCollectionSectionModel>(
            configureCell: { [weak self] (_, collectinView, indexPath, item) in
                guard let strongSelf = self else { return UICollectionViewCell() }
                // 引数名通り、与えられたデータを利用してcellを生成する
                let cell = collectinView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: IndexPath(row: indexPath.row, section: 0)) as! AnimeHorizontalCollectionViewCell
                
                cell.setData(anime: item)
                
                return cell
        })
        
        rankingDataSource = RxCollectionViewSectionedReloadDataSource<AnimeHorizontalCollectionSectionModel>(
            configureCell: { [weak self] (_, collectinView, indexPath, item) in
                guard let strongSelf = self else { return UICollectionViewCell() }
                let cell = collectinView.dequeueReusableCell(withReuseIdentifier: "rankingCell", for: IndexPath(row: indexPath.row, section: 0)) as! AnimeHorizontalCollectionViewCell

                cell.setData(anime: item)
                return cell
        })
    }
    
}

private extension RxStore where AnyStateType == AnimeListViewState {
    var state: Driver<AnimeListTopViewState> {
        return stateDriver.mapDistinct { $0.topViewState }
    }
    // TODO:- Realmにすでにデータが入っているはずなのでいらない? or 最新状態を更新するために使う
    var recommend: Driver<[AnimeModel]> {
        return state.mapDistinct { $0.recommend }.skipNil()
    }
    
    var currentTerm: Driver<[AnimeModel]> {
        return state.mapDistinct { $0.currentTerm }.skipNil()
    }
    
    var ranking: Driver<[AnimeModel]> {
        return state.mapDistinct { $0.ranking }.skipNil()
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
