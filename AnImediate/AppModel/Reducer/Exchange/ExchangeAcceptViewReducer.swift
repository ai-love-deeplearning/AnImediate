//
//  ExchangeAcceptViewReducer.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/28.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

struct ExchangeAcceptViewReducer {
    
    static func handleAction(action: Action, state: ExchangeAcceptViewState?) -> ExchangeAcceptViewState {
        var nextState = state ?? ExchangeAcceptViewState()
        
        if action is AppAction.InitializeApplication {
            return ExchangeAcceptViewState()
        }
        
        switch action {
            
        case is ExchangeAcceptViewAction.Initialize:
            nextState = ExchangeAcceptViewState()
            
        case is ExchangeAcceptViewAction.DismissErrorAlert:
            nextState.error = nil
            
        case let action as ExchangeAcceptViewAction.SetPeerID:
            nextState.peerID = action.peerID
            nextState.error = nil
            
        default:
            break
        }
        
        return nextState
    }
}
