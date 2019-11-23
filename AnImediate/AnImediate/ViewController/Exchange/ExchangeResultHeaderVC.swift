//
//  ExchangeResultHeaderVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import ReSwift
import RxSwift
import RxCocoa
import RealmSwift
import MXParallaxHeader

class ExchangeResultHeaderVC: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var keepCountLabel: UILabel!
    @IBOutlet weak var nowCountLabel: UILabel!
    @IBOutlet weak var doneCountLabel: UILabel!
    @IBOutlet weak var stopCountLabel: UILabel!
    
    private let store = RxStore(store: AppStore.instance.exchangeStore)
    
    private var viewState: ExchangeResultViewState {
        return store.state.resultViewState
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initParallaxHeader()
        initIconImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setViews()
    }
    
    private func initIconImageView() {
        iconImageView.layer.cornerRadius = iconImageView.frame.width * 0.5
        iconImageView.layer.shadowOffset = .zero
        iconImageView.layer.shadowColor = UIColor.black.cgColor
        iconImageView.layer.shadowOpacity = 0.6
        iconImageView.layer.shadowRadius = 4
    }
    
    private func initParallaxHeader() {
        parallaxHeader?.height = ScreenConfig.homeParallaxHeaderHeight
        parallaxHeader?.minimumHeight = ScreenConfig.statusBarSize.height + ScreenConfig.navigationBarHeight
        parallaxHeader?.mode = .fill
    }
    
    private func setViews() {
        guard let model = PeerModel.read(id: viewState.peerID).first else { return }
        idLabel.text = model.userID
        nameLabel.text = model.name
        commentLabel.text = model.comment
        iconImageView.image = model.icon
        
        let keepModel = ArchiveModel.read(uid: viewState.peerID).filter("animeStatus == %@", AnimeStatusType.keep.rawValue)
        let nowModel = ArchiveModel.read(uid: viewState.peerID).filter("animeStatus == %@", AnimeStatusType.now.rawValue)
        let doneModel = ArchiveModel.read(uid: viewState.peerID).filter("animeStatus == %@", AnimeStatusType.done.rawValue)
        let stopModel = ArchiveModel.read(uid: viewState.peerID).filter("animeStatus == %@", AnimeStatusType.stop.rawValue)
        
        keepCountLabel.text = String(keepModel.count)
        nowCountLabel.text = String(nowModel.count)
        doneCountLabel.text = String(doneModel.count)
        stopCountLabel.text = String(stopModel.count)
        
        commentLabel.sizeToFit()
        // 44+99+22+label+22
        parallaxHeader?.height = ScreenConfig.statusBarSize.height + ScreenConfig.navigationBarHeight + 165 + commentLabel.bounds.height + 22
    }
    
}

private extension RxStore where AnyStateType == ExchangeViewState {
    var state: Driver<ExchangeResultViewState> {
        return stateDriver.mapDistinct { $0.resultViewState }
    }
    
    var peerID: Driver<String> {
        return state.mapDistinct { $0.peerID }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}

