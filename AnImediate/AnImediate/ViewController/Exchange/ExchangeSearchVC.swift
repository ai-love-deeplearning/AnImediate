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
    
    //var isRecieveWatch: Bool = false
    
    var dateString = ""
    let now = NSDate()
    let formatter = DateFormatter()
    
    //var myInfo: UserInfo = UserInfo()
    //var peerInfo: UserInfo = UserInfo()
    
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
    
    func inject(P2PSearchActionCreator: P2PSearchActionCreatable, ExchangeAccountActionCreator: ExchangeAccountActionCreatable, ExchangeArchiveActionCreator: ExchangeArchiveActionCreatable) {
        self.P2PSearchActionCreator = P2PSearchActionCreator
        self.ExchangeAccountActionCreator = ExchangeAccountActionCreator
        self.ExchangeArchiveActionCreator = ExchangeArchiveActionCreator
    }
    
    @objc func labelAnimetion(_ tm: Timer) {
        // TODO:- これもRxでもっと上手くできる。
        // TODO:- AnimationLabel(strs: [String], duration: Double)
        // TODO:- sartAnimation() -> void
        // TODO:- stopAnimation() -> void
        // TODO:- みたいなクラスを作る？
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initGradientLayer()
        
        // TODO:- フォーマット処理をModel層に分離
        // TODO:- 交換日時の設定は他のどこかで行なっているはず？
        self.formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        self.dateString = self.formatter.string(from: now as Date)
        
        //self.peerInfo.excangedAt = self.dateString
        
        let realm = try! Realm()
        
        //let result = realm.objects(UserInfo.self)
        //myInfo = result[0].copy() as! UserInfo
        
        animateIndicator()
        
        timer = Timer.scheduledTimer(timeInterval: 2.1, target: self, selector: #selector(self.labelAnimetion(_:)), userInfo: nil, repeats: true)
        timer.fire()
        
        self.searchingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.notFound), userInfo: nil, repeats: false)
        
        bind()
        
        self.store.dispatch(self.P2PSearchActionCreator.startSerching(disposeBag: self.disposeBag))

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        timer = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initGradientLayer()
    }
    
    private func bind() {
        store.isSendAccountModel
            .drive(
                onNext: { [unowned self] isSendAccountModel in
                // TODO:- 先に受け取っていたら画面遷移
            })
            .disposed(by: disposeBag)
        
        store.connectionState
            .drive(
                onNext: {[unowned self] connectionState in
                    switch connectionState {
                    case .notConnected:
                        self.searchingTimer.fire()
                        break
                    case .connecting:
                        self.searchingTimer.invalidate()
                        self.searchingTime = 0
                        break
                    case .connected:
                        self.store.dispatch(self.ExchangeAccountActionCreator.sendAccountModel(disposeBag: self.disposeBag))
                    @unknown default:
                        fatalError()
                    }
                })
            .disposed(by: disposeBag)
        
        store.isReceivePeerModel
            .drive(
                onNext: { isReceivePeerModel in
                    if isReceivePeerModel {
                        
                    }
            })
            .disposed(by: disposeBag)
        
        store.peerID
            .drive(
                onNext: { peerID in
                    self.store.dispatch(ExchangeSearchViewAction.ReceivePeerModel())
            })
            .disposed(by: disposeBag)
        
    }
    
    func initGradientLayer() {
        let gradientRingLayer = WCGraintCircleLayer(bounds: loadingView.bounds, position: CGPoint(x: loadingView.frame.width/2, y: loadingView.frame.height/2), fromColor: .deepMagenta(), toColor: UIColor.white, linewidth: 8.0, toValue: 0)
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
    
    // TODO:- 余裕があったら画面遷移はCoodinatorを使いたい
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPopUpModal" {
            let nextVC = segue.destination as! ExchangeAcceptVC
            //nextVC.peerInfo = peerInfo
            //nextVC.isRecievedWatch = self.isRecieveWatch
        }
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
