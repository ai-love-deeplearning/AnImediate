// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import ReSwift
import Realm
import RealmSwift

public struct AnimeDetailInfoViewState: StateType  {
    public internal(set) var animeModel: AnimeModel?
    public internal(set) var error: AnimediateError?
}

extension AnimeDetailInfoViewState: Equatable {
    public static func == (lhs: AnimeDetailInfoViewState, rhs: AnimeDetailInfoViewState) -> Bool {
        return lhs.animeModel == rhs.animeModel
    }
}
