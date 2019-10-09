// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AppConfig
import ReSwift
import Realm
import RealmSwift

public struct AnimeListCardViewState: StateType  {
    public internal(set) var contentType: AnimeCardContentType = .currentTerm
    public internal(set) var isRegisterMode = false
    public internal(set) var error: AnimediateError?
}

extension AnimeListCardViewState: Equatable {
    public static func == (lhs: AnimeListCardViewState, rhs: AnimeListCardViewState) -> Bool {
        return lhs.contentType == rhs.contentType
        && lhs.isRegisterMode == rhs.isRegisterMode
    }
}
