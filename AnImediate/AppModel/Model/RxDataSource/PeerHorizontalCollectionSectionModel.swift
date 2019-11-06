//
//  PeerHorizontalCollectionSectionModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import RxDataSources

public struct PeerHorizontalCollectionSectionModel {
    public var items: [PeerModel]
    
    public init(items: [PeerModel]) {
        self.items = items
    }
}

extension PeerHorizontalCollectionSectionModel: SectionModelType {
    public typealias Item = PeerModel
    
    public init(original: PeerHorizontalCollectionSectionModel, items: [PeerHorizontalCollectionSectionModel.Item]) {
        self = original
        self.items = items
    }
    
}
