//
//  InfoVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/10.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import RealmSwift

class InfoVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var similarCollectionView: UICollectionView!
    
    let realm = try! Realm()
    
    private var similarWorks = Array<Work>(repeating: Work(), count: 10) {
        didSet {
            similarCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = UserDefaults.standard.string(forKey: "title")!
        seasonLabel.text = "放送年：" + UserDefaults.standard.string(forKey: "season")!
        
        similarCollectionView.delegate = self
        //similarCollectionView.dataSource = self
        
        fetchSimilar()
        setupCV(cv: similarCollectionView)
    }
    
    private func fetchSimilar() {
        let works = realm.objects(Work.self)
        for i in 0..<self.similarWorks.count {
            self.similarWorks[i] = works[Int.random(in: 0..<1000)]
        }
    }
    
    private func setupCV(cv: UICollectionView) {
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(UINib(nibName: "ThisTermCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "thisTermCell")
        
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

    @IBAction func statusTFTapped(_ sender: UITextField) {
    }
}

extension InfoVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = similarCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! ThisTermCollectionViewCell
        
        let similarWork = similarWorks[indexPath.row]
        cell.bindData(work: similarWork)
        
        UserDefaults.standard.set(cell.imageURL, forKey: "imageURL")
        UserDefaults.standard.set(cell.titleLabel.text, forKey: "title")
        UserDefaults.standard.set(cell.seasonText, forKey: "season")
        
        performSegue(withIdentifier: "toDetails", sender: nil)
    }
}

extension InfoVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return similarWorks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = similarCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! ThisTermCollectionViewCell
        
        let similarWork = similarWorks[indexPath.row]
        cell.bindData(work: similarWork)
        
        return cell
    }
}
