//
//  AnimeListCardVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import RealmSwift

class AnimeListCardVC: UIViewController {

    @IBOutlet weak var animeListCardCV: UICollectionView!
    
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var statusTextField: UITextField!
    
    private var isRegister: Bool = false
    
    public var works = Array<Work>(repeating: Work(), count: 20)
    
    let realm = try! Realm()
    let now = NSDate()
    let formatter = DateFormatter()
    private let statusList = ["", "見たい", "見てる", "見た", "見てない"]
    var dateString = ""
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCV()
        setupPickerView()
        floatingView.layer.cornerRadius = floatingView.frame.height / 3
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登録", style: .plain, target: self, action: #selector(changeRegisterMode))
    }
    
    private func setupPickerView() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        let doneItem = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(done))
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
    
    @objc func changeRegisterMode() {
        if isRegister {
            isRegister = false
            floatingView.isHidden = true
            self.navigationItem.rightBarButtonItem!.tintColor = .deepMagenta()
            self.navigationItem.rightBarButtonItem!.title = "登録"
            if animeListCardCV.indexPathsForSelectedItems!.isEmpty {
                
            } else {
                animeListCardCV.indexPathsForSelectedItems?.forEach{
                    let cell = animeListCardCV.dequeueReusableCell(withReuseIdentifier: "cardCell", for: $0) as! AnimeListCardCVCell
                    cell.layer.borderColor = UIColor.clear.cgColor
                    cell.layer.borderWidth = 0
                    animeListCardCV.deselectItem(at: $0, animated: false)
                }
                animeListCardCV.reloadData()
            }
            animeListCardCV.allowsMultipleSelection = false
        } else {
            isRegister = true
            floatingView.isHidden = false
            self.navigationItem.rightBarButtonItem!.tintColor = .lightGray
            self.navigationItem.rightBarButtonItem!.title = "キャンセル"
            // 複数選択可にする
            animeListCardCV.allowsMultipleSelection = true
            
        }
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        self.formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        self.dateString = self.formatter.string(from: now as Date)
        if animeListCardCV.indexPathsForSelectedItems!.isEmpty {
            changeRegisterMode()
            return
        }
        animeListCardCV.indexPathsForSelectedItems!.forEach{
            
            let work = self.works[$0.row]
            
            let watchData = WatchData()
            
            if self.statusTextField.text != "" {
                let userInfo = realm.objects(UserInfo.self)
                let results = realm.objects(WatchData.self).filter("animeId == %@ && userId == %@", work.animeId, userInfo[0].id)
                
                if results.isEmpty {
                    watchData.id = NSUUID().uuidString
                    watchData.userId = userInfo[0].id
                    watchData.animeId = work.animeId
                    watchData.animeStatus = self.statusTextField.text ?? ""
                    watchData.createdAt = self.dateString
                    
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
        
        if self.statusTextField.text! == "" {
            showAlert(title: "エラー", message: "ステータスを設定してください")
        } else {
            let msg: String = "\(self.statusTextField.text!)に \(String(animeListCardCV.indexPathsForSelectedItems!.count))件のデータを登録しました"
            showAlert(title: "登録", message: msg)
        }
        
        changeRegisterMode()
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: {
            // アラートを閉じる
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
        }
    }
}

extension AnimeListCardVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        if isRegister {
            let cell = collectionView.cellForItem(at: indexPath) as! AnimeListCardCVCell
            cell.layer.borderColor = UIColor.deepMagenta().cgColor
            cell.layer.borderWidth = 2
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! AnimeListCardCVCell
            let work = works[indexPath.row]
            cell.bindData(work: work)
            
            UserDefaults.standard.set(cell.animeId, forKey: "animeId")
            UserDefaults.standard.set(cell.imageURL, forKey: "imageURL")
            UserDefaults.standard.set(cell.titleLabel.text, forKey: "title")
            UserDefaults.standard.set(cell.seasonText, forKey: "season")
            collectionView.deselectItem(at: indexPath, animated: false)
            performSegue(withIdentifier: "toDetails", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AnimeListCardCVCell
        if isRegister {
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0
        }
    }
    
}

extension AnimeListCardVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.works.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = animeListCardCV.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! AnimeListCardCVCell
        if cell.isSelected {
            cell.layer.borderColor = UIColor.deepMagenta().cgColor
            cell.layer.borderWidth = 2
        } else {
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0
        }
        
        let work = self.works[indexPath.row]
        cell.bindData(work: work)
        
        return cell
    }
}

extension AnimeListCardVC: UIPickerViewDelegate, UIPickerViewDataSource {
    @objc func done() {
        self.statusTextField.endEditing(true)
    }
    
    @objc func cancel() {
        self.statusTextField.endEditing(true)
        self.statusTextField.text = ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.statusTextField.text = statusList[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.statusList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.statusList[row]
    }
}
