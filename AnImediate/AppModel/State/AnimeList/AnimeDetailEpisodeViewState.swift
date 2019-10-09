// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AppConfig
import ReSwift
import Realm
import RealmSwift

public struct AnimeDetailEpisodeViewState: StateType  {
    public internal(set) var episodes: [AnimeEpisodeModel]?
    public internal(set) var error: AnimediateError?
}

extension AnimeDetailEpisodeViewState: Equatable {
    public static func == (lhs: AnimeDetailEpisodeViewState, rhs: AnimeDetailEpisodeViewState) -> Bool {
        return lhs.episodes == rhs.episodes
    }
}
