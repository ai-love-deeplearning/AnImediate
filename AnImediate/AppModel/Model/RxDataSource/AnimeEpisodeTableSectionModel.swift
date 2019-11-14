//
//  AnimeEpisodeTableSectionModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/11.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import RxDataSources

public struct AnimeEpisodeTableSectionModel {
    public var items: [AnimeEpisodeModel]
    
    public init(items: [AnimeEpisodeModel]) {
        self.items = items
    }
}

extension AnimeEpisodeTableSectionModel: SectionModelType {
    public typealias Item = AnimeEpisodeModel
    
    public init(original: AnimeEpisodeTableSectionModel, items: [AnimeEpisodeTableSectionModel.Item]) {
        self = original
        self.items = items
    }
    
}
