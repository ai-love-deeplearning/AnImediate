//
//  ExchangeSearchViewReducer.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/28.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

struct ExchangeSearchViewReducer {
    
    static func handleAction(action: Action, state: ExchangeSearchViewState?) -> ExchangeSearchViewState {
        var nextState = state ?? ExchangeSearchViewState()
        
        if action is AppAction.InitializeApplication {
            return ExchangeSearchViewState()
        }
        
        switch action {
            
        case is ExchangeSearchViewAction.Initialize:
            nextState = ExchangeSearchViewState()
            
        case is ExchangeSearchViewAction.DismissErrorAlert:
            nextState.error = nil
            
        case is ExchangeSearchViewAction.Disconnect:
            nextState.isSendAccountModel = false
            nextState.isReceivePeerModel = false
            nextState.isSendArchiveModel = false
            nextState.isReceiveArchiveModel = false
            nextState.isSendNotification = false
            nextState.isReceiveNotification = false
            nextState.error = nil
            
        case is ExchangeSearchViewAction.SendAccountModel:
            nextState.isSendAccountModel = true
            nextState.error = nil
            
        case is ExchangeSearchViewAction.ReceivePeerModel:
            nextState.isReceivePeerModel = true
            nextState.error = nil
            
        case is ExchangeSearchViewAction.SendArchiveModel:
            nextState.isSendArchiveModel = true
            nextState.error = nil
            
        case is ExchangeSearchViewAction.ReceiveArchiveModel:
            nextState.isReceiveArchiveModel = true
            nextState.error = nil
        
        case is ExchangeSearchViewAction.SendNotification:
            nextState.isSendNotification = true
            nextState.error = nil
            
        case is ExchangeSearchViewAction.ReceiveNotification:
            nextState.isReceiveNotification = true
            nextState.error = nil
            
        default:
            break
        }
        
        return nextState
    }
}
