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

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var peerCollectionView: AnimeHorizontalCollectionView!
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.exchangeStore)
    
    private var viewState: ExchangeTopViewState {
        return store.state.topViewState
    }
    
    private var userDataSource: RxCollectionViewSectionedReloadDataSource<PeerHorizontalCollectionSectionModel>!
    private var userSectionModels: [PeerHorizontalCollectionSectionModel]!
    private var userDataRelay = BehaviorRelay<[PeerHorizontalCollectionSectionModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO:- PeerModelを検索して交換済みユーザーがいるかいないかをviewStateに反映
        
//        if !self.resultUserInfo.isEmpty {
//            UserDefaults.standard.set(self.resultUserInfo[0].id, forKey: "userID")
//        }
//        UserDefaults.standard.set(0, forKey: "userNum")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPeer()
        initCollectionViews()
        bindViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func bindViews() {
        peerCollectionView.register(UINib(nibName: "AnimeHorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "userCell")
        
        userDataRelay.asObservable()
            .bind(to: peerCollectionView.rx.items(dataSource: userDataSource))
            .disposed(by: disposeBag)
        
        peerCollectionView.rx.itemSelected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    let cell = self.peerCollectionView.cellForItem(at: indexPath) as! AnimeHorizontalCollectionViewCell
                    // TODO:- 選択されていなかったら枠線をつける。
//                    cell.iconImageView.layer.borderWidth = 1
                    self.peerCollectionView.deselectItem(at: indexPath, animated: false)
                    
                    // TODO:- 次の画面へ値を渡す処理
                    //self.performSegue(withIdentifier: "toDetails", sender: nil)
            })
            .disposed(by: disposeBag)
        
        peerCollectionView.rx.itemDeselected
            .subscribe(onNext: { [unowned self] indexPath in
                let cell = self.peerCollectionView.cellForItem(at: indexPath) as! AnimeHorizontalCollectionViewCell
//                cell.iconImageView.layer.borderWidth = 0
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCV() {
//        self.userCV.showsHorizontalScrollIndicator = false
//        self.userCV.register(UINib(nibName: "ResultUserCVCell", bundle: nil), forCellWithReuseIdentifier: "userCell")
//
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: self.userCV.bounds.width*0.3, height: self.userCV.bounds.height)
//        layout.minimumLineSpacing = 0.3
//        layout.scrollDirection = .horizontal
//        self.userCV.collectionViewLayout = layout
    }
}

extension ExchangeTopVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = peerCollectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! ResultUserCVCell
//        //cell.bindData(userInfo: self.resultUserInfo[indexPath.row])
//
//        let selectCell = collectionView.cellForItem(at: indexPath) as! ResultUserCVCell
//        selectCell.iconImageView.layer.borderWidth = 1
//
//        //UserDefaults.standard.set(self.resultUserInfo[indexPath.row].id, forKey: "userID")
//        UserDefaults.standard.set(indexPath.row, forKey: "userNum")
        
//        self.headerDelegate?.reload()
//        self.scrollDelegate?.reload()
    }
}

extension ExchangeTopVC {
    
    private func fetchPeer() {
        let peerItems = Array(PeerModel.readAll())
        userSectionModels = [PeerHorizontalCollectionSectionModel(items: peerItems)]
        
        Observable.just(userSectionModels)
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.userDataRelay.accept(strongSelf.userSectionModels)
            })
            .disposed(by: disposeBag)
    }
    
    private func initCollectionViews() {
        userDataSource = RxCollectionViewSectionedReloadDataSource<PeerHorizontalCollectionSectionModel>(
            configureCell: { [weak self] (_, collectinView, indexPath, item) in
                guard let strongSelf = self else { return UICollectionViewCell() }
                // 引数名通り、与えられたデータを利用してcellを生成する
                let cell = collectinView.dequeueReusableCell(withReuseIdentifier: "userCell", for: IndexPath(row: indexPath.row, section: 0)) as! AnimeHorizontalCollectionViewCell
                
                cell.setData(user: item)
//                cell.iconImageView.layer.borderWidth = 0
                
                return cell
        })
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
