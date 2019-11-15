// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AppConfig
import Foundation
import ReSwift

public struct ExchangeResultViewAction {

    public struct Initialize: Action {
        public let contentType: AnimeCardContentType
        public init(contentType: AnimeCardContentType) {
            self.contentType = contentType
        }
    }

    public struct DismissErrorAlert: Action {
        public init() {}
    }

    public struct ChangeMode: Action {
        public init() {}
    }

}
