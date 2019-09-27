//
//  AppState.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift

public struct AppState: StateType {
    public internal(set) var exchangeViewState = ExchangeViewState()
}
