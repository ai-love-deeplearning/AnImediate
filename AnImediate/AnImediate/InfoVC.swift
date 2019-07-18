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
    let now = NSDate()
    let formatter = DateFormatter()
    let statusList = ["", "見たい", "見てる", "見た", "見てない"]
    
    var dateString = ""
    var animeId = ""
    var pickerView = UIPickerView()
    var watchData = WatchData()
    
    private var similarWorks = Array<Work>(repeating: Work(), count: 10) {
        didSet {
            similarCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animeId = UserDefaults.standard.string(forKey: "animeId")!
        titleLabel.text = UserDefaults.standard.string(forKey: "title")!
        seasonLabel.text = "放送年：" + UserDefaults.standard.string(forKey: "season")!
        
        let userInfo = realm.objects(UserInfo.self)
        let results = realm.objects(WatchData.self).filter("animeId == %@ && userId == %@", self.animeId, userInfo[0].id)
        if results.count != 0 {
            self.statusTextField.text = results[0].animeStatus
        }
        
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        
        fetchSimilar()
        setupPickerView()
        setupCV(cv: similarCollectionView)
    }
    
    private func fetchSimilar() {
        let config = Realm.Configuration(fileURL: Bundle.main.url(forResource: "anime", withExtension: "realm"),readOnly: true)
        let seedRealm = try! Realm(configuration: config)
        
        let works = seedRealm.objects(Work.self)
        
        for i in 0..<self.similarWorks.count {
            self.similarWorks[i] = works[Int.random(in: 0..<1000)]
        }
    }
    
    private func setupPickerView() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        let doneItem = UIBarButtonItem(title: "登録", style: .done, target: self, action: #selector(done))
        let blankItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancel))
        
        doneItem.tintColor = .deepMagenta()
        cancelItem.tintColor = .deepMagenta()
        toolbar.backgroundColor = .white
        toolbar.setItems([cancelItem, blankItem, doneItem], animated: true)
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.showsSelectionIndicator = true
        self.pickerView.backgroundColor = .white
        
        self.statusTextField.inputView = pickerView
        self.statusTextField.inputAccessoryView = toolbar
    }
    
    private func setupCV(cv: UICollectionView) {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: cv.bounds.width*0.25, height: cv.bounds.height)
        layout.minimumLineSpacing = 0.3
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(UINib(nibName: "ThisTermCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "thisTermCell")
        cv.collectionViewLayout = layout
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cancel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
        }
    }
}

extension InfoVC: UICollectionViewDelegate, UIPickerViewDelegate {
    
    @objc func done() {
        self.statusTextField.endEditing(true)
        
        self.formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        self.dateString = self.formatter.string(from: now as Date)
        
        if self.statusTextField.text != "" {
            let userInfo = realm.objects(UserInfo.self)
            let results = realm.objects(WatchData.self).filter("animeId == %@ && userId == %@", self.animeId, userInfo[0].id)
            
            if results.isEmpty {
                self.watchData.id = NSUUID().uuidString
                self.watchData.userId = userInfo[0].id
                self.watchData.animeId = self.animeId
                self.watchData.animeStatus = self.statusTextField.text ?? ""
                self.watchData.createdAt = self.dateString
                
                try! realm.write {
                    realm.add(watchData)
                }
                
            } else {
                try! realm.write {
                    results[0].animeStatus = self.statusTextField.text ?? ""
                    results[0].udatedAt = self.dateString
                }
            }
        }
    }
    
    @objc func cancel() {
        self.statusTextField.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.statusTextField.text = statusList[row]
    }
    
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

extension InfoVC: UICollectionViewDataSource, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.statusList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.statusList[row]
    }
    
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
