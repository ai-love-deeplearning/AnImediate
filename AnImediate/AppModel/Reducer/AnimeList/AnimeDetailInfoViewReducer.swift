// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import ReSwift

struct AnimeDetailInfoViewReducer {

    static func handleAction(action: Action, state: AnimeDetailInfoViewState?) -> AnimeDetailInfoViewState {
        var nextState = state ?? AnimeDetailInfoViewState()

        if action is AppAction.InitializeApplication {
            return AnimeDetailInfoViewState()
        }

        if action is AppAction.InitializeApplication {
            return AnimeDetailInfoViewState()
        }

        switch action {

        case let action as AnimeDetailInfoViewAction.Initialize:
            nextState = AnimeDetailInfoViewState()
            nextState.animeModel = action.animeModel

        case is AnimeDetailInfoViewAction.DismissErrorAlert:
            nextState.error = nil

        case is AnimeDetailInfoViewAction.ExampleAction1:
            nextState.error = nil
            
        default:
            break
        }

        return nextState
    }
}
