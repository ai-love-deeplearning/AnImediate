// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import ReSwift
import Realm
import RealmSwift

public struct AnimeDetailEpisodeViewState: StateType  {
    public internal(set) var animeModel: AnimeModel?
    public internal(set) var error: AnimediateError?
}

extension AnimeDetailEpisodeViewState: Equatable {
    public static func == (lhs: AnimeDetailEpisodeViewState, rhs: AnimeDetailEpisodeViewState) -> Bool {
        return lhs.animeModel == rhs.animeModel
    }
}
