// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AppConfig
import Foundation
import ReSwift

public struct ProfileEditViewAction {

    public struct Initialize: Action {
        public init() {}
    }

    public struct DismissErrorAlert: Action {
        public init() {}
    }

    public struct CangeCropType: Action {
        public let cropType: cropType
        public init(cropType: cropType) {
            self.cropType = cropType
        }
    }
    
    public struct Registered: Action {
        public init() {}
    }
/*
    public struct ExampleAction2: Action {
        public let member: Type
        public init(member: Type) {
            self.member = member
        }
    }*/

}
