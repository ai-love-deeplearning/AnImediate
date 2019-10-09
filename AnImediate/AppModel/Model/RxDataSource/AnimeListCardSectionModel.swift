//
//  AnimeListCardSectionModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/04.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import RxDataSources

public struct AnimeCardSectionModel {
    public var items: [AnimeModel]
    
    public init(items: [AnimeModel]) {
        self.items = items
    }
}

extension AnimeCardSectionModel: SectionModelType {
    public typealias Item = AnimeModel
    
    public init(original: AnimeCardSectionModel, items: [AnimeCardSectionModel.Item]) {
        self = original
        self.items = items
    }
    
}
