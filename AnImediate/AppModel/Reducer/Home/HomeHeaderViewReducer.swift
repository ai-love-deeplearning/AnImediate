// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import ReSwift

struct HomeHeaderViewReducer {

    static func handleAction(action: Action, state: HomeHeaderViewState?) -> HomeHeaderViewState {
        var nextState = state ?? HomeHeaderViewState()

        if action is AppAction.InitializeApplication {
            return HomeHeaderViewState()
        }

        switch action {

        case is HomeHeaderViewAction.Initialize:
            nextState = HomeHeaderViewState()

        case is HomeHeaderViewAction.DismissErrorAlert:
            nextState.error = nil

        default:
            break
        }

        return nextState
    }
}
