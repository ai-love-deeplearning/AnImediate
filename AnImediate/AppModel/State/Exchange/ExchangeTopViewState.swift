// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import ReSwift
import Realm
import RealmSwift

public struct ExchangeTopViewState: StateType  {
    public internal(set) var isExchanged = false
    public internal(set) var error: AnimediateError?
}

extension ExchangeTopViewState: Equatable {
    public static func == (lhs: ExchangeTopViewState, rhs: ExchangeTopViewState) -> Bool {
        return lhs.isExchanged == rhs.isExchanged
    }
}
