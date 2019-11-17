//
//  AnimeGenreCollectionSectionModel.swift
//  AppModel
//
//  Created by 前田陸 on 2019/11/17.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import RxDataSources

public struct AnimeGenreCollectionSectionModel {
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

extension AnimeGenreCollectionSectionModel: SectionModelType {
    public typealias Item = AnimeModel
    
    public init(original: AnimeGenreCollectionSectionModel, items: [AnimeGenreCollectionSectionModel.Item]) {
        self = original
        self.items = items
    }
    
}
