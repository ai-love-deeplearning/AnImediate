//
//  AnimeListTableVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import ReSwift
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift

class AnimeListTableVC: UIViewController {

    @IBOutlet weak var animeTable: UITableView!
    @IBOutlet weak var registerMenu: UIButton!
    
    private var registerBtns: [UIButton]?
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.animeListStore)
    
    private var viewState: AnimeListTableViewState {
        return store.state.tableViewState
    }
    
    private var dataSource: RxTableViewSectionedReloadDataSource<AnimeTableSectionModel>!
    private var sectionModels: [AnimeTableSectionModel]!
    private var dataRelay = BehaviorRelay<[AnimeTableSectionModel]>(value: [])
    
    private lazy var initRegisterBtnsLayout : Void = {
        self.registerBtns!.forEach{ $0.center = self.registerMenu.center }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animeTable.estimatedRowHeight = 130
        animeTable.rowHeight = UITableView.automaticDimension
        initRegisterBtns()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = initRegisterBtnsLayout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        // TODO:- contentTypeに応じてナビゲーションのタイトルを変更
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
            .bind(to: animeTable.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // TODO:- アイテムの削除を無効化したい
        animeTable.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self, let sectionModel = strongSelf.sectionModels.first else { return }
                var items = sectionModel.items
                items.remove(at: indexPath.row)
                
                strongSelf.sectionModels = [AnimeTableSectionModel(items: items)]
                // dataRelayにデータを流し込む
                strongSelf.dataRelay.accept(strongSelf.sectionModels)
            })
            .disposed(by: disposeBag)
        
        animeTable.rx.itemSelected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    if self.viewState.isRegisterMode == false {
                        let model = (self.animeTable.cellForRow(at: indexPath) as! AnimeListTableViewCell).anime
                        self.store.dispatch(AnimeDetailInfoViewAction.Initialize(animeModel: model!))
                        self.performSegue(withIdentifier: "toDetails", sender: nil)
                        self.animeTable.deselectRow(at: indexPath, animated: false)
                    }
            })
            .disposed(by: disposeBag)
        
        animeTable.rx.itemDeselected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    
            })
            .disposed(by: disposeBag)
        
        registerMenu.rx.tap.asDriver()
            .coolTime()
            .drive(
                onNext: { [unowned self] in
                    let toValue = self.viewState.isRegisterMode ? 0 : -CGFloat.pi/4
                    let fromValue = self.viewState.isRegisterMode ? -CGFloat.pi/4 : 0
                    self.animateMenu(to: toValue, from: fromValue)
                    self.animateMenuColor()
                    self.animateRegisterBtns(self.viewState.isRegisterMode)
                    
                    self.store.dispatch(AnimeListTableViewAction.ChangeMode())
            })
            .disposed(by: disposeBag)

    }
    
    private func bindState() {
        
        store.contentType
            .drive(
                onNext: { [unowned self] contentType in
                    print(contentType)
            })
            .disposed(by: disposeBag)
        
        store.isRegisterMode
            .drive(
                onNext: { [unowned self] isRegisterMode in
                    // 複数選択可にする
                    self.animeTable.allowsMultipleSelectionDuringEditing = isRegisterMode
                    self.animeTable.isEditing = isRegisterMode
                    self.animeTable.reloadData()
            })
            .disposed(by: disposeBag)
        
        store.searchKey
            .drive(
                onNext: { [unowned self] searchKey in
                    if self.viewState.contentType == .broadcast{
                        let items = Array(AnimeModel.readAll().filter("seasonNameText == %@", self.viewState.searchKey))
                        self.sectionModels = [AnimeTableSectionModel(items: items)]
                        self.fetch()
                    }
            })
            .disposed(by: disposeBag)
        
    }
    
    @objc func registerEvent(_ sender: UIButton) {
        
        guard let selectedIndexes = self.animeTable.indexPathsForSelectedRows else {
            let msg = "アニメが選択されていません"
            self.showAlert(title: "エラー", message: msg)
            return
        }

        if selectedIndexes.isNotEmpty {
            let msg = "\(HomeBarTitles.titles[sender.tag])に \(String(selectedIndexes.count))件のデータを登録しました"
            self.showAlert(title: "登録", message: msg)
            
            let selectedAnimes = selectedIndexes.map { self.sectionModels.first!.items[$0.row] }

            selectedAnimes.forEach {
                let uid = AccountModel.read().userID
                let status = HomeBarTitles.titles[sender.tag]
                ArchiveModel.set(userID: uid, annictID: $0.annictID, animeStatus: status)
            }
        }
        let toValue = self.viewState.isRegisterMode ? 0 : -CGFloat.pi/4
        let fromValue = self.viewState.isRegisterMode ? -CGFloat.pi/4 : 0
        self.animateMenu(to: toValue, from: fromValue)
        self.animateMenuColor()
        self.animateRegisterBtns(self.viewState.isRegisterMode)
        self.store.dispatch(AnimeListTableViewAction.ChangeMode())
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
    
}

