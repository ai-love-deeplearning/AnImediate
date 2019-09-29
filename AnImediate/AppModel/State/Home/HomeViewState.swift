//
//  HomeViewState.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/29.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift

public struct HomeViewState: StateType {
    public internal(set) var profileEditViewState = ProfileEditViewState()
}

extension  HomeViewState: Equatable {
    public static func == (lhs: HomeViewState, rhs: HomeViewState) -> Bool {
        return lhs.profileEditViewState ==  rhs.profileEditViewState
    }
}
