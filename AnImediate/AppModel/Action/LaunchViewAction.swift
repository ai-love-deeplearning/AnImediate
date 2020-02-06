//
//  LaunchViewAction.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/09.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

public struct LaunchViewAction {
    
    public struct Initialize: Action {
        public init() {}
    }
    
    public struct FetchAllAnimeCompleted: Action {
        public init() {}
    }
    
    public struct FetchAllEpisodeCompleted: Action {
        public init() {}
    }
    
    public struct FetchAllPredictionCompleted: Action {
        public init() {}
    }
    
    public struct FetchAllAnimeSuccess: Action {
        public init() {}
    }
    
    public struct FetchAllEpisodeSuccess: Action {
        public init() {}
    }
    
    public struct FetchAllPredictionSuccess: Action {
        public init() {}
    }
    
}
