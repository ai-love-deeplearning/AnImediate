//
//  HomeNotSeeVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import RealmSwift

class HomeNotSeeVC: UIViewController {

    @IBOutlet weak var cardCV: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    
    let realm = try! Realm()
    
    public var works: [Work] = [] {
        didSet {
            cardCV.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWork()
        setupCV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchWork()
    }
    
    private func fetchWork() {
        /*
        var work = [Work]()
        
        let userInfo = realm.objects(PeerModel.self)
        let myResults = realm.objects(ArchiveModel.self).filter("userId == %@ && animeStatus == '見てない'", userInfo[0].id)
        
        for i in 0..<myResults.count {
            let config = Realm.Configuration(fileURL: Bundle.main.url(forResource: "anime", withExtension: "realm"),readOnly: true)
            let seedRealm = try! Realm(configuration: config)
            
            let workResults = seedRealm.objects(Work.self).filter("animeId == %@", myResults[i].animeId)
            if workResults.isEmpty {
                
            } else {
                work.append(workResults[0])
            }
        }
        self.works = work
        
        if self.works.count == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
        
        work = [Work]()
 */
    }
    
    private func setupCV() {
        
        self.cardCV.delegate = self
        self.cardCV.dataSource = self
        self.cardCV.showsVerticalScrollIndicator = false
        self.cardCV.register(UINib(nibName: "AnimeListCardCVCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width*0.9, height: 130)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.cardCV.collectionViewLayout = layout
    }
    @IBAction func toAnimeListBtnTapped(_ sender: Any) {
        tabBarController?.selectedViewController = tabBarController?.viewControllers?[2];
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
        }
    }
}

extension HomeNotSeeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = cardCV.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! AnimeListCardCVCell
        
        let work = works[indexPath.row]
        cell.bindData(work: work)
        
        UserDefaults.standard.set(cell.animeId, forKey: "animeId")
        UserDefaults.standard.set(cell.imageURL, forKey: "imageURL")
        UserDefaults.standard.set(cell.titleLabel.text, forKey: "title")
        UserDefaults.standard.set(cell.seasonText, forKey: "season")
        
        performSegue(withIdentifier: "toDetails", sender: nil)
    }
}

extension HomeNotSeeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.works.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardCV.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! AnimeListCardCVCell
        
        let work = self.works[indexPath.row]
        cell.bindData(work: work)
        
        return cell
    }
}
