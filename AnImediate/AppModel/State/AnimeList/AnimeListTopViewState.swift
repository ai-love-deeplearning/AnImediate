// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import ReSwift
import Realm
import RealmSwift

public struct AnimeListTopViewState: StateType  {
    public internal(set) var recommend: [AnimeModel]?
    public internal(set) var currentTerm: [AnimeModel]?
    public internal(set) var ranking: [AnimeModel]?
    public internal(set) var sfGenre: [AnimeModel]?
    public internal(set) var battleGenre: [AnimeModel]?
    public internal(set) var horrorGenre: [AnimeModel]?
    public internal(set) var robotGenre: [AnimeModel]?
    public internal(set) var loveGenre: [AnimeModel]?
    public internal(set) var comedyGenre: [AnimeModel]?
    public internal(set) var dailyGenre: [AnimeModel]?
    public internal(set) var sportsGenre: [AnimeModel]?
    public internal(set) var dramaGenre: [AnimeModel]?
    public internal(set) var histGenre: [AnimeModel]?
    public internal(set) var warGenre: [AnimeModel]?
    public internal(set) var otherGenre: [AnimeModel]?
    public internal(set) var error: AnimediateError?
}

extension AnimeListTopViewState: Equatable {
    public static func == (lhs: AnimeListTopViewState, rhs: AnimeListTopViewState) -> Bool {
        return lhs.recommend == rhs.recommend
            && lhs.currentTerm == rhs.currentTerm
            && lhs.ranking == rhs.ranking
    }
}
