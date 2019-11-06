//
//  ExchangeViewState.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift

public struct ExchangeViewState: StateType, Equatable {
    public internal(set) var p2pConnectionState = P2PConnectionState()
    public internal(set) var searchViewState = ExchangeSearchViewState()
    public internal(set) var acceptViewState = ExchangeAcceptViewState()
    public internal(set) var topViewState = ExchangeTopViewState()
    public internal(set) var resultViewState = ExchangeResultViewState()
}

