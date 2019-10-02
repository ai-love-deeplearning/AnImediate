//
//  Const.swift
//  AppConfig
//
//  Created by 川村周也 on 2019/09/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation

public struct P2PConfig {
    public static let serviceType = "fun-AnImediate"
}

public struct HomeSBIdentifier {
    public static let willSee = "willSeeSB"
    public static let seeing = "seeingSB"
    public static let notSee = "notSeeSB"
    public static let saw = "sawSB"
}

public struct HomeBarTitles {
    public static let titles = ["見たい", "見てる", "見てない", "見た"]
}

public struct ProfileItem {
    public static let editLabels = ["名前", "自己紹介"]
}

public struct UIImageToData {
    public static let maxDataByte = 1024 * 1024 * 4
    // 長辺の最大サイズ
    public static let maxLongSide: CGFloat = 1024 * 2
    
    // JPEG形式の圧縮率（最低／最高／差分）
    public static let qualityMin: CGFloat = 0.05
    public static let qualityMax: CGFloat = 0.95
    public static let qualityDif: CGFloat = 0.15
    
    // 実際に使用した圧縮率
    public static let qualityUse: CGFloat = 0.0
    
}

public enum cropType {
    case icon
    case back
}

public enum AnimeStatusType: String {
    case none = "見てない"
    case did = "見た"
    case will = "見たい"
   case now = "見てる"
}
