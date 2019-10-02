//
//  ExchangeAcceptViewActionCreator.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/28.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import Foundation
import ReSwift
import RxSwift

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
            callback { _, _ in ExchangeAcceptViewAction.SendArchiveModel() }
            
            self?.connector.sendArchiveModel(data: ArchiveModel.readAsData(id: AccountModel.read().id))
                .subscribe(
                    onSuccess: { _ in
                        let action = P2PConnectAction.SendArchiveModelSuccess()
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
