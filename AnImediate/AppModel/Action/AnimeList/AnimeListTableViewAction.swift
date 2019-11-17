// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AppConfig
import Foundation
import ReSwift

public struct AnimeListTableViewAction {

    public struct Initialize: Action {
        public let contentType: AnimeTableContentType
        public init(contentType: AnimeTableContentType) {
            self.contentType = contentType
        }
    }

    public struct DismissErrorAlert: Action {
        public init() {}
    }

    public struct ChangeMode: Action {
        public init() {}
    }
    
    public struct SetSearchKey: Action {
        public let searchKey: String
        public init(searchKey: String) {
            self.searchKey = searchKey
        }
    }

}
