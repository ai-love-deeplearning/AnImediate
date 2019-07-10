//
//  AnimeListVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import CenteredCollectionView
import Realm
import RealmSwift
import Firebase
import FirebaseAuth

class AnimeListVC: UIViewController {
    
    @IBOutlet weak var recomCollectionView: UICollectionView!
    @IBOutlet weak var thisTermCollectionView: UICollectionView!
    @IBOutlet weak var rankingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let realm = try! Realm()
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    var autoScrollTimer = Timer()
    var nextVCImageURL = ""
    
    private var recomWorks = Array<Work>(repeating: Work(), count: 5) {
        didSet {
            recomCollectionView.reloadData()
            startAutoScroll(duration: 7.0)
        }
    }
    private var thisTermWorks: [Work] = [] {
        didSet {
            thisTermCollectionView.reloadData()
        }
    }
    private var rankingWorks = Array<Work>(repeating: Work(), count: 20) {
        didSet {
            rankingCollectionView.reloadData()
        }
    }
    
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
        let works = realm.objects(Work.self)
        for i in 0..<self.recomWorks.count {
            self.recomWorks[i] = works[Int.random(in: 0..<100)]
        }
    }
    
    private func fetchThisTerm() {
        let works = realm.objects(Work.self)
        for i in 0..<works.count {
            if works[i].seasonNameText == "2019年春" {
                self.thisTermWorks.append(works[i])
            }
        }
    }
    
    private func fetchRanking() {
        let works = realm.objects(Work.self)
        for i in 0..<self.rankingWorks.count {
            self.rankingWorks[i] = works[i]
        }
    }
    
    private func setupCCView() {
        recomCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        recomCollectionView.delegate = self
        recomCollectionView.dataSource = self
        recomCollectionView.showsVerticalScrollIndicator = false
        recomCollectionView.showsHorizontalScrollIndicator = false
        recomCollectionView.register(UINib(nibName: "RecomCollectionViewCell",
                                           bundle: nil),
                                     forCellWithReuseIdentifier: "recomCell")
        
        centeredCollectionViewFlowLayout = recomCollectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout
        centeredCollectionViewFlowLayout.itemSize = CGSize(width: recomCollectionView.bounds.width,
                                                           height: recomCollectionView.bounds.height)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 0
    }
    
    private func setupCV(cv: UICollectionView) {
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(UINib(nibName: "ThisTermCollectionViewCell",
                                           bundle: nil),
                                     forCellWithReuseIdentifier: "thisTermCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cv.bounds.width*0.2, height: cv.bounds.height)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        cv.collectionViewLayout = layout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            
        }
    }
}

extension AnimeListVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recomCell = recomCollectionView.dequeueReusableCell(withReuseIdentifier: "recomCell", for: indexPath) as! RecomCollectionViewCell
        var cell = thisTermCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! ThisTermCollectionViewCell
        
        if collectionView.tag == 1 {
            let recomWork = recomWorks[indexPath.row]
            recomCell.bindData(work: recomWork)
            self.nextVCImageURL = recomCell.imageURL
            
        } else if collectionView.tag == 2 {
            let thisWork = thisTermWorks[indexPath.row]
            cell.bindData(work: thisWork)
            self.nextVCImageURL = cell.imageURL
            
        } else if collectionView.tag == 3 {
            let rankingWork = rankingWorks[indexPath.row]
            cell = rankingCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! ThisTermCollectionViewCell
            cell.bindData(work:rankingWork)
            self.nextVCImageURL = cell.imageURL
        }
        
        performSegue(withIdentifier: "toDetails",sender: nil)
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
        self.pageControl.numberOfPages = recomWorks.count
        
        if collectionView.tag == 1 {
            return recomWorks.count
            
        } else if collectionView.tag == 2 {
            return 20
            
        } else if collectionView.tag == 3 {
            return rankingWorks.count
            
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recomCell = recomCollectionView.dequeueReusableCell(withReuseIdentifier: "recomCell", for: indexPath) as! RecomCollectionViewCell
        var cell = thisTermCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! ThisTermCollectionViewCell
        
        if collectionView.tag == 1 {
            let recomWork = recomWorks[indexPath.row]
            recomCell.bindData(work: recomWork)
            
        } else if collectionView.tag == 2 {
            let thisWork = thisTermWorks[indexPath.row]
            cell.bindData(work: thisWork)
            return cell
            
        } else if collectionView.tag == 3 {
            let rankingWork = rankingWorks[indexPath.row]
            cell = rankingCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! ThisTermCollectionViewCell
            cell.bindData(work: rankingWork)
            return cell
        }
        
        return recomCell
    }
}
