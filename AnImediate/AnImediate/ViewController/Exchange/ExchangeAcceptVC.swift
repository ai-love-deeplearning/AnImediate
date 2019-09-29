//
//  ExchangeAcceptVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/09.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import RealmSwift
import MultipeerConnectivity
import ReSwift
import RxCocoa
import RxSwift

class ExchangeAcceptVC: UIViewController {
    
    @IBOutlet private weak var peerIcon: UIImageView!
    @IBOutlet private weak var peerName: UILabel!
    
    @IBOutlet private weak var acceptBtn: UIButton!
    @IBOutlet private weak var cancelBtn: UIButton!
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.exchangeStore)
    
    private var viewState: ExchangeAcceptViewState {
        return store.state.acceptViewState
    }
    
    private var P2PDisconnectActionCreator: P2PDisconnectActionCreatable! = nil {
        willSet {
            if P2PDisconnectActionCreator != nil {
                fatalError()
            }
        }
    }
    
    private var ExchangeArchiveActionCreator: ExchangeArchiveActionCreatable! = nil {
        willSet {
            if ExchangeArchiveActionCreator != nil {
                fatalError()
            }
        }
    }
    
    func inject(P2PDisconnectActionCreator: P2PDisconnectActionCreatable, ExchangeArchiveActionCreator: ExchangeArchiveActionCreatable) {
        self.P2PDisconnectActionCreator = P2PDisconnectActionCreator
        self.ExchangeArchiveActionCreator = ExchangeArchiveActionCreator
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindState()
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setPeerData()
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO:- もしアクセプトボタンを押さずにviewが閉じたらRealmからアカウント情報を消す
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        acceptBtn.layer.cornerRadius = acceptBtn.frame.height / 2
        cancelBtn.layer.cornerRadius = cancelBtn.frame.height / 2
    }
    
    private func setPeerData() {
        let id = store.state.p2pConnectionState.peerID
        self.peerIcon.image = PeerModel.read(id: id).icon
        self.peerName.text =  PeerModel.read(id: id).name
    }
    
    private func bindViews() {
        // acceptBtnに改名
        acceptBtn.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [unowned self] in
                // TODO もしすでにデータを受け取っていたら画面遷移する処理
                // self.navigationController?.popToRootViewController(animated: true)
                self.store.dispatch(self.ExchangeArchiveActionCreator.sendArchiveModel(disposeBag: self.disposeBag))
            })
            .disposed(by: disposeBag)
        
        cancelBtn.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [unowned self] in
                // TODO:- 接続を切断して前の画面に遷移
                /*
                 let result = realm.objects(UserInfo.self).filter("id == %@", peerInfo.id)
                 try! realm.write {
                 realm.delete(result[0])
                 }
                 self.navigationController?.popViewController(animated: true)*/
                //self.store.dispatch(self.ExchangeArchiveActionCreator.sendArchiveModel(disposeBag: self.disposeBag))
            }).disposed(by: disposeBag)
    }
    
    private func bindState() {
        store.connectionState
            .drive(
                onNext: {[unowned self] connectionState in
                    switch connectionState {
                    case .notConnected:
                        // TODO:- 接続が切断されたとき自分も切断してAlartを出す -> ok が押されたらアラートを消して画面遷移
                        break
                    case .connecting, .connected:
                        // TODO:- ここに入ることはないはずだから何らかのエラーハンドリング
                        break
                    @unknown default:
                        fatalError()
                    }
            })
            .disposed(by: disposeBag)
        
        store.isSendArchiveModel
            .drive(
                onNext: { [unowned self] isSendAccountModel in
                    // TODO:- 先に受け取っていたら画面遷移
                    // TODO:- 受け取ってなかったら待機アニメーション
            })
            .disposed(by: disposeBag)
        
        store.isReceiveArchiveModel
            .drive(
                onNext: { account in
                    // TODO:- 受け取った通知を発行
                    // TODO:- すでに自分が送信していたら画面遷移
                    
            })
            .disposed(by: disposeBag)
        
    }
    
    // TODO:- フォーマットの処理はModel層に分離
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult" {
            self.store.dispatch(self.P2PDisconnectActionCreator.disconnect(disposeBag: disposeBag))
        }
    }

}

private extension RxStore where AnyStateType == ExchangeViewState {
    var state: Driver<ExchangeAcceptViewState> {
        return stateDriver.mapDistinct { $0.acceptViewState }
    }
    
    var isReceiveArchiveModel: Driver<Bool> {
        return state.mapDistinct { $0.isReceiveArchiveModel }
    }
    
    var isSendArchiveModel: Driver<Bool> {
        return state.mapDistinct { $0.isSendArchiveModel }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
    var p2pState: Driver<P2PConnectionState> {
        return stateDriver.mapDistinct { $0.p2pConnectionState }
    }
    
    var connectionState: Driver<MCSessionState> {
        return p2pState.mapDistinct { $0.connectionState }
    }
    
    var peerID: Driver<String> {
        return p2pState.mapDistinct { $0.peerID }
    }
    
    var isAdvertising: Driver<Bool> {
        return p2pState.mapDistinct { $0.isAdvertising }
    }
    
    var isBrowsing: Driver<Bool> {
        return p2pState.mapDistinct { $0.isBrowsing }
    }
    
    var isLoading: Driver<Bool> {
        return p2pState.mapDistinct { $0.isLoading }
    }
    
    var p2pError: Driver<AnimediateError> {
        return p2pState.mapDistinct { $0.error }.skipNil()
    }
    
}
