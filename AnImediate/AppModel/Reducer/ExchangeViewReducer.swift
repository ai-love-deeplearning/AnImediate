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
        
        switch action {
            
        case let action as ExchangeViewAction.Initialize:
            nextState = ExchangeViewState()
            
        case is ExchangeViewAction.DismissErrorAlert:
            nextState.error = nil
            
        case is ExchangeViewAction.SendAccountModel:
            nextState.isSendAccountModel = true
            nextState.error = nil
            
        case is ExchangeViewAction.SendArchiveModel:
            nextState.isSendArchiveModel = true
            nextState.error = nil
            
        case is ExchangeViewAction.ReceivePeerModel:
            nextState.isReceivePeerModel = true
            nextState.error = nil
            
        case is ExchangeViewAction.ReceiveArchiveModel:
            nextState.isReceiveArchiveModel = true
            nextState.error = nil

        default:
            break
        }
        
        return nextState
    }
}
