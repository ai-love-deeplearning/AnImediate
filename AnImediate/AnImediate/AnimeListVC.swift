//
//  AnimeListVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class AnimeListVC: UIViewController {

    @IBOutlet weak var recomScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var recomImageView: [UIImageView] = []
    
    private var works: [Work] = [] {
        didSet {
            // workImageCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWorks()
    }
    
    private func setupScrollView() {
        
        recomScrollView.delegate = self
        recomScrollView.isPagingEnabled = true // メニュー単位のスクロールを可能にする
        recomScrollView.showsHorizontalScrollIndicator = false // 水平方向のスクロールインジケータを非表示にする
    }
    
    private func fetchWorks() {
        guard let url: URL = URL(string: "https://api.annict.com/v1/works?access_token=Y4m-6I3_lqZw0NS1QtxgWX-9yHAvlIgQISLkQL6M2i0&page=30&per_page=5&sort_id=desc") else {return}
        
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

}

extension AnimeListVC: UIScrollViewDelegate {
    
}
