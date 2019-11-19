//
//  AnimeDetailURLViewAction.swift
//  AppModel
//
//  Created by 前田陸 on 2019/11/19.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation
import ReSwift

public struct AnimeDetailURLViewAction {

    public struct Initialize: Action {
        public let animeModel: AnimeModel
        public init(animeModel: AnimeModel) {
            self.animeModel = animeModel
        }
    }

    public struct DismissErrorAlert: Action {
        public init() {}
    }

    public struct ExampleAction1: Action {
        public init() {}
    }

}
