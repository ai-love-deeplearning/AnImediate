//
//  AnimeTableSectionModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/04.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import RxDataSources

public struct AnimeTableSectionModel {
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

extension AnimeTableSectionModel: SectionModelType {
    public typealias Item = AnimeModel
    
    public init(original: AnimeTableSectionModel, items: [AnimeTableSectionModel.Item]) {
        self = original
        self.items = items
    }
    
}
