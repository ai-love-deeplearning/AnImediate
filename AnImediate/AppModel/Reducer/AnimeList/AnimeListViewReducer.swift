//
//  AnimeListViewReducer.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/29.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

struct AnimeListViewReducer {
    
    static func handleAction(action: Action, state: AnimeListViewState?) -> AnimeListViewState {
        var nextState = state ?? AnimeListViewState()
        
        if action is AppAction.InitializeApplication {
            return AnimeListViewState()
        }
        
        nextState.topViewState = AnimeListTopViewReducer.handleAction(action: action, state: nextState.topViewState)
        
        nextState.cardViewState = AnimeListCardViewReducer.handleAction(action: action, state: nextState.cardViewState)
        
        nextState.detailInfoViewState = AnimeDetailInfoViewReducer.handleAction(action: action, state: nextState.detailInfoViewState)
        
        return nextState
    }
}
