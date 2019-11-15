// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import ReSwift

struct AnimeListTableViewReducer {

    static func handleAction(action: Action, state: AnimeListTableViewState?) -> AnimeListTableViewState {
        var nextState = state ?? AnimeListTableViewState()

        if action is AppAction.InitializeApplication {
            return AnimeListTableViewState()
        }

        switch action {

        case let action as AnimeListTableViewAction.Initialize:
            nextState = AnimeListTableViewState()
            nextState.contentType = action.contentType

        case is AnimeListTableViewAction.DismissErrorAlert:
            nextState.error = nil

        case is AnimeListTableViewAction.ChangeMode:
            nextState.isRegisterMode = !nextState.isRegisterMode 
            nextState.error = nil

        default:
            break
        }

        return nextState
    }
}
