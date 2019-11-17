//
//  AnimeGenreCellModel.swift
//  AppModel
//
//  Created by 前田陸 on 2019/11/17.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation

public struct AnimeGenreCellModel {
    public var image: UIImage
    public var genre: String
    
    public init(image: UIImage, genre: String) {
        self.image = image
        self.genre = genre
    }
}
