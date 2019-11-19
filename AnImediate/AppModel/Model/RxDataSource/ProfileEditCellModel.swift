//
//  ProfileEditCellModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/01.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation

public struct ProfileModel {
    public var label: String
    public var content: String
    
    public init(label: String, content: String) {
        self.label = label
        self.content = content
    }
}
