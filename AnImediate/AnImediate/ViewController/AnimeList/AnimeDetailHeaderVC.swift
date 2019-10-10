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
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        
        parallaxHeader?.delegate = self
        parallaxHeader?.height = 242
        parallaxHeader?.mode = .fill
        parallaxHeader?.minimumHeight = statusBarHeight + navBarHeight
        
        backEffectView.effect = blurEffect
        
        self.backImageView.contentMode = .scaleToFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animeImageTopConstraint.constant = statusBarHeight+navBarHeight
    }
    
    private func bindState() {
        if viewState.animeModel != nil {
            self.imageURL = viewState.animeModel!.imageUrl
            setIconImageView(imageUrlString: imageURL)
        }
        store.animeModel
            .drive(
                onNext: { [unowned self] anime in
                    self.imageURL = anime.imageUrl
                    self.setIconImageView(imageUrlString: self.imageURL)
            })
            .disposed(by: disposeBag)
    }
    
    private func setIconImageView(imageUrlString: String) {
        guard let iconImageUrl = URL(string: imageUrlString) else {return}
        let session = URLSession(configuration: .default)
        
        let downloadImageTask = session.dataTask(with: iconImageUrl) {(data, response, error) in
            guard let imageData = data else {return}
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async(execute: {
                self.animeImageView.image = image
                self.backImageView.image = image
            })
            
        }
        downloadImageTask.resume()
    }
}

extension AnimeDetailHeaderVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        if parallaxHeader.progress > 1.359 {
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
