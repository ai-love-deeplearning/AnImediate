// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AppConfig
import Foundation
import ReSwift

public struct HomeArchiveListViewAction {

    public struct Initialize: Action {
        public init() {}
    }

    public struct DismissErrorAlert: Action {
        public init() {}
    }

    public struct ChangeContent: Action {
        public let content: AnimeStatusType
        public init(content: AnimeStatusType) {
            self.content = content
        }
    }

}
