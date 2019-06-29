//
//  Work.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

struct Work {
    let id: Int
    let title: String
    let episodesCount: Int
    let seasonNameText: String
    let watchersCount: Int
    let reviewsCount: Int
    let imageUrl: String
    let officialSiteUrl: String
    let wikipediaUrl: String
    
    init(value: [String: Any]) {
        id = value["id"] as? Int ?? 0
        title = value["title"] as? String ?? ""
        episodesCount = value["episodesCount"] as? Int ?? 0
        seasonNameText = value["seasonNameText"] as? String ?? ""
        watchersCount = value["watchersCount"] as? Int ?? 0
        reviewsCount = value["reviewsCount"] as? Int ?? 0
        imageUrl = value["imageURL"] as? String ?? ""
        officialSiteUrl = value["officialSiteUrl"] as? String ?? ""
        wikipediaUrl = value["wikipediaUrl"] as? String ?? ""
    }
    
    init() {
        id = 0
        title = ""
        episodesCount = 0
        seasonNameText = ""
        watchersCount = 0
        reviewsCount = 0
        imageUrl = ""
        officialSiteUrl = ""
        wikipediaUrl = ""
    }
}
