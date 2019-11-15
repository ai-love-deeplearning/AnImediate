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
    @IBOutlet private weak var registerModeBtn: UIBarButtonItem!
    @IBOutlet private weak var floatingView: UIView!
    @IBOutlet private weak var statusTextField: AnimeStatusTextField!
    @IBOutlet private weak var registerBtn: UIButton!
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.animeListStore)
    
    private var viewState: AnimeListTableViewState {
        return store.state.tableViewState
    }
    
    private var dataSource: RxTableViewSectionedReloadDataSource<AnimeTableSectionModel>!
    private var sectionModels: [AnimeTableSectionModel]!
    private var dataRelay = BehaviorRelay<[AnimeTableSectionModel]>(value: [])
    

//    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animeTable.estimatedRowHeight = 130
        animeTable.rowHeight = UITableView.automaticDimension
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
        
        registerModeBtn.rx.tap.asDriver()
            .coolTime().drive(
                onNext: { [unowned self] in
                    self.store.dispatch(AnimeListTableViewAction.ChangeMode())
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
                    let selectedIndexes = self.animeTable.indexPathsForSelectedRows!
                    
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
                    self.store.dispatch(AnimeListTableViewAction.ChangeMode())
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
                    self.animeTable.allowsMultipleSelectionDuringEditing = isRegisterMode
                    self.animeTable.isEditing = isRegisterMode
                    self.animeTable.reloadData()
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
            items = Array(AnimeModel.readAllRanking())
        }
        
        sectionModels = [AnimeTableSectionModel(items: items)]
        fetch()
    }
    
    private func initTable() {
        
//        animeTable.register(UINib(nibName: "AnimeCardTableCell", bundle: nil), forCellReuseIdentifier: "AnimeCardCell")
        
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
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
