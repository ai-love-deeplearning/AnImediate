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
    
    init(json: [String: Any]) {
        id = json["id"] as? Int ?? 0
        title = json["title"] as? String ?? ""
        episodesCount = json["episodes_count"] as? Int ?? 0
        seasonNameText = json["season_name_text"] as? String ?? ""
        watchersCount = json["watchers_count"] as? Int ?? 0
        reviewsCount = json["reviews_count"] as? Int ?? 0
        if let images = json["images"] as? [String: Any] {
            imageUrl = images["recommended_url"] as? String ?? ""
        } else {
            imageUrl = ""
        }
        officialSiteUrl = json["official_site_url"] as? String ?? ""
        wikipediaUrl = json["wikipedia_url"] as? String ?? ""
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
