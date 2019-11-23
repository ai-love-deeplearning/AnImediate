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
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.exchangeStore)
    
    private var viewState: ExchangeAcceptViewState {
        return store.state.acceptViewState
    }
    
    private var ExchangeArchiveActionCreator: ExchangeArchiveActionCreatable! = nil {
        willSet {
            if ExchangeArchiveActionCreator != nil {
                fatalError()
            }
        }
    }
    
    func inject(ExchangeArchiveActionCreator: ExchangeArchiveActionCreatable) {
        self.ExchangeArchiveActionCreator = ExchangeArchiveActionCreator
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindState()
        bindViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        acceptBtn.layer.cornerRadius = acceptBtn.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setPeerData()
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.store.dispatch(self.P2PDisconnectActionCreator.disconnect(disposeBag: disposeBag))
        // TODO:- もしアクセプトボタンを押さずにviewが閉じたらRealmから交換相手の情報を消す
        if let viewControllers = self.navigationController?.viewControllers {
            var existSelfInViewControllers = true
            for viewController in viewControllers {
                if viewController == self {
                    existSelfInViewControllers = false
                    break
                }
            }

            if existSelfInViewControllers {
                print("@@@ Accept deleeeeeeeeete @@@")
                PeerModel.delete(uid: store.state.p2pConnectionState.peerID)
                ArchiveModel.delete(uid: store.state.p2pConnectionState.peerID)
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func setPeerData() {
        let id = viewState.peerID
        print("@@@ Accept setPeerData @@@: \(id)")
        guard let peer = PeerModel.read(id: id).first else { return }
        self.peerIcon.image = peer.icon
        self.peerName.text =  peer.name
    }
    
    private func bindViews() {
        // acceptBtnに改名
        acceptBtn.rx.tap.asDriver()
            .coolTime()
            .drive(onNext: { [unowned self] in
                // TODO もしすでにデータを受け取っていたら画面遷移する処理
                self.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState() {
        store.peerID
            .drive(
                onNext: { [unowned self] peerID in
                    
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
//            self.store.dispatch(self.P2PDisconnectActionCreator.disconnect(disposeBag: disposeBag))
        }
    }

}

private extension RxStore where AnyStateType == ExchangeViewState {
    var state: Driver<ExchangeAcceptViewState> {
        return stateDriver.mapDistinct { $0.acceptViewState }
    }
    
    var peerID: Driver<String> {
        return state.mapDistinct { $0.peerID }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
