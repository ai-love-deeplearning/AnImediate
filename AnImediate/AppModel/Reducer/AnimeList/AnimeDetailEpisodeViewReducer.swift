// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import ReSwift

struct AnimeDetailEpisodeViewReducer {

    static func handleAction(action: Action, state: AnimeDetailEpisodeViewState?) -> AnimeDetailEpisodeViewState {
        var nextState = state ?? AnimeDetailEpisodeViewState()

        if action is AppAction.InitializeApplication {
            return AnimeDetailEpisodeViewState()
        }

        switch action {

        case let action as AnimeDetailEpisodeViewAction.Initialize:
            nextState = AnimeDetailEpisodeViewState()
            nextState.animeModel = action.animeModel

        case is AnimeDetailEpisodeViewAction.DismissErrorAlert:
            nextState.error = nil

//        case is AnimeDetailEpisodeViewAction.ExampleAction1:
//            nextState.episodes = true
//            nextState.error = nil
//
//        case let action as AnimeDetailEpisodeViewAction.ExampleAction2:
//            nextState.member = action.member
//            nextState.error = nil

        default:
            break
        }

        return nextState
    }
}
