//
//  AnimeListVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import CenteredCollectionView
import Firebase
import FirebaseAuth

class AnimeListVC: UIViewController {
    
    @IBOutlet weak var recomCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var ref:DatabaseReference!
    
    private var autoScrollTimer = Timer()
    private var activityIndicatorView = UIActivityIndicatorView()
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    //private var imageURL: [String:String] = [:]
    private var works: [Work] = []
    private var recomWorks = Array<Work>(repeating: Work(), count: 5) {
        didSet {
            self.activityIndicatorView.stopAnimating()
            recomCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        referDB()
        setupCCView()
        setupIndicator()
        startAutoScroll(duration: 7.0)
    }
    
    private func referDB() {
        ref = Database.database().reference()
        ref.child("works").observe(.value, with: { (snapshot) in
            guard let info = snapshot.value as? [Any] else {return}
            let value = info.compactMap { (info) -> [String: Any]? in
                return info as? [String: Any]
            }
            let works = value.map { (value: [String: Any]) -> Work in
                return Work(value: value)
            }
            DispatchQueue.main.async(execute: {
                self.works = works
                for i in 0..<self.recomWorks.count {
                    self.recomWorks[i] = works[Int.random(in: 0..<self.works.count)]
                }
            })
        }) { (error) in
            print(error)
        }
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
    
    private func setupIndicator() {
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        guard let navBarHeight = self.navigationController?.navigationBar.frame.size.height else {return}
        activityIndicatorView.center = CGPoint(x: recomCollectionView.center.x, y: recomCollectionView.center.y - (statusBarHeight+navBarHeight))
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .deepMagenta()
        recomCollectionView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    /*func getJSONData() throws -> Data? {
     guard let path = Bundle.main.path(forResource: "imageURL", ofType: "json") else { return nil }
     let url = URL(fileURLWithPath: path)
     
     return try Data(contentsOf: url)
     }
     
     func setImage() {
     guard let data = try? getJSONData() else { return }
     guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: String] else {return}
     self.imageURL = json
     
     }
    
    private func fetchAPI() {
        for i in 1..<136 {
            guard let url: URL = URL(string: "https://api.annict.com/v1/works?access_token=Y4m-6I3_lqZw0NS1QtxgWX-9yHAvlIgQISLkQL6M2i0&page=\(i)&per_page=50&sort_watchers_count=desc") else {return}
            
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
                        return Work(value: worksJson)
                    }
                    DispatchQueue.main.async(execute: {
                        self.works = works
                        let count = 50*(i-1)
                        for j in 0..<self.works.count {
                            self.ref.child("works").child("\(j+1+count)").child("imageURL").setValue(self.imageURL["\(self.works[j].id)"])
                            
                            self.ref.child("works").child("\(j+1+count)").child("id").setValue(self.works[j].id)
                            self.ref.child("works").child("\(j+1+count)").child("title").setValue(self.works[j].title)
                            self.ref.child("works").child("\(j+1+count)").child("episodesCount").setValue(self.works[j].episodesCount)
                            self.ref.child("works").child("\(j+1+count)").child("seasonNameText").setValue(self.works[j].seasonNameText)
                            self.ref.child("works").child("\(j+1+count)").child("watchersCount").setValue(self.works[j].watchersCount)
                            self.ref.child("works").child("\(j+1+count)").child("reviewsCount").setValue(self.works[j].reviewsCount)
                            self.ref.child("works").child("\(j+1+count)").child("officialSiteUrl").setValue(self.works[j].officialSiteUrl)
                            self.ref.child("works").child("\(j+1+count)").child("wikipediaUrl").setValue(self.works[j].wikipediaUrl)
                        }
                    })
                }
                catch {
                    print(error)
                }
            })
            task.resume() // 実行
        }
    }*/
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
        self.pageControl.numberOfPages = recomWorks.count
        
        return recomWorks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recomCollectionView.dequeueReusableCell(withReuseIdentifier: "recomCell", for: indexPath) as! RecomCollectionViewCell
        let work = recomWorks[indexPath.row]
        cell.bindData(work: work)
        
        return cell
    }
}
