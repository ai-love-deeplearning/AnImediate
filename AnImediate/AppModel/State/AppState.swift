//
//  AppState.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/09/22.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift

public struct AppState: StateType, Equatable {
    public internal(set) var exchangeViewState = ExchangeViewState()
}

public enum TransitionType {
    case none
    case animeList
    case search
    case home
    case exchange
    case setting
    
    public init(messageType: String) {
        switch messageType {
        case "AnimeList":
            self = .animeList
        case "Search":
            self = .search
        case "Home":
            self = .home
        case "Exchange":
            self = .exchange
        case "Setting":
            self = .setting
        default:
            self = .none
        }
    }
    
}
