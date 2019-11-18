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

@available(iOS 13.0, *)

class AnimeDetailInfoVC: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var synopsisLabel: UILabel!
    @IBOutlet private weak var keepButton: UIButton!
    @IBOutlet private weak var nowButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var oneEvalButton: UIButton!
    @IBOutlet private weak var twoEvalButton: UIButton!
    @IBOutlet private weak var threeEvalButton: UIButton!
    @IBOutlet private weak var fourEvalButton: UIButton!
    @IBOutlet private weak var fiveEvalButton: UIButton!
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
        bindViews()
        bindState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func bindViews() {
//        similarCollectionView.register(UINib(nibName: "AnimeHorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "similarCell")
//
//        similarDataRelay.asObservable()
//            .bind(to: similarCollectionView.rx.items(dataSource: similarDataSource))
//            .disposed(by: disposeBag)
//
//        similarCollectionView.rx.itemSelected
//            .subscribe(
//                onNext: { [unowned self] indexPath in
//                    guard let anime = self.similarSectionModels.first?.items[indexPath.row] else { return }
//                    self.store.dispatch(AnimeDetailInfoViewAction.Initialize(animeModel: anime))
//                    self.performSegue(withIdentifier: "toDetails", sender: nil)
//            })
//            .disposed(by: disposeBag)
//
//        statusTextField.rx.text.orEmpty.asObservable()
//            .subscribe { [unowned self] in
//                // TODO:- Pickerならいらない説
//            }
//            .disposed(by: disposeBag)
//
//        statusTextField.rx.controlEvent(.editingDidEnd).asDriver()
//            .drive(onNext: { [weak self] in
//                guard let strongSelf = self else { return }
//                if strongSelf.statusTextField.text != "" {
//                    let userTD = AccountModel.read().userID
//                    let archive = ArchiveModel.read(uid: userTD).filter("annictID == %@", strongSelf.viewState.animeModel?.annictID)
//
//                    ArchiveModel.set(archive: archive.first!)
//                }
//            })
//            .disposed(by: disposeBag)
//
//        similarBtn.rx.tap.asDriver()
//            .coolTime()
//            .drive(onNext: {
//                self.store.dispatch(AnimeListTableViewAction.Initialize(contentType: .ranking))
//                self.performSegue(withIdentifier: "toDetails", sender: nil)
//            }).disposed(by: disposeBag)
        
        keepButton.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                if strongSelf.keepButton.titleLabel!.text != "" {
                    let uid = AccountModel.read().userID
                    let annictid = (strongSelf.viewState.animeModel?.annictID)!
                    let status = strongSelf.keepButton.titleLabel!.text!
                    ArchiveModel.set(userID: uid, annictID: annictid, animeStatus: status)
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
                    ArchiveModel.set(userID: uid, annictID: annictid, animeStatus: status)
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
                    ArchiveModel.set(userID: uid, annictID: annictid, animeStatus: status)
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
                    ArchiveModel.set(userID: uid, annictID: annictid, animeStatus: status)
                }
            }).disposed(by: disposeBag)
        
        oneEvalButton.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: {
                let btns : [UIButton] = [self.oneEvalButton, self.twoEvalButton, self.threeEvalButton, self.fourEvalButton, self.fiveEvalButton]
                let images : [UIImage] = [self.starFillImage!, self.starImage!, self.starImage!, self.starImage!, self.starImage!]
                self.setBtnImage(btn: btns, image: images)
                print("1")
            }).disposed(by: disposeBag)
        
        twoEvalButton.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: {
                let btns : [UIButton] = [self.oneEvalButton, self.twoEvalButton, self.threeEvalButton, self.fourEvalButton, self.fiveEvalButton]
                let images : [UIImage] = [self.starFillImage!, self.starFillImage!, self.starImage!, self.starImage!, self.starImage!]
                self.setBtnImage(btn: btns, image: images)
                print("2")
            }).disposed(by: disposeBag)
        
        threeEvalButton.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: {
                let btns : [UIButton] = [self.oneEvalButton, self.twoEvalButton, self.threeEvalButton, self.fourEvalButton, self.fiveEvalButton]
                let images : [UIImage] = [self.starFillImage!, self.starFillImage!, self.starFillImage!, self.starImage!, self.starImage!]
                self.setBtnImage(btn: btns, image: images)
                print("3")
            }).disposed(by: disposeBag)
        
        fourEvalButton.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: {
                let btns : [UIButton] = [self.oneEvalButton, self.twoEvalButton, self.threeEvalButton, self.fourEvalButton, self.fiveEvalButton]
                let images : [UIImage] = [self.starFillImage!, self.starFillImage!, self.starFillImage!, self.starFillImage!, self.starImage!]
                self.setBtnImage(btn: btns, image: images)
                print("4")
            }).disposed(by: disposeBag)
        
        fiveEvalButton.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: {
                let btns : [UIButton] = [self.oneEvalButton, self.twoEvalButton, self.threeEvalButton, self.fourEvalButton, self.fiveEvalButton]
                let images : [UIImage] = [self.starFillImage!, self.starFillImage!, self.starFillImage!, self.starFillImage!, self.starFillImage!]
                self.setBtnImage(btn: btns, image: images)
                print("5")
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
    
    private func setBtnImage(btn: [UIButton], image: [UIImage]) {
        for i in 0..<5 {
            btn[i].setImage(image[i], for: .normal)
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
