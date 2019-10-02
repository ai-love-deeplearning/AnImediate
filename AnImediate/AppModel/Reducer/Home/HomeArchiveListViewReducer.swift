// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import ReSwift

struct HomeArchiveListViewReducer {

    static func handleAction(action: Action, state: HomeArchiveListViewState?) -> HomeArchiveListViewState {
        var nextState = state ?? HomeArchiveListViewState()

        if action is AppAction.InitializeApplication {
            return HomeArchiveListViewState()
        }

        if action is AppAction.InitializeApplication {
            return HomeArchiveListViewState()
        }

        switch action {

        case is HomeArchiveListViewAction.Initialize:
            nextState = HomeArchiveListViewState()

        case is HomeArchiveListViewAction.DismissErrorAlert:
            nextState.error = nil

        case let action as HomeArchiveListViewAction.ChangeContent:
            nextState.statusType = action.content
            nextState.error = nil

        default:
            break
        }

        return nextState
    }
}
