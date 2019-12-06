// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AppConfig
import Foundation
import ReSwift

public struct ExchangeResultViewAction {

    public struct Initialize: Action {
        public let peerID: String
        public init(peerID: String) {
            self.peerID = peerID
        }
    }

    public struct DismissErrorAlert: Action {
        public init() {}
    }
    
    public struct ChangeContent: Action {
        public let content: ExchangeResultType
        public init(content: ExchangeResultType) {
            self.content = content
        }
    }

}
