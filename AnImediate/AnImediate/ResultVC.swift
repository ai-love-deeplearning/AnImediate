//
//  ResultVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import MXParallaxHeader
import RealmSwift

protocol ResultHeaderDelegate {
    func reload()
}

protocol ResultScrollDelegate {
    func reload()
}

class ResultVC: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userCV: UICollectionView!
    
    var headerDelegate: ResultHeaderDelegate?
    var scrollDelegate: ResultScrollDelegate?
    var resultUserInfo: [UserInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCV()
        fetchUserInfo()
        
        if !self.resultUserInfo.isEmpty {
            UserDefaults.standard.set(self.resultUserInfo[0].id, forKey: "userID")
        }
        UserDefaults.standard.set(0, forKey: "userNum")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserInfo()
        userCV.reloadData()
    }
    
    private func fetchUserInfo() {
        let realm = try! Realm()
        let userInfo = realm.objects(UserInfo.self)
        var result = [UserInfo]()
        
        if userInfo.count == 1 {
            self.containerView.isHidden = true
        }
        
        for user in (userInfo).reversed() {
            result.append(user)
        }
        result.removeLast()
        
        self.resultUserInfo = result
        result = [UserInfo]()
    }
    
    private func setupCV() {
        self.userCV.delegate = self
        self.userCV.dataSource = self
        self.userCV.showsHorizontalScrollIndicator = false
        self.userCV.register(UINib(nibName: "ResultUserCVCell", bundle: nil), forCellWithReuseIdentifier: "userCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.userCV.bounds.width*0.3, height: self.userCV.bounds.height)
        layout.minimumLineSpacing = 0.3
        layout.scrollDirection = .horizontal
        self.userCV.collectionViewLayout = layout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContainer" {
            let next = segue.destination as! MXResultScrollVC
            next.resultVC = self
        }
    }
}

extension ResultVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = userCV.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! ResultUserCVCell
        cell.bindData(userInfo: self.resultUserInfo[indexPath.row])
        
        let selectCell = collectionView.cellForItem(at: indexPath) as! ResultUserCVCell
        selectCell.iconImageView.layer.borderWidth = 1
        
        UserDefaults.standard.set(self.resultUserInfo[indexPath.row].id, forKey: "userID")
        UserDefaults.standard.set(indexPath.row, forKey: "userNum")
        
        self.headerDelegate?.reload()
        self.scrollDelegate?.reload()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let deSelectCell = collectionView.cellForItem(at: indexPath) as! ResultUserCVCell
        deSelectCell.iconImageView.layer.borderWidth = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ResultVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.resultUserInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = userCV.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! ResultUserCVCell
        
        cell.bindData(userInfo: self.resultUserInfo[indexPath.row])
        cell.iconImageView.layer.borderWidth = 0
        
        return cell
    }
}
