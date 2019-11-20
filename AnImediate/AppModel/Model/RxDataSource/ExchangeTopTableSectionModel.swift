//
//  ExchangeTopTableSectionModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/11/18.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import RxDataSources

public struct ExchangeTopTableSectionModel {
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

extension ExchangeTopTableSectionModel: SectionModelType {
    public typealias Item = PeerModel
    
    public init(original: ExchangeTopTableSectionModel, items: [ExchangeTopTableSectionModel.Item]) {
        self = original
        self.items = items
    }
    
}
