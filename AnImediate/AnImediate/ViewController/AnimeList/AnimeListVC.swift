//
//  AnimeListVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import CenteredCollectionView
import Realm
import RealmSwift
import Firebase
import FirebaseAuth
import MXParallaxHeader

class AnimeListVC: UIViewController {
    
    @IBOutlet weak var recomCollectionView: UICollectionView!
    @IBOutlet weak var thisTermCollectionView: UICollectionView!
    @IBOutlet weak var rankingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    var autoScrollTimer = Timer()
    /*
    private var recomAnimeModels = Array<AnimeModel>(repeating: AnimeModel(), count: 5) {
        didSet {
            recomCollectionView.reloadData()
            startAutoScroll(duration: 7.0)
        }
    }*/
    private var thisTermAnimeModels: [AnimeModel] = [] {
        didSet {
            thisTermCollectionView.reloadData()
        }
    }
    /*
    private var rankingAnimeModels = Array<AnimeModel>(repeating: AnimeModel(), count: 20) {
        didSet {
            rankingCollectionView.reloadData()
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecom()
        fetchThisTerm()
        fetchRanking()
        setupCCView()
        setupCV(cv: self.thisTermCollectionView)
        setupCV(cv: self.rankingCollectionView)
    }
    
    private func fetchRecom() {
        /*
        let config = Realm.Configuration(fileURL: Bundle.main.url(forResource: "anime", withExtension: "realm"),readOnly: true)
        let seedRealm = try! Realm(configuration: config)
        let works = seedRealm.objects(AnimeModel.self)
        for i in 0..<self.recomAnimeModels.count {
            self.recomAnimeModels[i] = works[Int.random(in: 0..<100)]
        }*/
    }
    
    private func fetchThisTerm() {
        /*
        let config = Realm.Configuration(fileURL: Bundle.main.url(forResource: "anime", withExtension: "realm"),readOnly: true)
        let seedRealm = try! Realm(configuration: config)
        let works = seedRealm.objects(AnimeModel.self)
        for i in 0..<works.count {
            if works[i].seasonNameText == "2019年夏" {
                self.thisTermAnimeModels.append(works[i])
            }
        }
        while self.thisTermAnimeModels.count != 20 {
            self.thisTermAnimeModels.removeLast()
        }*/
    }
    
    private func fetchRanking() {
        /*
        let config = Realm.Configuration(fileURL: Bundle.main.url(forResource: "anime", withExtension: "realm"),readOnly: true)
        let seedRealm = try! Realm(configuration: config)
        let works = seedRealm.objects(AnimeModel.self)
        for i in 0..<self.rankingAnimeModels.count {
            self.rankingAnimeModels[i] = works[i]
        }*/
    }
    
    private func setupCCView() {
        recomCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        recomCollectionView.delegate = self
        recomCollectionView.dataSource = self
        recomCollectionView.showsVerticalScrollIndicator = false
        recomCollectionView.showsHorizontalScrollIndicator = false
        recomCollectionView.register(UINib(nibName: "RecomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "recomCell")
        
        centeredCollectionViewFlowLayout = recomCollectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout
        centeredCollectionViewFlowLayout.itemSize = CGSize(width: recomCollectionView.bounds.width,
                                                           height: recomCollectionView.bounds.height)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 0
    }
    
    private func setupCV(cv: UICollectionView) {
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(UINib(nibName: "ThisTermCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "thisTermCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cv.bounds.width*0.25, height: cv.bounds.height)
        layout.minimumLineSpacing = 0.3
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        cv.collectionViewLayout = layout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toDetails":
            break
        case "fromThisTerm":
            let nextVC = segue.destination as! AnimeListCardVC
            //nextVC.works = self.thisTermAnimeModels
            nextVC.navigationItem.title = "今期アニメ"
            break
        case "fromRank":
            let nextVC = segue.destination as! AnimeListCardVC
            //nextVC.works = self.rankingAnimeModels
            nextVC.navigationItem.title = "ランキング"
            break
        default:
            break
        }
    }
}

extension AnimeListVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recomCell = recomCollectionView.dequeueReusableCell(withReuseIdentifier: "recomCell", for: indexPath) as! RecomCollectionViewCell
        var cell = thisTermCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! ThisTermCollectionViewCell
        
        switch collectionView.tag {
        case 1: break
            /*
            let recomAnimeModel = recomAnimeModels[indexPath.row]
            recomCell.bindData(work: recomAnimeModel)
            
            UserDefaults.standard.set(recomCell.animeId, forKey: "animeId")
            UserDefaults.standard.set(recomCell.imageURL, forKey: "imageURL")
            UserDefaults.standard.set(recomCell.titleLabel.text, forKey: "title")
            UserDefaults.standard.set(recomCell.seasonText, forKey: "season")*/
        case 2: break
            /*
            let thisAnimeModel = thisTermAnimeModels[indexPath.row]
            cell.bindData(work: thisAnimeModel)
            
            UserDefaults.standard.set(cell.animeId, forKey: "animeId")
            UserDefaults.standard.set(cell.imageURL, forKey: "imageURL")
            UserDefaults.standard.set(cell.titleLabel.text, forKey: "title")
            UserDefaults.standard.set(cell.seasonText, forKey: "season")*/
        case 3: break
            /*
            let rankingAnimeModel = rankingAnimeModels[indexPath.row]
            cell = rankingCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! ThisTermCollectionViewCell
            cell.bindData(work:rankingAnimeModel)
            
            UserDefaults.standard.set(cell.animeId, forKey: "animeId")
            UserDefaults.standard.set(cell.imageURL, forKey: "imageURL")
            UserDefaults.standard.set(cell.titleLabel.text, forKey: "title")
            UserDefaults.standard.set(cell.seasonText, forKey: "season")*/
        default:
            break
        }
        
        performSegue(withIdentifier: "toDetails", sender: nil)
    }
    
    func startAutoScroll(duration: TimeInterval){
        var indexPath = recomCollectionView.indexPathsForVisibleItems.sorted { $0.item < $1.item }.first ?? IndexPath(item: 0, section: 0)
        
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            indexPath.row += 1
            
            if indexPath.row == 5 {
                indexPath.row = 0
            }
            
            DispatchQueue.main.async {
                self.recomCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            }
        })
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension AnimeListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*
        self.pageControl.numberOfPages = recomAnimeModels.count
        
        switch collectionView.tag {
        case 1:
            return recomAnimeModels.count
        case 2:
            return thisTermAnimeModels.count
        case 3:
            return rankingAnimeModels.count
        default:
            break
        }*/
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recomCell = recomCollectionView.dequeueReusableCell(withReuseIdentifier: "recomCell", for: indexPath) as! RecomCollectionViewCell
        var cell = thisTermCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! ThisTermCollectionViewCell
        
        switch collectionView.tag {
        case 1: break
            /*
            let recomAnimeModel = recomAnimeModels[indexPath.row]
            recomCell.bindData(work: recomAnimeModel)*/
        case 2:
            /*
            let thisAnimeModel = thisTermAnimeModels[indexPath.row]
            cell.bindData(work: thisAnimeModel)*/
            return cell
        case 3:
            /*
            let rankingAnimeModel = rankingAnimeModels[indexPath.row]
            cell = rankingCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! ThisTermCollectionViewCell
            cell.bindData(work: rankingAnimeModel)*/
            return cell
        default:
            break
        }
        
        return recomCell
    }
}
