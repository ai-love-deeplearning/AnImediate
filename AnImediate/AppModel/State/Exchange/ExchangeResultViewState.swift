// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AppConfig
import ReSwift
import Realm
import RealmSwift

public struct ExchangeResultViewState: StateType  {
    public internal(set) var contentType: AnimeTableContentType = .currentTerm
    public internal(set) var isRegisterMode = false
    public internal(set) var error: AnimediateError?
}

extension ExchangeResultViewState: Equatable {
    public static func == (lhs: ExchangeResultViewState, rhs: ExchangeResultViewState) -> Bool {
        return lhs.contentType == rhs.contentType
        && lhs.isRegisterMode == rhs.isRegisterMode
    }
}
