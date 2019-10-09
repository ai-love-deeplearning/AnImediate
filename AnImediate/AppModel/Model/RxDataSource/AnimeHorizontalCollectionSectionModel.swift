//
//  AnimeHorizontalCollectionSectionModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/08.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import RxDataSources

public struct AnimeHorizontalCollectionSectionModel {
    public var items: [AnimeModel]
    
    public init(items: [AnimeModel]) {
        self.items = items
    }
}

extension AnimeHorizontalCollectionSectionModel: SectionModelType {
    public typealias Item = AnimeModel
    
    public init(original: AnimeHorizontalCollectionSectionModel, items: [AnimeHorizontalCollectionSectionModel.Item]) {
        self = original
        self.items = items
    }
    
}
