// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import ReSwift

struct ExchangeResultViewReducer {

    static func handleAction(action: Action, state: ExchangeResultViewState?) -> ExchangeResultViewState {
        var nextState = state ?? ExchangeResultViewState()

        if action is AppAction.InitializeApplication {
            return ExchangeResultViewState()
        }

        switch action {

        case let action as ExchangeResultViewAction.Initialize:
            nextState = ExchangeResultViewState()
            nextState.peerID = action.peerID

        case is ExchangeResultViewAction.DismissErrorAlert:
            nextState.error = nil
            
        case let action as ExchangeResultViewAction.ChangeContent:
            nextState.content = action.content
            nextState.error = nil

        default:
            break
        }

        return nextState
    }
}
