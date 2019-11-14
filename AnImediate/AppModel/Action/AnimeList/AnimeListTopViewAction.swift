// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation
import ReSwift

public struct AnimeListTopViewAction {

    public struct Initialize: Action {
        public init() {}
    }

    public struct DismissErrorAlert: Action {
        public init() {}
    }

    public struct CurrentTermRequestComplete: Action {
        public init() {}
    }

    public struct CurrentTermRequestSuccess: Action {
        let currentTerm: [AnimeModel]
        public init(currentTerm: [AnimeModel]) {
            self.currentTerm = currentTerm
        }
    }
    
    public struct RankingRequestComplete: Action {
        public init() {}
    }
    
    public struct RankingRequestSuccess: Action {
        let ranking: [AnimeModel]
        public init(ranking:[AnimeModel]) {
            self.ranking = ranking
        }
    }

}
