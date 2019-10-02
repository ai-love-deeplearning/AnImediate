// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AppConfig
import ReSwift
import Realm
import RealmSwift

public struct HomeArchiveListViewState: StateType  {
    public internal(set) var statusType: AnimeStatusType = .none
    public internal(set) var error: AnimediateError?
}

extension HomeArchiveListViewState: Equatable {
    public static func == (lhs: HomeArchiveListViewState, rhs: HomeArchiveListViewState) -> Bool {
        return lhs.statusType == rhs.statusType
    }
}
