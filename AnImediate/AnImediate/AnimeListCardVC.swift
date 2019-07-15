//
//  AnimeListCardVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class AnimeListCardVC: UIViewController {

    @IBOutlet weak var animeListCardCV: UICollectionView!
    
    public var works = Array<Work>(repeating: Work(), count: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCV()
    }
    
    private func setupCV() {
    
        self.animeListCardCV.delegate = self
        self.animeListCardCV.dataSource = self
        self.animeListCardCV.showsVerticalScrollIndicator = false
        self.animeListCardCV.register(UINib(nibName: "AnimeListCardCVCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width*0.9, height: 130)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.animeListCardCV.collectionViewLayout = layout
    }
}

extension AnimeListCardVC: UICollectionViewDelegate {
    
}

extension AnimeListCardVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.works.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = animeListCardCV.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! AnimeListCardCVCell
        
        let work = self.works[indexPath.row]
        cell.bindData(work: work)
        
        return cell
    }
}
