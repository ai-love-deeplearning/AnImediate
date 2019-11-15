// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import ReSwift

struct ExchangeTopViewReducer {

    static func handleAction(action: Action, state: ExchangeTopViewState?) -> ExchangeTopViewState {
        var nextState = state ?? ExchangeTopViewState()

        if action is AppAction.InitializeApplication {
            return ExchangeTopViewState()
        }

        switch action {

        case is ExchangeTopViewAction.Initialize:
            nextState = ExchangeTopViewState()

        case is ExchangeTopViewAction.DismissErrorAlert:
            nextState.error = nil

        case is ExchangeTopViewAction.ExchangeUserExist:
            nextState.isExchanged = true
            nextState.error = nil
            
        default:
            break
        }

        return nextState
    }
}
