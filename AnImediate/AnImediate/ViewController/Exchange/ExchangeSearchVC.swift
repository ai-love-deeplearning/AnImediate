//
//  ExchangeSearchVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/27.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppModel
import UIKit
import Realm
import RealmSwift
import ReSwift
import RxCocoa
import RxSwift
import MultipeerConnectivity

class ExchangeSearchVC: UIViewController {
    
    // TODO:- インジケータはカスタムViewにする。
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var seachLLabel: UILabel!
    
    var timer: Timer!
    var searchingTimer: Timer!
    var searchingTime: Int = 0
    var count = 0
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.exchangeStore)
    
    private var viewState: ExchangeSearchViewState {
        return store.state.searchViewState
    }
    
    private var P2PSearchActionCreator: P2PSearchActionCreatable! = nil {
        willSet {
            if P2PSearchActionCreator != nil {
                fatalError()
            }
        }
    }
    
    private var ExchangeAccountActionCreator: ExchangeAccountActionCreatable! = nil {
        willSet {
            if ExchangeAccountActionCreator != nil {
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
    
    private var ExchangeNotificationActionCreator: ExchangeNotificationActionCreatable! = nil {
        willSet {
            if ExchangeNotificationActionCreator != nil {
                fatalError()
            }
        }
    }
    
    func inject(P2PSearchActionCreator: P2PSearchActionCreatable, ExchangeAccountActionCreator: ExchangeAccountActionCreatable, ExchangeArchiveActionCreator: ExchangeArchiveActionCreatable, ExchangeNotificationActionCreator: ExchangeNotificationActionCreatable) {
        print("@@@ inject @@@")
        self.P2PSearchActionCreator = P2PSearchActionCreator
        self.ExchangeAccountActionCreator = ExchangeAccountActionCreator
        self.ExchangeArchiveActionCreator = ExchangeArchiveActionCreator
        self.ExchangeNotificationActionCreator = ExchangeNotificationActionCreator
    }
    
    @objc func labelAnimetion(_ tm: Timer) {
        // TODO:- これもRxでもっと上手くできる。
        // AnimationLabel(strs: [String], duration: Double)
        // sartAnimation() -> void
        // stopAnimation() -> void
        // みたいなクラスを作る？
        switch count {
        case 0:
            seachLLabel.text = "Searching.  "
            count = 1
        case 1:
            seachLLabel.text = "Searching.. "
            count = 2
        case 2:
            seachLLabel.text = "Searching..."
            count = 0
        default:
            break;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initGradientLayer()
        
        animateIndicator()
        
        timer = Timer.scheduledTimer(timeInterval: 2.1, target: self, selector: #selector(self.labelAnimetion(_:)), userInfo: nil, repeats: true)
        timer.fire()
        
        self.searchingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.notFound), userInfo: nil, repeats: false)
        
        bind()
        
        print("@@@ ExSearchViewState @@@: \(self.viewState)")
        self.store.dispatch(self.P2PSearchActionCreator.startSearching(disposeBag: self.disposeBag))

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        timer = nil
        self.store.dispatch(self.P2PSearchActionCreator.stopSearching(disposeBag: self.disposeBag))
        self.store.dispatch(ExchangeSearchViewAction.Disconnect())
        self.store.dispatch(P2PConnectAction.Disconnect())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func bind() {
        
        store.isReceiveArchiveModel
            .drive(
                onNext: { [unowned self] _ in
                    if self.viewState.isReceivePeerModel {
                        print("@@@ Search Send Notification @@@")
                        self.store.dispatch(self.ExchangeNotificationActionCreator.sendNotification(disposeBag: self.disposeBag))
                    }
            })
            .disposed(by: disposeBag)
        
        store.isReceivePeerModel
            .drive(
                onNext: { [unowned self] _ in
                    if self.viewState.isReceiveArchiveModel {
                        print("@@@ Search Send Notification @@@")
                        self.store.dispatch(self.ExchangeNotificationActionCreator.sendNotification(disposeBag: self.disposeBag))
                    }
            })
            .disposed(by: disposeBag)
        
        store.isReceiveNotification
            .drive(
                onNext: { [unowned self] isReceiveNotification in
                    if self.chackValidTransition() {
                        self.store.dispatch(ExchangeAcceptViewAction.SetPeerID(peerID: self.store.state.p2pConnectionState.peerID))
                        self.performSegue(withIdentifier: "toExchangeAccept", sender: nil)
                    }
            })
            .disposed(by: disposeBag)
        
        store.connectionState
            .drive(
                onNext: {[unowned self] connectionState in
                    switch connectionState {
                    case .notConnected:
                        // TODO:- コネクションが切れたら全ViewStateを初期化する。
                        self.searchingTimer.fire()
                        break
                    case .connecting:
                        self.searchingTimer.invalidate()
                        self.searchingTime = 0
                        break
                    case .connected:
                        // TODO:- 再接続した時にちゃんとここに来るのか調査。一回
                        self.store.dispatch(self.ExchangeArchiveActionCreator.sendArchiveModel(disposeBag: self.disposeBag))
                        self.store.dispatch(self.ExchangeAccountActionCreator.sendAccountModel(disposeBag: self.disposeBag))
                    @unknown default:
                        fatalError()
                    }
                })
            .disposed(by: disposeBag)
        
        store.peerID
            .drive(
                onNext: { peerID in
                    if peerID.isNotEmpty {
                        self.store.dispatch(ExchangeSearchViewAction.ReceivePeerModel())
                    }
            })
            .disposed(by: disposeBag)
        
    }
    
    func initGradientLayer() {
//        let gradientRingLayer = WCGraintCircleLayer(bounds: loadingView.bounds, position: CGPoint(x: loadingView.frame.width/2, y: loadingView.frame.height/2), fromColor: .deepMagenta(), toColor: UIColor.white, linewidth: 8.0, toValue: 0)
        let gradientRingLayer = WCGraintCircleLayer(bounds: loadingView.bounds, position: CGPoint(x: loadingView.frame.width/2, y: loadingView.frame.height/2), fromColor: .white, toColor: .MainThema, linewidth: 8.0, toValue: 0)
        if loadingView.layer.sublayers != nil {
            loadingView.layer.sublayers!.forEach {
                $0.removeFromSuperlayer()
            }
        }
        loadingView.layer.addSublayer(gradientRingLayer)
        let duration = 0.8
        gradientRingLayer.animateCircleTo(duration: duration, fromValue: 0, toValue: 0.99)
    }
    
    func animateIndicator() {
        // TODO:- インジケータの処理を分離
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.isRemovedOnCompletion = true
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = CGFloat.pi * 2.0
        rotateAnimation.duration = 2.0 // 周期3秒
        rotateAnimation.repeatCount = .infinity
        
        loadingView.layer.add(rotateAnimation, forKey: "rotateindicator")
    }
    
    // TODO:- notfoundに飛ばす処理もRxで行う
    @objc func notFound() {
        searchingTime += 1
        if searchingTime == 60 {
            searchingTimer.invalidate()
            performSegue(withIdentifier: "toNotFound", sender: nil)
        }
    }
    
    private func chackValidTransition() -> Bool {
        if self.viewState.isReceiveArchiveModel, self.viewState.isReceivePeerModel, self.viewState.isSendArchiveModel, self.viewState.isSendAccountModel, self.viewState.isSendNotification {
            return true
        }
        return false
    }
    
}

private extension RxStore where AnyStateType == ExchangeViewState {
    var state: Driver<ExchangeSearchViewState> {
        return stateDriver.mapDistinct { $0.searchViewState }
    }
    
    var isReceivePeerModel: Driver<Bool> {
        return state.mapDistinct { $0.isReceivePeerModel }
    }
    
    var isSendAccountModel: Driver<Bool> {
        return state.mapDistinct { $0.isSendAccountModel }
    }
    
    var isReceiveArchiveModel: Driver<Bool> {
        return state.mapDistinct { $0.isReceiveArchiveModel }
    }
    
    var isSendArchiveModel: Driver<Bool> {
        return state.mapDistinct { $0.isSendArchiveModel }
    }
    
    var isSendNotification: Driver<Bool> {
        return state.mapDistinct { $0.isSendNotification }
    }
    
    var isReceiveNotification: Driver<Bool> {
        return state.mapDistinct { $0.isReceiveNotification }
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
