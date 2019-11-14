//
//  LaunchViewReducer.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/09.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

struct LaunchViewReducer {
    
    static func handleAction(action: Action, state: LaunchViewState?) -> LaunchViewState {
        var nextState = state ?? LaunchViewState()
        
        switch action {
            
        case is LaunchViewAction.Initialize:
            nextState.isAnimeFetched = CommonStateModel.read().isAnimeFetched
            nextState.isEpisodeFetched = CommonStateModel.read().isEpisodeFetched
            
        case is LaunchViewAction.FetchAllAnimeCompleted:
            nextState.isAnimeFetched = true
            
        case is LaunchViewAction.FetchAllEpisodeCompleted:
            nextState.isEpisodeFetched = true
            
//        case is LaunchViewAction.FetchAllAnimeSuccess:
//
//        case is LaunchViewAction.FetchAllEpisodeSuccess:
            
        default:
            break
        }
        
        return nextState
    }
}
