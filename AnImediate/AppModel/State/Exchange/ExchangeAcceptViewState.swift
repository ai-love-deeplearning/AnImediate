//
//  ExchangeAcceptViewState.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/28.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift
import Realm
import RealmSwift

public struct ExchangeAcceptViewState: StateType  {
    public internal(set) var isSendArchiveModel = false
    public internal(set) var isReceiveArchiveModel = false
    public internal(set) var error: AnimediateError?
}

extension ExchangeAcceptViewState: Equatable {
    public static func == (lhs: ExchangeAcceptViewState, rhs: ExchangeAcceptViewState) -> Bool {
        return lhs.isSendArchiveModel == rhs.isSendArchiveModel
            && lhs.isReceiveArchiveModel == rhs.isReceiveArchiveModel
    }
}
