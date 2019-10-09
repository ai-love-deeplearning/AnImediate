//
//  AnimeCardCellModel.swift
//  AppModel
//
//  Created by 川村周也 on 2019/10/04.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation

public struct AnimeCardModel {
    public var title: String
    public var synopsis: String
    public var season: String
    public var image: UIImage
    public var registerCount: String
    
    public init(title: String, synopsis: String, season: String, image: UIImage, registerCount: String) {
        self.title = title
        self.synopsis = synopsis
        self.season = season
        self.image = image
        self.registerCount = registerCount
    }
}
