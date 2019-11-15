//
//  AnimeListRecomCollectionSectionModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/08.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import RxDataSources

public struct AnimeListRecomCollectionSectionModel {
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

extension AnimeListRecomCollectionSectionModel: SectionModelType {
    public typealias Item = AnimeModel
    
    public init(original: AnimeListRecomCollectionSectionModel, items: [AnimeListRecomCollectionSectionModel.Item]) {
        self = original
        self.items = items
    }
    
}
