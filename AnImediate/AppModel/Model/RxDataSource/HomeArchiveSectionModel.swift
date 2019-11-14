//
//  HomeArchiveSectionModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/01.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import RxDataSources

public struct HomeArchiveSectionModel {
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

extension HomeArchiveSectionModel: SectionModelType {
    public typealias Item = HomeArchiveModel
    
    public init(original: HomeArchiveSectionModel, items: [HomeArchiveSectionModel.Item]) {
        self = original
        self.items = items
    }
    
}
