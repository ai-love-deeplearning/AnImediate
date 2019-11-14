//
//  ExchangeSearchViewState.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/28.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift
import Realm
import RealmSwift

public struct ExchangeSearchViewState: StateType  {
    public internal(set) var isSendAccountModel = false
    public internal(set) var isReceivePeerModel = false
    public internal(set) var error: AnimediateError?
}

extension ExchangeSearchViewState: Equatable {
    public static func == (lhs: ExchangeSearchViewState, rhs: ExchangeSearchViewState) -> Bool {
        return lhs.isSendAccountModel == rhs.isSendAccountModel
            && lhs.isReceivePeerModel == rhs.isReceivePeerModel
    }
}
