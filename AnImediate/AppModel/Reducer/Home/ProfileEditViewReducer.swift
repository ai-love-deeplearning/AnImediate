// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import ReSwift

struct ProfileEditViewReducer {

    static func handleAction(action: Action, state: ProfileEditViewState?) -> ProfileEditViewState {
        var nextState = state ?? ProfileEditViewState()

        if action is AppAction.InitializeApplication {
            return ProfileEditViewState()
        }
/*
        nextState.moduleState = ModuleReducer.handleAction(action: action, state: nextState.moduleState)

        nextState.operation1ViewState = ProfileEditOperation1ViewReducer.handleAction(action: action, state: nextState.operation1ViewState)
        nextState.acceptViewState = ProfileEditOperation2ViewReducer.handleAction(action: action, state: nextState.operation2ViewState)*/

        return nextState
    }
}
