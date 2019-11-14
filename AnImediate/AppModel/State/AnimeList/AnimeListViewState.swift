//
//  AnimeListViewState.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/29.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift

public struct AnimeListViewState: StateType, Equatable {
     public internal(set) var topViewState = AnimeListTopViewState()
     public internal(set) var cardViewState = AnimeListCardViewState()
     public internal(set) var detailInfoViewState = AnimeDetailInfoViewState()
     public internal(set) var detailEpisodeViewState = AnimeDetailEpisodeViewState()
}
