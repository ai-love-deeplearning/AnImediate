// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import ReSwift

struct AnimeListCardViewReducer {

    static func handleAction(action: Action, state: AnimeListCardViewState?) -> AnimeListCardViewState {
        var nextState = state ?? AnimeListCardViewState()

        if action is AppAction.InitializeApplication {
            return AnimeListCardViewState()
        }

        if action is AppAction.InitializeApplication {
            return AnimeListCardViewState()
        }

        switch action {

        case let action as AnimeListCardViewAction.Initialize:
            nextState = AnimeListCardViewState()
            nextState.contentType = action.contentType

        case is AnimeListCardViewAction.DismissErrorAlert:
            nextState.error = nil

        case is AnimeListCardViewAction.ChangeMode:
            nextState.isRegisterMode = !nextState.isRegisterMode 
            nextState.error = nil

        default:
            break
        }

        return nextState
    }
}
