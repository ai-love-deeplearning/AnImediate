//
//  Const.swift
//  AppConfig
//
//  Created by 川村周也 on 2019/09/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import Foundation


public struct AnimediateConfig {
    public static var dateString: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            return formatter.string(from: NSDate() as Date)
        }
    }
    // TODO:- 上のdateStringから計算してreturnするようにしたい
    public static let CurrentTerm = "2019年秋"
    
    public static let sfGenre = "SF,ファンタジー"
    public static let battleGenre = "アクション/バトル"
    public static let horrorGenre = "ホラー/サスペンス/推理"
    public static let robotGenre = "ロボット/メカ"
    public static let loveGenre = "恋愛/ラブコメ"
    public static let loveComeGenre = "恋愛、ラブコメ"
    public static let comedyGenre = "コメディ/ギャグ"
    public static let dailyGenre = "日常/ほのぼの"
    public static let sportsGenre = "スポーツ/競技"
    public static let dramaGenre = "青春/ドラマ"
    public static let histGenre = "歴史/戦記"
    public static let warGenre = "戦争/ミリタリー"
    public static let otherGenre = "その他"
}

public struct FirebaseTables {
    public static let works = "works"
    public static let episodes = "episodes"
    public static let predictions = "predictions_1"
}

public struct FirebaseWorks {
    public static let anikoreID = "anikoreId"
    public static let animeID = "animeId"
    public static let cast = "cast"
    public static let company = "company"
    public static let genre = "genre"
    public static let episodesCount = "episodesCount"
    public static let imageURL = "imageUrl"
    public static let manager = "manager"
    public static let officialSiteURL = "officialSiteUrl"
    public static let reviewsCount = "reviewsCount"
    public static let seasonNameText = "seasonNameText"
    public static let synopsis = "synopsis"
    public static let syobocalTid = "syobocalTid"
    public static let title = "title"
    public static let watchersCount = "watchersCount"
    public static let wikipediaURL = "wikipediaUrl"
}

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
    public static let titles = ["見たい", "見てる", "視聴済", "中断"]
}

public struct ProfileItem {
    public static let editLabels = ["ID", "名前", "コメント"]
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
    case none = ""
    case keep = "見たい"
    case now = "見てる"
    case done = "視聴済"
    case stop = "中断"
}

public enum ExchangeResultType: String {
    case none = ""
    case onlyMe = "あなたのみ"
    case onlyYou = "相手のみ"
    case both = "二人とも"
    case reccomend = "おすすめ"
}

public struct AnimeStatusPickerItems {
    public static let items = ["", "見たい", "見てる", "視聴済", "中断"]
}

public enum AnimeTableContentType: String {
    case currentTerm = "今期"
    case ranking = "ランキング"
    case similar = "似ている作品"
    case broadcast = "放送年"
    case sfGenre = "SF/ファンタジー"
    case battleGenre = "アクション/バトル"
    case horrorGenre = "ホラー/サスペンス/推理"
    case robotGenre = "ロボット/メカ"
    case loveGenre = "恋愛/ラブコメ"
    case comedyGenre = "コメディ/ギャグ"
    case dailyGenre = "日常/ほのぼの"
    case sportsGenre = "スポーツ/競技"
    case dramaGenre = "青春/ドラマ"
    case histGenre = "歴史/戦記"
    case warGenre = "戦争/ミリタリー"
    case otherGenre = "その他"
}

public struct ResultBarTitles {
    public static let titles = ["おすすめ", "あなたのみ", "相手のみ", "二人とも"]
}

public struct ScreenConfig {
    // 画面サイズ
    public static let mainBoundSize: CGSize = UIScreen.main.bounds.size
    // 解像度
    public static let mainNativeBoundSize: CGSize = UIScreen.main.nativeBounds.size
    // 画面の倍率
    public static let mainScale: CGFloat = UIScreen.main.scale
    
    // ステータスバーサイズ
    public static let statusBarSize: CGSize = UIApplication.shared.statusBarFrame.size
    // ナビゲーションバー高さ
    public static let navigationBarHeight: CGFloat = 44
    
    // ホーム画面のパラレルヘッダーの高さ
    public static let homeParallaxHeaderHeight: CGFloat = (mainBoundSize.width * 0.8) + statusBarSize.height + navigationBarHeight
    
    public static let animeDetailsParallaxHeaderHeight: CGFloat = 242 + statusBarSize.height + navigationBarHeight
}

