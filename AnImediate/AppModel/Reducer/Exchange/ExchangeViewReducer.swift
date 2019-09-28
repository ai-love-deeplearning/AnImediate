//
//  ExchangeViewReducer.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

struct ExchangeViewReducer {
    
    static func handleAction(action: Action, state: ExchangeViewState?) -> ExchangeViewState {
        var nextState = state ?? ExchangeViewState()
        
        if action is AppAction.InitializeApplication {
            return ExchangeViewState()
        }
        
        nextState.p2pConnectionState = P2PConnectionReducer.handleAction(action: action, state: nextState.p2pConnectionState)
        
        nextState.searchViewState = ExchangeSearchViewReducer.handleAction(action: action, state: nextState.searchViewState)
        nextState.acceptViewState = ExchangeAcceptViewReducer.handleAction(action: action, state: nextState.acceptViewState)
        
        return nextState
    }
}
        
        
