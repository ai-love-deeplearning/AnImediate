//
//  AnimeDetailEpisodesVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/19.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import RealmSwift

class AnimeDetailEpisodesVC: UIViewController {

    @IBOutlet weak var episodeTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var episodes: [AnimeEpisodeModel] = []
    var animeId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEpisode()
        setupTableView()
    }
    
    private func fetchEpisode() {
        // TODO:- firebaseRequestで行う
        // Realmでreadして該当データがあるか検索
        // あったらそれを表示、なかったらActionCreatorをdispatch
        // 入ってきた値をRxStoreでbindしてdatasourceに流す
        let config = Realm.Configuration(fileURL: Bundle.main.url(forResource: "anime", withExtension: "realm"),readOnly: true)
        let seedRealm = try! Realm(configuration: config)
        
        self.animeId = Int(UserDefaults.standard.string(forKey: "animeId")!)!
        let episodesResult = seedRealm.objects(AnimeEpisodeModel.self).filter("animeId == %@", self.animeId)
        
        episodesResult.forEach {
            self.episodes.append($0)
        }
        //self.episodes.sort {$0.sortNumber < $1.sortNumber}
        
        if !self.episodes.isEmpty {
            self.emptyView.isHidden = true
        }
    }
    
    private func setupTableView() {
        
        self.episodeTableView.delegate = self
        self.episodeTableView.dataSource = self
        self.episodeTableView.tableFooterView = UIView(frame: .zero)
    }
    
}

extension AnimeDetailEpisodesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = episodeTableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
        /*
        cell.textLabel?.text = self.episodes[indexPath.row].numberText + "：" + self.episodes[indexPath.row].title*/
        
        return cell
    }
}
