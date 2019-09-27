//
//  ExchangeViewActionCreator.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import Foundation
import ReSwift
import RxSwift

public protocol ExchangeAccountActionCreatable {
    func sendAccountModel(disposeBag: DisposeBag) -> Store<ExchangeViewState>.AsyncActionCreator
}

public class ExchangeAccountActionCreator: ExchangeAccountActionCreatable {
    
    private let connector: P2PConnectable
    
    public init(connector: P2PConnectable) {
        self.connector = connector
    }
    
    public func sendAccountModel(disposeBag: DisposeBag) -> Store<ExchangeViewState>.AsyncActionCreator {
        
        return { [weak self] state, store, callback in
            callback { _, _ in ExchangeViewAction.SendAccountModel() }
            
            // ここにP2PConectivityの通信処理を書く。
            // 通信した結果コネクションが繋がったらSuccess、１、二分待っても相手が見つからなかったらtimeoutのActionを発行する。
            self?.connector.sendAccountModel(data: AccountModel.readAsData())
                .subscribe(
                    onSuccess: { _ in
                        let action = P2PAction.SendAccountModelSuccess()
                        callback { _, _ in action }
                },
                    onError: { error in
                         print(error.localizedDescription)
                         print("エラー: 正常にデータの送信が行われませんでした")
                }
                )
                .disposed(by: disposeBag)
        }
    }
    
}

public protocol ExchangeArchiveActionCreatable {
    func sendArchiveModel(disposeBag: DisposeBag) -> Store<ExchangeViewState>.AsyncActionCreator
}

public class ExchangeArchiveActionCreator: ExchangeArchiveActionCreatable {
    
    private let connector: P2PConnectable
    
    public init(connector: P2PConnectable) {
        self.connector = connector
    }
    
    public func sendArchiveModel(disposeBag: DisposeBag) -> Store<ExchangeViewState>.AsyncActionCreator {
        
        return { [weak self] state, store, callback in
            callback { _, _ in ExchangeViewAction.SendArchiveModel() }
            
            // ここにP2PConectivityの通信処理を書く。
            // 通信した結果コネクションが繋がったらSuccess、１、二分待っても相手が見つからなかったらtimeoutのActionを発行する。
            self?.connector.sendArchiveModel(data: ArchiveModel.readAsData())
                .subscribe(
                    onSuccess: { _ in
                        let action = P2PAction.SendArchiveModelSuccess()
                        callback { _, _ in action }
                },
                    onError: { error in
                        print(error.localizedDescription)
                        print("エラー: 正常にデータの送信が行われませんでした")
                })
                .disposed(by: disposeBag)
        }
    }
}
