//
//  ResultVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import RealmSwift

class ResultVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userCV: UICollectionView!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCV()
    }
    
    private func setupCV() {
        self.userCV.delegate = self
        self.userCV.dataSource = self
        self.userCV.showsHorizontalScrollIndicator = false
        self.userCV.register(UINib(nibName: "ResultUserCVCell", bundle: nil), forCellWithReuseIdentifier: "userCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.userCV.bounds.width*0.2, height: self.userCV.bounds.height)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.userCV.collectionViewLayout = layout
    }
}

extension ResultVC: UICollectionViewDelegate {
    
}

extension ResultVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let userInfo = realm.objects(UserInfo.self)
        
        return userInfo.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let userInfo = realm.objects(UserInfo.self)
        let cell = userCV.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! ResultUserCVCell
        
        cell.bindData(userInfo: userInfo[indexPath.row])
        return cell
    }
}
