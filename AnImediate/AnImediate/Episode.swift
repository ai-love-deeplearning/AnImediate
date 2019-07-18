//
//  Episode.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/17.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

struct Episode {
    var id: Int
    var sortNumber: Int
    var numberText: String
    var title: String
    var animeId: Int
    var animeTitle: String
    
    init(value: [String: Any]) {
        self.id = value["id"] as? Int ?? 0
        self.sortNumber = value["sort_number"] as? Int ?? 0
        self.numberText = value["number_text"] as? String ?? ""
        self.title = value["title"] as? String ?? ""
        if let work = value["work"] as? [String: Any] {
            animeId = work["id"] as? Int ?? 0
            animeTitle = work["title"] as? String ?? ""
        } else {
            animeId = 0
            animeTitle = ""
        }
    }
    
    init() {
        id = 0
        sortNumber = 0
        numberText = ""
        title = ""
        animeId = 0
        animeTitle = ""
    }
}
