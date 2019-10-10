//
//  AnimeDetailInfoVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/10.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift

class AnimeDetailInfoVC: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var synopsisLabel: UILabel!
    @IBOutlet private weak var seasonLabel: UILabel!
    @IBOutlet private weak var statusTextField: AnimeStatusTextField!
    @IBOutlet private weak var similarCollectionView: UICollectionView!
    
    let realm = try! Realm()
    let now = NSDate()
    let formatter = DateFormatter()
    
    var dateString = ""
    var animeId = ""
    var pickerView = UIPickerView()
    //var watchData = WatchData()
    /*
    private var similarAnimeModels = Array<AnimeModel>(repeating: AnimeModel(), count: 10) {
        didSet {
            similarCollectionView.reloadData()
        }
    }*/
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.animeListStore)
    
    private var viewState: AnimeDetailInfoViewState {
        return store.state.detailInfoViewState
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindState()
        
        /*
        let userInfo = realm.objects(PeerModel.self)
        let results = realm.objects(ArchiveModel.self).filter("animeId == %@ && userId == %@", self.animeId, userInfo[0].id)
        if results.count != 0 {
            self.statusTextField.text = results[0].animeStatus
        }
        
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        
        fetchSimilar()
        setupPickerView()
        setupCV(cv: similarCollectionView)*/
    }
    
    private func bindState() {
        
        if viewState.animeModel != nil {
            self.animeId = viewState.animeModel!.annictID
            titleLabel.text = viewState.animeModel!.title
            synopsisLabel.text = viewState.animeModel!.synopsis
            seasonLabel.text = "放送年：" + viewState.animeModel!.seasonNameText
        }
        
        store.animeModel
            .drive(
                onNext: { [unowned self] anime in
                    self.animeId = self.viewState.animeModel!.annictID
                    self.titleLabel.text = self.viewState.animeModel!.title
                    self.synopsisLabel.text = self.viewState.animeModel!.synopsis
                    self.seasonLabel.text = "放送年：" + self.viewState.animeModel!.seasonNameText
            })
            .disposed(by: disposeBag)
        
    }
    
    private func fetchSimilar() {
        /*
        let config = Realm.Configuration(fileURL: Bundle.main.url(forResource: "anime", withExtension: "realm"),readOnly: true)
        let seedRealm = try! Realm(configuration: config)
        
        let works = seedRealm.objects(AnimeModel.self)
        
        for i in 0..<self.similarAnimeModels.count {
            self.similarAnimeModels[i] = works[Int.random(in: 0..<1000)]
        }*/
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toDetails":
            break
        case "toSimilar":
            let nextVC = segue.destination as! AnimeListCardVC
            //nextVC.works = self.similarAnimeModels
            nextVC.navigationItem.title = "類似作品"
            break
        default:
            break
        }
    }
}

extension AnimeDetailInfoVC: UICollectionViewDelegate, UIPickerViewDelegate {
    
    @objc func done() {
        self.statusTextField.endEditing(true)
        
        self.formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        self.dateString = self.formatter.string(from: now as Date)
        
        /*
        if self.statusTextField.text != "" {
            let userInfo = realm.objects(PeerModel.self)
            let results = realm.objects(ArchiveModel.self).filter("animeId == %@ && userId == %@", self.animeId, userInfo[0].id)
            
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
        }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = similarCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! AnimeHorizontalCollectionViewCell
        //let similarAnimeModel = similarAnimeModels[indexPath.row]
        
        //cell.bindData(work: similarAnimeModel)
        performSegue(withIdentifier: "toDetails", sender: nil)
    }
}

extension AnimeDetailInfoVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return similarAnimeModels.count
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = similarCollectionView.dequeueReusableCell(withReuseIdentifier: "thisTermCell", for: indexPath) as! AnimeHorizontalCollectionViewCell
        //let similarAnimeModel = similarAnimeModels[indexPath.row]
        
        //cell.bindData(work: similarAnimeModel)
        
        return cell
    }
}

private extension RxStore where AnyStateType == AnimeListViewState {
    var state: Driver<AnimeDetailInfoViewState> {
        return stateDriver.mapDistinct { $0.detailInfoViewState }
    }
    
    var animeModel: Driver<AnimeModel> {
        return state.mapDistinct { $0.animeModel }.skipNil()
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
