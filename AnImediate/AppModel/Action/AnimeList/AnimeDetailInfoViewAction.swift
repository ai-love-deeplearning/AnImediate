// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation
import ReSwift

public struct AnimeDetailInfoViewAction {

    public struct Initialize: Action {
        public let animeModel: AnimeModel
        public init(animeModel: AnimeModel) {
            self.animeModel = animeModel
        }
    }

    public struct DismissErrorAlert: Action {
        public init() {}
    }

    public struct ExampleAction1: Action {
        public init() {}
    }

}
