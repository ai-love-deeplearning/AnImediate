//
//  AnimeDetailSimilarViewState.swift
//  AppModel
//
//  Created by 前田陸 on 2019/11/18.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift
import Realm
import RealmSwift

public struct AnimeDetailSimilarViewState: StateType  {
    public internal(set) var animeModel: AnimeModel?
    public internal(set) var error: AnimediateError?
}

extension AnimeDetailSimilarViewState: Equatable {
    public static func == (lhs: AnimeDetailSimilarViewState, rhs: AnimeDetailSimilarViewState) -> Bool {
        return lhs.animeModel == rhs.animeModel
    }
}
