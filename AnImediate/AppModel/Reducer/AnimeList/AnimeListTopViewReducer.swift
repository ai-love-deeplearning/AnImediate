// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import ReSwift

struct AnimeListTopViewReducer {

    static func handleAction(action: Action, state: AnimeListTopViewState?) -> AnimeListTopViewState {
        var nextState = state ?? AnimeListTopViewState()

        if action is AppAction.InitializeApplication {
            return AnimeListTopViewState()
        }

        if action is AppAction.InitializeApplication {
            return AnimeListTopViewState()
        }

        switch action {

        case is AnimeListTopViewAction.Initialize:
            nextState = AnimeListTopViewState()

        case is AnimeListTopViewAction.DismissErrorAlert:
            nextState.error = nil

        case is AnimeListTopViewAction.CurrentTermRequestComplete:
            nextState.error = nil

        case is AnimeListTopViewAction.RankingRequestComplete:
            nextState.error = nil
            
        case let action as AnimeListTopViewAction.CurrentTermRequestSuccess:
            nextState.currentTerm = action.currentTerm
            nextState.error = nil
            
        case let action as AnimeListTopViewAction.RankingRequestSuccess:
            nextState.ranking = action.ranking
            nextState.error = nil

        default:
            break
        }

        return nextState
    }
}
