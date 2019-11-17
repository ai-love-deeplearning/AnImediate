//
//  SearchViewState.swift
//  AppModel
//
//  Created by 川村周也 on 2019/09/29.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift

public struct SearchViewState: StateType, Equatable {
    public internal(set) var broadCastState = SearchBroadCastViewState()
}
