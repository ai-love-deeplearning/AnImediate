//
//  AnimeDetailHeaderVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/10.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import ReSwift
import RxSwift
import RxCocoa
import FirebaseUI
import MXParallaxHeader

class AnimeDetailHeaderVC: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var animeImageView: UIImageView!
    @IBOutlet weak var backEffectView: UIVisualEffectView!
    @IBOutlet var animeImageTopConstraint: NSLayoutConstraint!
    
    let blurEffect = UIBlurEffect(style: .light)
    
    var statusBarHeight: CGFloat = 0
    var navBarHeight: CGFloat = 0
    public var imageURL = ""
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.animeListStore)
    
    private var viewState: AnimeDetailInfoViewState {
        return store.state.detailInfoViewState
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindState()
        
        parallaxHeader?.delegate = self
        parallaxHeader?.mode = .fill
        parallaxHeader?.height = ScreenConfig.animeDetailsParallaxHeaderHeight
        parallaxHeader?.minimumHeight = ScreenConfig.statusBarSize.height + ScreenConfig.navigationBarHeight
        
        backEffectView.effect = blurEffect
        
        self.backImageView.contentMode = .scaleToFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animeImageTopConstraint.constant = ScreenConfig.statusBarSize.height + ScreenConfig.navigationBarHeight
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func bindState() {
        if viewState.animeModel != nil {
            setImage()
        }
        store.animeModel
            .drive(
                onNext: { [unowned self] anime in
                    self.setImage()
            })
            .disposed(by: disposeBag)
    }
    
    private func setImage() {
        let reference = Storage.storage().reference().child("iconImages/\(viewState.animeModel!.annictID).jpg")
        let placeholderImage = UIImage(named: "pic")
        animeImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        backImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }

}

extension AnimeDetailHeaderVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        if parallaxHeader.progress > 1.0 {
            animeImageTopConstraint.isActive = true
        } else {
            if let constraint = animeImageTopConstraint {
                constraint.isActive = false
            }
        }
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
