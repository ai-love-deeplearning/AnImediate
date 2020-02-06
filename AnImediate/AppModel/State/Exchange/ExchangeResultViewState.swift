// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AppConfig
import ReSwift
import Realm
import RealmSwift

public struct ExchangeResultViewState: StateType  {
    public internal(set) var peerID = ""
    public internal(set) var content = ExchangeResultType.reccomend
    public internal(set) var error: AnimediateError?
}

extension ExchangeResultViewState: Equatable {
    public static func == (lhs: ExchangeResultViewState, rhs: ExchangeResultViewState) -> Bool {
        return lhs.peerID == rhs.peerID
            && lhs.content == rhs.content
    }
}
