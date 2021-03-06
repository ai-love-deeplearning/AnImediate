//
//  SettingViewReducer.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/29.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

struct SettingViewReducer {
    
    static func handleAction(action: Action, state: SettingViewState?) -> SettingViewState {
        var nextState = state ?? SettingViewState()
        
        if action is AppAction.InitializeApplication {
            return SettingViewState()
        }
        /*
        nextState.p2pConnectionState = P2PConnectionReducer.handleAction(action: action, state: nextState.p2pConnectionState)
        
        nextState.searchViewState = ExchangeSearchViewReducer.handleAction(action: action, state: nextState.searchViewState)
        nextState.acceptViewState = ExchangeAcceptViewReducer.handleAction(action: action, state: nextState.acceptViewState)*/
        
        return nextState
    }
}
