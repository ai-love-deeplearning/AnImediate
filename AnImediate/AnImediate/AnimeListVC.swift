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
    @IBOutlet weak var pageControl: UIPageControl!
    
    let realm = try! Realm()
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    private var autoScrollTimer = Timer()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecom()
        fetchThisTerm()
        setupCCView()
        setupThisTermCV()
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
    
    private func setupCCView() {
        centeredCollectionViewFlowLayout = recomCollectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout
        centeredCollectionViewFlowLayout.itemSize = CGSize(width: recomCollectionView.bounds.width,
                                                           height: recomCollectionView.bounds.height)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 0
        
        recomCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        recomCollectionView.delegate = self
        recomCollectionView.dataSource = self
        recomCollectionView.showsVerticalScrollIndicator = false
        recomCollectionView.showsHorizontalScrollIndicator = false
        recomCollectionView.register(UINib(nibName: "RecomCollectionViewCell",
                                           bundle: nil),
                                     forCellWithReuseIdentifier: "recomCell")
    }
    
    private func setupThisTermCV() {
        thisTermCollectionView.delegate = self
        thisTermCollectionView.dataSource = self
        thisTermCollectionView.showsHorizontalScrollIndicator = false
        thisTermCollectionView.register(UINib(nibName: "ThisTermCollectionViewCell",
                                           bundle: nil),
                                     forCellWithReuseIdentifier: "thisTermCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: thisTermCollectionView.bounds.width*0.2, height: thisTermCollectionView.bounds.height)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        thisTermCollectionView.collectionViewLayout = layout
    }
}

extension AnimeListVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recomCell = recomCollectionView.dequeueReusableCell(withReuseIdentifier: "recomCell", for: indexPath) as! RecomCollectionViewCell
        if collectionView.tag == 1 {
            let recomWork = recomWorks[indexPath.row]
            recomCell.bindData(work: recomWork)
            print(recomCell.titleLabel.text!)
        } else if collectionView.tag == 2 {
            let thisWork = thisTermWorks[indexPath.row]
            let cell = thisTermCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! ThisTermCollectionViewCell
            cell.bindData(work: thisWork)
            print(cell.titleLabel.text!)
        }
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
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recomCell = recomCollectionView.dequeueReusableCell(withReuseIdentifier: "recomCell", for: indexPath) as! RecomCollectionViewCell
        
        if collectionView.tag == 1 {
            let recomWork = recomWorks[indexPath.row]
            recomCell.bindData(work: recomWork)
        } else if collectionView.tag == 2 {
            let thisWork = thisTermWorks[indexPath.row]
            let cell = thisTermCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! ThisTermCollectionViewCell
            cell.bindData(work: thisWork)
            return cell
        }
        
        return recomCell
    }
}
