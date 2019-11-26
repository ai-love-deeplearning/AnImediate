//
//  P2PConnectActionCreator.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/23.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import Foundation
import ReSwift
import RxSwift

public protocol P2PSearchActionCreatable {
    func startSearching(disposeBag: DisposeBag) -> Store<ExchangeViewState>.AsyncActionCreator
    func stopSearching(disposeBag: DisposeBag) -> Store<ExchangeViewState>.AsyncActionCreator
}

public class P2PSearchActionCreator: P2PSearchActionCreatable {
    
    private let connector: P2PConnectable
    
    public init(connector: P2PConnectable) {
        self.connector = connector
    }
    
    public func stopSearching(disposeBag: DisposeBag) -> Store<ExchangeViewState>.AsyncActionCreator {
        return { [weak self] state, store, callback in
            callback { _, _ in P2PConnectAction.Disconnect()}
            callback { _, _ in ExchangeSearchViewAction.Disconnect()}
            
            self?.connector.disconnect()
        }
    }
    
    public func startSearching(disposeBag: DisposeBag) -> Store<ExchangeViewState>.AsyncActionCreator {
        
        return { [weak self] state, store, callback in
            callback { _, _ in P2PConnectAction.StartSearching() }
            
            let observable = self?.connector.startSearching(serviceType: P2PConfig.serviceType, displayName: AccountModel.read().name)
            observable!.session
                .subscribe(
                    onNext: { newValue in
                        let action = P2PConnectAction.ChangeState(connectionState: newValue)
                        callback { _, _ in action }
                }, onCompleted: {
                    print("@@@ SessionCompleted @@@")
                    let action = P2PConnectAction.Disconnect()
                    callback { _, _ in action }
                })
                .disposed(by: disposeBag)
            
            observable!.data
                .subscribe(
                    onNext: { data in
                        switch data.type {
                        case "PeerModel":
                            print("@@@ ActionCreator.ReceivePeerID @@@: \(data.id)")
                            let action = P2PConnectAction.ReceivePeerID(peerID: data.id)
                            callback { _, _ in action }
                        case "ArchiveModel":
                            let action = ExchangeSearchViewAction.ReceiveArchiveModel()
                            callback { _, _ in action }
                        case "Notification":
                            print("@@@ ActionCreator.Notification @@@")
                            let action = ExchangeSearchViewAction.ReceiveNotification()
                            callback { _, _ in action }
                        default:
                            fatalError()
                        }
                })
                .disposed(by: disposeBag)
        }
    }
    
}
