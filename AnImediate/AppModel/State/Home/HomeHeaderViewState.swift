// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import ReSwift
import Realm
import RealmSwift

public struct HomeHeaderViewState: StateType  {
    public internal(set) var exampleState1 = false
    public internal(set) var exampleState2 = false
    public internal(set) var error: AnimediateError?
}

extension HomeHeaderViewState: Equatable {
    public static func == (lhs: HomeHeaderViewState, rhs: HomeHeaderViewState) -> Bool {
    return lhs.exampleState1 == rhs.exampleState1
    && lhs.exampleState2 == rhs.exampleState2
    }
}
