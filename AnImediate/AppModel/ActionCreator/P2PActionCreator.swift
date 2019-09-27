//
//  P2PActionCreator.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/23.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import Foundation
import ReSwift
import RxSwift

public protocol P2PActionCreatable {
    func sendAccountModel(disposeBag: DisposeBag) -> Store<P2PConnectionState>.AsyncActionCreator
    func sendArchiveModel(disposeBag: DisposeBag) -> Store<P2PConnectionState>.AsyncActionCreator
}

public class P2PActionCreator: P2PActionCreatable {
    
     private let connector: P2PConnectable
     
     public init(connector: P2PConnectable) {
        self.connector = connector
     }
    
    public func startSerching(disposeBag: DisposeBag) -> Store<P2PConnectionState>.AsyncActionCreator {
        
        return { [weak self] state, store, callback in
             callback { _, _ in P2PAction.StartSearching() }
             
             // ここにP2PConectivityの通信処理を書く。
             // 通信した結果コネクションが繋がったらSuccess、１、二分待っても相手が見つからなかったらtimeoutのActionを発行する。
             self?.connector.startSearching(serviceType: P2PConfig.serviceType, displayName: UserInfo.read().name)
                .subscribe(
                    onNext: { newValue in
                        let action = P2PAction.ChangeState(newState: newValue)
                        callback { _, _ in action }
                }
                )
                .disposed(by: disposeBag)
        }
    }
    
    public func sendAccountModel(disposeBag: DisposeBag) -> Store<P2PConnectionState>.AsyncActionCreator {
        
        return { [weak self] state, store, callback in
            callback { _, _ in P2PAction.StartSearching() }
            
            // ここにP2PConectivityの通信処理を書く。
            // 通信した結果コネクションが繋がったらSuccess、１、二分待っても相手が見つからなかったらtimeoutのActionを発行する。
            self?.connector.startSearching(serviceType: P2PConfig.serviceType, displayName: UserInfo.read().name)
                .subscribe(
                    onNext: { newValue in
                        let action = P2PAction.ChangeState(newState: newValue)
                        callback { _, _ in action }
                }
                )
                .disposed(by: disposeBag)
        }
    }
    
    public func sendArchiveModel(disposeBag: DisposeBag) -> Store<P2PConnectionState>.AsyncActionCreator {
        
        return { [weak self] state, store, callback in
            callback { _, _ in P2PAction.StartSearching() }
            
            // ここにP2PConectivityの通信処理を書く。
            // 通信した結果コネクションが繋がったらSuccess、１、二分待っても相手が見つからなかったらtimeoutのActionを発行する。
            self?.connector.startSearching(serviceType: P2PConfig.serviceType, displayName: UserInfo.read().name)
                .subscribe(
                    onSuccess: {
                        let action = P2PAction.SendArchiveModelSuccess()
                        callback { _, _ in action }
                },
                    onError: {
                        let action = P2PAction.SSP5304RequestError(error: $0)
                        callback { _, _ in action }
                }
                )
                .disposed(by: disposeBag)
        }
    }
}
