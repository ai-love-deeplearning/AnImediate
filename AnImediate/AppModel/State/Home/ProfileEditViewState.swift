// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import AppConfig
import ReSwift

public struct ProfileEditViewState: StateType {
    
    public internal(set) var isFirstEdit = true
    public internal(set) var cropType: cropType = .icon
    public internal(set) var error: AnimediateError?
}

extension ProfileEditViewState: Equatable {
    public static func == (lhs: ProfileEditViewState, rhs: ProfileEditViewState) -> Bool {
        return lhs.isFirstEdit ==  rhs.isFirstEdit
        && lhs.cropType == rhs.cropType
        && lhs.error == rhs.error
    }
}
