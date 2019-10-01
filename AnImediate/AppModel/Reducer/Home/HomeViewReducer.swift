//
//  HomeViewReducer.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/29.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

struct HomeViewReducer {
    
    static func handleAction(action: Action, state: HomeViewState?) -> HomeViewState {
        var nextState = state ?? HomeViewState()
        
        if action is AppAction.InitializeApplication {
            return HomeViewState()
        }
        
        nextState.profileEditViewState = ProfileEditViewReducer.handleAction(action: action, state: nextState.profileEditViewState)
        /*
        nextState.searchViewState = ExchangeSearchViewReducer.handleAction(action: action, state: nextState.searchViewState)
        nextState.acceptViewState = ExchangeAcceptViewReducer.handleAction(action: action, state: nextState.acceptViewState)*/
        
        return nextState
    }
}
