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

public protocol P2PSearchActionCreatable {
    func startSerching(disposeBag: DisposeBag) -> Store<P2PConnectionState>.AsyncActionCreator
}

public class P2PSearchActionCreator: P2PSearchActionCreatable {
    
    private let connector: P2PConnectable
    
    public init(connector: P2PConnectable) {
        self.connector = connector
    }
    
    public func startSerching(disposeBag: DisposeBag) -> Store<P2PConnectionState>.AsyncActionCreator {
        
        return { [weak self] state, store, callback in
            callback { _, _ in P2PAction.StartSearching() }
            
            let observable = self?.connector.startSearching(serviceType: P2PConfig.serviceType, displayName: AccountModel.read().name)
            observable!.session
                .subscribe(
                    onNext: { newValue in
                        let action = P2PAction.ChangeState(connectionState: newValue)
                        callback { _, _ in action }
                })
                .disposed(by: disposeBag)
            
            observable!.data
                .subscribe(
                    onNext: {
                        switch $0 {
                        case "PeerModel":
                            let action = ExchangeViewAction.ReceivePeerModel()
                            callback { _, _ in action }
                        case "ArchiveModel":
                            let action = ExchangeViewAction.ReceiveArchiveModel()
                            callback { _, _ in action }
                        default:
                            fatalError()
                        }
                })
                .disposed(by: disposeBag)
        }
    }
    
}
