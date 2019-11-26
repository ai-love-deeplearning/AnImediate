//
//  AnimeDetailInfoVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/10.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import ReSwift
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift
import Cosmos

@available(iOS 13.0, *)

class AnimeDetailInfoVC: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var synopsisLabel: UILabel!
    @IBOutlet private weak var keepButton: UIButton!
    @IBOutlet private weak var nowButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet weak var evaluationView: CosmosView!
    //    @IBOutlet private weak var seasonLabel: UILabel!
//    @IBOutlet private weak var statusTextField: AnimeStatusTextField!
//    @IBOutlet private weak var similarCollectionView: AnimeHorizontalCollectionView!
//    @IBOutlet weak var similarBtn: UIButton!
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.animeListStore)
    
    private let starImage = UIImage(systemName: "star")
    private let starFillImage = UIImage(systemName: "star.fill")
    
    private var viewState: AnimeDetailInfoViewState {
        return store.state.detailInfoViewState
    }
    
//    private var similarDataSource: RxCollectionViewSectionedReloadDataSource<AnimeHorizontalCollectionSectionModel>!
//    private var similarSectionModels: [AnimeHorizontalCollectionSectionModel]!
//    private var similarDataRelay = BehaviorRelay<[AnimeHorizontalCollectionSectionModel]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disposeBag = DisposeBag()
//        fetchSimilar()
//        initCollectionViews()
        setViews()
        bindViews()
        bindState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func bindViews() {
        evaluationView.didTouchCosmos = { rating in
            let uid = AccountModel.read().userID
            guard let animeID = self.viewState.animeModel?.annictID else { return }
            let result = ArchiveModel.set(uid: uid, animeID: animeID, evalPoint: String(rating))
            
            if !result {
                let msg = "ステータスが設定されていません"
                self.showAlert(title: "エラー", message: msg)
                self.evaluationView.rating = 0
            }
            
        }
        
        keepButton.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                if strongSelf.keepButton.titleLabel!.text != "" {
                    let uid = AccountModel.read().userID
                    let annictid = (strongSelf.viewState.animeModel?.annictID)!
                    let status = strongSelf.keepButton.titleLabel!.text!
                    strongSelf.changeBtnState(btn: strongSelf.keepButton)
                    ArchiveModel.set(userID: uid, annictID: annictid, animeStatus: status, evalPoint: "", predictPoint: "")
                }
            }).disposed(by: disposeBag)
        
        nowButton.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                if strongSelf.nowButton.titleLabel!.text != "" {
                    let uid = AccountModel.read().userID
                    let annictid = (strongSelf.viewState.animeModel?.annictID)!
                    let status = strongSelf.nowButton.titleLabel!.text!
                    strongSelf.changeBtnState(btn: strongSelf.nowButton)
                    ArchiveModel.set(userID: uid, annictID: annictid, animeStatus: status, evalPoint: "", predictPoint: "")
                }
            }).disposed(by: disposeBag)
        
        doneButton.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                if strongSelf.doneButton.titleLabel!.text != "" {
                    let uid = AccountModel.read().userID
                    let annictid = (strongSelf.viewState.animeModel?.annictID)!
                    let status = strongSelf.doneButton.titleLabel!.text!
                    strongSelf.changeBtnState(btn: strongSelf.doneButton)
                    ArchiveModel.set(userID: uid, annictID: annictid, animeStatus: status, evalPoint: "", predictPoint: "")
                }
            }).disposed(by: disposeBag)
        
        stopButton.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                if strongSelf.stopButton.titleLabel!.text != "" {
                    let uid = AccountModel.read().userID
                    let annictid = (strongSelf.viewState.animeModel?.annictID)!
                    let status = strongSelf.stopButton.titleLabel!.text!
                    strongSelf.changeBtnState(btn: strongSelf.stopButton)
                    ArchiveModel.set(userID: uid, annictID: annictid, animeStatus: status, evalPoint: "", predictPoint: "")
                }
            }).disposed(by: disposeBag)
        
    }
    
    private func bindState() {
        
        if viewState.animeModel != nil {
            titleLabel.text = viewState.animeModel!.title
            synopsisLabel.text = viewState.animeModel!.synopsis
//            seasonLabel.text = "放送年：" + viewState.animeModel!.seasonNameText
        }
        
        store.animeModel
            .drive(
                onNext: { [unowned self] anime in
                    self.titleLabel.text = self.viewState.animeModel!.title
                    self.synopsisLabel.text = self.viewState.animeModel!.synopsis
//                    self.seasonLabel.text = "放送年：" + self.viewState.animeModel!.seasonNameText
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setViews() {
        let uid = AccountModel.read().userID
        guard let animeID = viewState.animeModel?.annictID else { return }
        guard let model = ArchiveModel.read(uid: uid, animeID: animeID) else { return }
        
        evaluationView.rating = Double(model.evalPoint) ?? 0
        
        switch model.animeStatus {
        case  AnimeStatusType.keep.rawValue:
            changeBtnState(btn: self.keepButton)
        case AnimeStatusType.now.rawValue:
            changeBtnState(btn: self.nowButton)
        case AnimeStatusType.done.rawValue:
            changeBtnState(btn: self.doneButton)
        case AnimeStatusType.stop.rawValue:
            changeBtnState(btn: self.stopButton)
        default:
            break
        }
    }
    
    private func changeBtnState(btn: UIButton) {
        let btns = [self.keepButton, self.nowButton, self.doneButton, self.stopButton]
        btns.forEach{
            $0?.backgroundColor = ($0 == btn) ? .MainThema : .white
            $0?.setTitleColor(($0 == btn) ? .white : .TextThema, for: .normal)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: {
            // アラートを閉じる
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "toDetails":
//            break
//        case "toSimilar":
//            let nextVC = segue.destination as! AnimeListTableVC
//            nextVC.navigationItem.title = "類似作品"
//            break
//        default:
//            break
//        }
//    }
    
}

@available(iOS 13.0, *)
extension AnimeDetailInfoVC {
    
    private func setBtnImage(btns: [UIButton], image: [UIImage]) {
        for (i, btn) in btns.enumerated() {
            btn.setImage(image[i], for: .normal)
        }
    }

//    private func fetchSimilar() {
//        // TODO:- 似ている作品のfetchメソッドを実装
//        let similarItems = Array(AnimeModel.readAllRanking()[0 ..< 50])
//
//        similarSectionModels = [AnimeHorizontalCollectionSectionModel(items: similarItems)]
//
//        Observable.just(similarSectionModels)
//            .subscribe(onNext: { [weak self] _ in
//                guard let strongSelf = self else { return }
//                strongSelf.similarDataRelay.accept(strongSelf.similarSectionModels)
//            })
//            .disposed(by: disposeBag)
//
//    }
//
//    private func initCollectionViews() {
//        similarDataSource = RxCollectionViewSectionedReloadDataSource<AnimeHorizontalCollectionSectionModel>(
//            configureCell: { [weak self] (_, collectinView, indexPath, item) in
//                guard let strongSelf = self else { return UICollectionViewCell() }
//                // 引数名通り、与えられたデータを利用してcellを生成する
//                let cell = collectinView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: IndexPath(row: indexPath.row, section: 0)) as! AnimeHorizontalCollectionViewCell
//
//                cell.setData(anime: item)
//
//                return cell
//        })
//
//    }

}

private extension RxStore where AnyStateType == AnimeListViewState {
    var state: Driver<AnimeDetailInfoViewState> {
        return stateDriver.mapDistinct { $0.detailInfoViewState }
    }
    
    var animeModel: Driver<AnimeModel> {
        return state.mapDistinct { $0.animeModel }.skipNil()
    }
    
    var statusType: Driver<AnimeStatusType> {
        return state.mapDistinct { $0.statusType }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
