//
//  AnimeDetailURLViewReducer.swift
//  AppModel
//
//  Created by 前田陸 on 2019/11/19.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

struct AnimeDetailURLViewReducer {

    static func handleAction(action: Action, state: AnimeDetailURLViewState?) -> AnimeDetailURLViewState {
        var nextState = state ?? AnimeDetailURLViewState()

        if action is AppAction.InitializeApplication {
            return AnimeDetailURLViewState()
        }

        switch action {

        case let action as AnimeDetailURLViewAction.Initialize:
            nextState = AnimeDetailURLViewState()
            nextState.animeModel = action.animeModel

        case is AnimeDetailURLViewAction.DismissErrorAlert:
            nextState.error = nil

        case is AnimeDetailURLViewAction.ExampleAction1:
            nextState.error = nil
            
        default:
            break
        }

        return nextState
    }
}
