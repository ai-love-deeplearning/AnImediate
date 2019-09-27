//
//  ExchangeViewState.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift
import Realm
import RealmSwift

public struct ExchangeViewState: StateType  {
    public internal(set) var isSendAccountModel = false
    public internal(set) var isSendArchiveModel = false
    public internal(set) var isReceivePeerModel = false
    public internal(set) var isReceiveArchiveModel = false
    public internal(set) var error: AnimediateError?
}

extension ExchangeViewState: Equatable {
    public static func == (lhs: ExchangeViewState, rhs: ExchangeViewState) -> Bool {
        return lhs.isSendAccountModel == rhs.isSendAccountModel
            && lhs.isSendArchiveModel == rhs.isSendArchiveModel
            && lhs.isReceivePeerModel == rhs.isReceivePeerModel
            && lhs.isReceiveArchiveModel == rhs.isReceiveArchiveModel
    }
}
