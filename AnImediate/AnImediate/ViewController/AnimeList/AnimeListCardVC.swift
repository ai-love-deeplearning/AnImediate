//
//  AnimeListCardVC.swift
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

class AnimeListCardVC: UIViewController {

    @IBOutlet private weak var animeCardTable: UITableView!
    @IBOutlet private weak var registerModeBtn: UIBarButtonItem!
    @IBOutlet private weak var floatingView: UIView!
    @IBOutlet private weak var statusTextField: AnimeStatusTextField!
    @IBOutlet private weak var registerBtn: UIButton!
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.animeListStore)
    
    private var viewState: AnimeListCardViewState {
        return store.state.cardViewState
    }
    
    private var dataSource: RxTableViewSectionedReloadDataSource<AnimeCardSectionModel>!
    private var sectionModels: [AnimeCardSectionModel]!
    private var dataRelay = BehaviorRelay<[AnimeCardSectionModel]>(value: [])
    

//    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            .bind(to: animeCardTable.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // TODO:- アイテムの削除を無効化したい
        animeCardTable.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self, let sectionModel = strongSelf.sectionModels.first else { return }
                var items = sectionModel.items
                items.remove(at: indexPath.row)
                
                strongSelf.sectionModels = [AnimeCardSectionModel(items: items)]
                // dataRelayにデータを流し込む
                strongSelf.dataRelay.accept(strongSelf.sectionModels)
            })
            .disposed(by: disposeBag)
        
        animeCardTable.rx.itemSelected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    let cell = self.animeCardTable.cellForRow(at: indexPath) as! AnimeCardTableViewCell
                    if self.viewState.isRegisterMode {
                        cell.border()
                    } else {
                        self.animeCardTable.deselectRow(at: indexPath, animated: false)
                    }
            })
            .disposed(by: disposeBag)
        
        animeCardTable.rx.itemDeselected
            .subscribe(
                onNext: { [unowned self] indexPath in
                    let cell = self.animeCardTable.cellForRow(at: indexPath) as! AnimeCardTableViewCell
                    cell.unborder()
            })
            .disposed(by: disposeBag)
        
//        animeCardTable.rx.modelSelected(AnimeCardSectionModel.self)
//            .subscribe(
//                onNext: { [unowned self] item in
//                    // TODO:- もし登録モードじゃなかったら該当セルのアニメ詳細に遷移する
//                    guard self.viewState.isRegisterMode else {
//                        // TODO:- 該当セルのannictIDを取得
//                        // TODO:- AnimeDetailInfoViewStateにdispatch
////                        self.store.dispatch(AnimeDetailInfoViewAction.Initialize(item))
//                        self.performSegue(withIdentifier: "toDetails", sender: nil)
//                        return
//                    }
//            })
//            .disposed(by: disposeBag)
        
        registerModeBtn.rx.tap.asDriver()
            .coolTime().drive(
                onNext: { [unowned self] in
                    self.store.dispatch(AnimeListCardViewAction.ChangeMode())
            })
            .disposed(by: disposeBag)
        
        statusTextField.rx.text.orEmpty.asObservable()
            .subscribe { [unowned self] in
                // TODO:- Pickerならいらない説
                // ここでViewModelに値の更新を通知する
            }
            .disposed(by: disposeBag)
        
        registerBtn.rx.tap.asDriver()
            .coolTime().drive(
                onNext: { [unowned self] in
                    let selectedIndexes = self.animeCardTable.indexPathsForSelectedRows!
                    
                    if self.statusTextField.text!.isEmpty {
                        self.showAlert(title: "エラー", message: "ステータスを設定してください")
                        return
                    } else {
                        let msg = "\(self.statusTextField.text!)に \(String(selectedIndexes.count))件のデータを登録しました"
                        self.showAlert(title: "登録", message: msg)
                    }
                    
                    if selectedIndexes.isNotEmpty {
                        
                        let selectedAnimes = selectedIndexes.map { self.sectionModels.first!.items[$0.row] }
                        
                        selectedAnimes.forEach {
                            let uid = AccountModel.read().userID
                            let status = self.statusTextField.text!
                            ArchiveModel.set(userID: uid, annictID: $0.annictID, animeStatus: status)
                        }
                        
                    }
                    self.store.dispatch(AnimeListCardViewAction.ChangeMode())
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState() {
        store.isRegisterMode
            .drive(
                onNext: { [unowned self] isRegisterMode in
                    self.floatingView.isHidden = !isRegisterMode
                    self.registerModeBtn.title = isRegisterMode ? "キャンセル" : "登録"
                    self.registerModeBtn.tintColor = isRegisterMode ? .lightGray : .deepMagenta()
                    // 複数選択可にする
                    self.animeCardTable.allowsMultipleSelection = isRegisterMode
                    self.animeCardTable.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingView.layer.cornerRadius = floatingView.frame.height / 2
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

extension AnimeListCardVC {
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
        
        sectionModels = [AnimeCardSectionModel(items: items)]
        fetch()
    }
    
    private func initTable() {
        
        animeCardTable.register(UINib(nibName: "AnimeCardTableCell", bundle: nil), forCellReuseIdentifier: "AnimeCardCell")
        
        animeCardTable.tableFooterView = UIView(frame: .zero)
        
        dataSource = RxTableViewSectionedReloadDataSource<AnimeCardSectionModel>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnimeCardCell", for: IndexPath(row: indexPath.row, section: 0)) as! AnimeCardTableViewCell

                cell.anime = item
                _ = cell.isSelected ? cell.border() : cell.unborder()
                
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
    var state: Driver<AnimeListCardViewState> {
        return stateDriver.mapDistinct { $0.cardViewState }
    }
    
    var isRegisterMode: Driver<Bool> {
        return state.mapDistinct { $0.isRegisterMode }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
