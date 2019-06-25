//
//  AnimeListVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import CenteredCollectionView

class AnimeListVC: UIViewController {
    
    @IBOutlet weak var recomCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var autoScrollTimer = Timer()
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    private var works: [Work] = [] {
        didSet {
            recomCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWorks()
        setupCCView()
        startAutoScroll(duration: 7.0)
    }
    
    private func fetchWorks() {
        guard let url: URL = URL(string: "https://api.annict.com/v1/works?access_token=Y4m-6I3_lqZw0NS1QtxgWX-9yHAvlIgQISLkQL6M2i0&page=4&per_page=5&sort_watchers_count=desc") else {return}
        
        let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler:
        {data, response, error in
            do {
                guard let data = data else {return}
                guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {return}
                guard let info = jsonArray["works"] as? [Any] else {return}
                let worksJson = info.compactMap { (json) -> [String: Any]? in
                    return json as? [String: Any]
                }
                let works = worksJson.map { (worksJson: [String: Any]) -> Work in
                    return Work(json: worksJson)
                }
                DispatchQueue.main.async(execute: {
                    self.works = works
                    print(self.works)
                })
            }
            catch {
                print(error)
            }
        })
        task.resume() // 実行
    }
    
    private func setupCCView() {
        centeredCollectionViewFlowLayout = recomCollectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout
        
        recomCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        recomCollectionView.delegate = self
        recomCollectionView.dataSource = self
        
        recomCollectionView.register(UINib(nibName: "RecomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "recomCell")
        
        centeredCollectionViewFlowLayout.itemSize = CGSize(width: recomCollectionView.bounds.width, height: recomCollectionView.bounds.height)
        
        centeredCollectionViewFlowLayout.minimumLineSpacing = 0
        
        recomCollectionView.showsVerticalScrollIndicator = false
        recomCollectionView.showsHorizontalScrollIndicator = false
    }
}

extension AnimeListVC: UICollectionViewDelegate {
    
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
        self.pageControl.numberOfPages = works.count
        
        return works.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recomCollectionView.dequeueReusableCell(withReuseIdentifier: "recomCell", for: indexPath) as! RecomCollectionViewCell
        let work = works[indexPath.row]
        cell.bindData(work: work)
        return cell
    }
}
