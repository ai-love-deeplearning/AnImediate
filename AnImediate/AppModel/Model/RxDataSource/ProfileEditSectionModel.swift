//
//  ProfileEditSectionModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/01.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import RxDataSources

public struct ProfileSectionModel {
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

extension ProfileSectionModel: SectionModelType {
    public typealias Item = ProfileModel
    
    public init(original: ProfileSectionModel, items: [ProfileSectionModel.Item]) {
        self = original
        self.items = items
    }
    
}
