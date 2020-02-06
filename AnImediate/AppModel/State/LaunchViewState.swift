//
//  LaunchViewState.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/09.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift
import Realm
import RealmSwift

public struct LaunchViewState: StateType  {
    public internal(set) var isAnimeFetched = false
    public internal(set) var isEpisodeFetched = false
    public internal(set) var isPredictionFetched = false
    public internal(set) var error: AnimediateError?
}

extension LaunchViewState: Equatable {
    public static func == (lhs: LaunchViewState, rhs: LaunchViewState) -> Bool {
        return lhs.isAnimeFetched == rhs.isAnimeFetched
            && lhs.isEpisodeFetched == rhs.isEpisodeFetched
            && lhs.isPredictionFetched == rhs.isPredictionFetched
    }
}