// MARK:- Animation
extension AnimeListTableVC {
    
    private func initRegisterBtns() {
        registerBtns = (0 ..< 4).map({ _ in
            UIButton(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
        })
        for (index, btn) in registerBtns!.enumerated() {
            self.view.insertSubview(btn, belowSubview: registerMenu)
            btn.center = registerMenu.center
            btn.backgroundColor = .MainThema
            btn.setTitleColor(UIColor.white, for: UIControlState.normal)
            btn.setTitle(HomeBarTitles.titles[index], for: UIControlState.normal)
            btn.titleLabel?.font = .systemFont(ofSize: 11)
            btn.cornerRadius = btn.bounds.width / 2
            btn.shadowOffset = CGSize(width: 0.0, height: 4.0)
            btn.shadowColor = .black
            btn.shadowAlpha = 0.5
            btn.shadowRadius = 5
            btn.alpha = 0
            btn.tag = index
            btn.addTarget(self, action: #selector(registerEvent(_:)), for: UIControlEvents.touchUpInside)
        }
    }
    
    private func animateMenu(to: CGFloat, from: CGFloat) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.fillMode = CAMediaTimingFillMode.forwards
        rotateAnimation.fromValue = from
        rotateAnimation.toValue = to
        rotateAnimation.duration = 0.2
        
        registerMenu.layer.add(rotateAnimation, forKey: "rotateindicator")
    }
    
    private func animateMenuColor() {
        UIView.animate(withDuration: 0.2, animations: {
            self.registerMenu.backgroundColor = self.viewState.isRegisterMode ? .MainThema : .TextLightGray
        })
    }
    
    private func calcExpandedPoint(_ index: Int) -> CGPoint {
        let leadingMargin: CGFloat = 16
        let trailingMargin: CGFloat = 12
        let menuWidth = registerMenu.bounds.width
        let registerBtnWidth: CGFloat = 56
        
        let areaWidth = ScreenConfig.mainBoundSize.width - (leadingMargin + menuWidth + trailingMargin * 2)
        
        let margin = (areaWidth - registerBtnWidth * 4) / 3
        
        let x_position = leadingMargin + CGFloat(index) * (registerBtnWidth + margin) + registerBtnWidth / 2
        let y_position = registerMenu.center.y
        
        return CGPoint(x: x_position, y: y_position)
    }
    
    private func animateRegisterBtns(_ isRegisterMode: Bool) {
        if isRegisterMode {
            UIView.animate(withDuration: 0.2, animations: {
                self.registerBtns!.forEach{
                    $0.center = self.registerMenu.center
                    $0.alpha = 0
                }
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.registerBtns!.forEach{
                    $0.center = self.calcExpandedPoint($0.tag)
                    $0.alpha = 1
                }
            })
        }
        
    }
    
}

// MARK:- RxDatasources
extension AnimeListTableVC {
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
            items = Array(AnimeModel.readAll().filter("seasonNameText == %@", self.viewState.searchKey))
        }
        
        sectionModels = [AnimeTableSectionModel(items: items)]
        fetch()
    }
    
    private func initTable() {
        
        animeTable.tableFooterView = UIView(frame: .zero)
        
        dataSource = RxTableViewSectionedReloadDataSource<AnimeTableSectionModel>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnimeTableCell", for: IndexPath(row: indexPath.row, section: 0)) as! AnimeListTableViewCell
                
                // TODO:- setメソッドに変更
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

private extension RxStore where AnyStateType == AnimeListViewState {
    var state: Driver<AnimeListTableViewState> {
        return stateDriver.mapDistinct { $0.tableViewState }
    }
    
    var isRegisterMode: Driver<Bool> {
        return state.mapDistinct { $0.isRegisterMode }
    }
    
    var contentType: Driver<AnimeTableContentType> {
        return state.mapDistinct { $0.contentType }
    }
    
    var searchKey: Driver<String> {
        return state.mapDistinct { $0.searchKey }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
