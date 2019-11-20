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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    private let store = RxStore(store: AppStore.instance.exchangeStore)
    
    private var viewState: ExchangeResultViewState {
        return store.state.resultViewState
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parallaxHeader?.height = ScreenConfig.homeParallaxHeaderHeight
        parallaxHeader?.mode = .fill
        
        iconImageView.layer.cornerRadius = iconImageView.frame.width * 0.5
        iconImageView.layer.shadowOffset = .zero
        iconImageView.layer.shadowColor = UIColor.black.cgColor
        iconImageView.layer.shadowOpacity = 0.6
        iconImageView.layer.shadowRadius = 4
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        parallaxHeader?.minimumHeight = ScreenConfig.statusBarSize.height + ScreenConfig.navigationBarHeight
    }
    
    private func setViews() {
        let model = PeerModel.read(id: viewState.peerID)
        nameLabel.text = model.name
        commentLabel.text = model.comment
        iconImageView.image = model.icon
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

