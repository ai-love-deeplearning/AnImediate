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
        
        switch action {
            
        case is ProfileEditViewAction.Initialize:
            nextState = ProfileEditViewState()
            
        case is ProfileEditViewAction.DismissErrorAlert:
            nextState.error = nil
            
        case let action as ProfileEditViewAction.CangeCropType:
            nextState.cropType = action.cropType
            nextState.error = nil
        // TODO:- RealmのisRegisteredを変更
        case let action as ProfileEditViewAction.Registered:
            nextState.isFirstEdit = false
            nextState.error = nil
            
        default:
            break
        }

        return nextState
    }
}
