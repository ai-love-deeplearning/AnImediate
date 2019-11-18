//
//  AnimeDetailURLViewState.swift
//  AppModel
//
//  Created by 前田陸 on 2019/11/19.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift
import Realm
import RealmSwift

public struct AnimeDetailURLViewState: StateType  {
    public internal(set) var animeModel: AnimeModel?
    public internal(set) var error: AnimediateError?
}

extension AnimeDetailURLViewState: Equatable {
    public static func == (lhs: AnimeDetailURLViewState, rhs: AnimeDetailURLViewState) -> Bool {
        return lhs.animeModel == rhs.animeModel
    }
}
