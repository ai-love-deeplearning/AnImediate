//
//  ProfileEditCellModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/01.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation

public struct ProfileModel {
    public var name: String
    public var comment: String
    
    public init(name: String, comment: String) {
        self.name = name
        self.comment = comment
    }
}
