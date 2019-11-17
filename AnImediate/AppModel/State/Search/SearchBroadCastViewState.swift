//
//  SearchBroadCastViewState.swift
//  AppModel
//
//  Created by 川村周也 on 2019/11/17.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import ReSwift
import Realm
import RealmSwift

public struct SearchBroadCastViewState: StateType  {
    public internal(set) var searchKey = ""
    public internal(set) var error: AnimediateError?
}

extension SearchBroadCastViewState: Equatable {
    public static func == (lhs: SearchBroadCastViewState, rhs: SearchBroadCastViewState) -> Bool {
        return lhs.searchKey == rhs.searchKey
    }
}
