// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AppConfig
import ReSwift
import Realm
import RealmSwift

public struct AnimeListTableViewState: StateType  {
    public internal(set) var contentType: AnimeTableContentType = .currentTerm
    public internal(set) var isRegisterMode = false
    public internal(set) var error: AnimediateError?
}

extension AnimeListTableViewState: Equatable {
    public static func == (lhs: AnimeListTableViewState, rhs: AnimeListTableViewState) -> Bool {
        return lhs.contentType == rhs.contentType
        && lhs.isRegisterMode == rhs.isRegisterMode
    }
}
