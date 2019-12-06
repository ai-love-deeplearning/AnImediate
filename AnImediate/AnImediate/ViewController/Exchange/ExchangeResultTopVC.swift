//
//  ExchangeResultTopVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import Tabman
import Pageboy
import ReSwift
import RxSwift
import RxCocoa

class ExchangeResultTopVC: TabmanViewController {
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.exchangeStore)
    
    private var viewState: ExchangeResultViewState {
        return store.state.resultViewState
    }
    
    // ページングメニューに対応したビューコントローラ
    private lazy var viewControllers: [UIViewController] = {
        [
            StoryboardScene.ExchangeResult.exchangeArchiveList.instantiate(),
            StoryboardScene.ExchangeResult.exchangeArchiveList.instantiate(),
            StoryboardScene.ExchangeResult.exchangeArchiveList.instantiate(),
            StoryboardScene.ExchangeResult.exchangeArchiveList.instantiate()
        ]
    }()

    var currentPage: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        initBars()
    }
    
    private func initBars() {
        let bar = TMBar.ButtonBar()
        bar.indicator.tintColor = .MainThema
        bar.indicator.weight = .light
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit
        bar.layout.view.backgroundColor = .white
        bar.buttons.customize { (button) in
            // 通常時の色
            button.tintColor = .lightGray
//            button.font = UIFont(name: "Hiragino Maru Gothic ProN", size: UIFont.labelFontSize)!
            // 選択時の色
            button.selectedTintColor = .MainThema
            
        }
        
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func indexChangeStatus(_ index: Int) {
        var status = ExchangeResultType.reccomend
        switch index {
        case 0:
            status = ExchangeResultType.reccomend
        case 1:
            status = ExchangeResultType.onlyMe
        case 2:
         status = ExchangeResultType.onlyYou
        case 3:
         status = ExchangeResultType.both
        default:
         status = ExchangeResultType.none
        }
        self.store.dispatch(ExchangeResultViewAction.ChangeContent(content: status))
    }
    
    // TODO:- 条件が汚すぎるのをなんとかする
    private func positionChangeStatus(_ x: CGFloat) {
        var status = ExchangeResultType.reccomend
        if ((0.0 <= x) && (x <= 0.1) && (x != 0.008) && (x != 0.016) && (x != 0.024)) || (x == 0.992) || (x == 1.984) || (x == 2.976) {
            status = ExchangeResultType.reccomend
        } else if ((0.9 <= x) && (x <= 1.1) && (x != 0.992) && (x != 1.008) && (x != 1.016)) || (x == 0.008) || (x == 1.992) || (x == 2.984) {
            status = ExchangeResultType.onlyMe
        } else if ((1.9 <= x) && (x <= 2.1) && (x != 1.984) && (x != 1.992) && (x != 2.008)) || (x == 0.016) || (x == 1.008) || (x == 2.992) {
            status = ExchangeResultType.onlyYou
        } else if ((2.9 <= x) && (x <= 3.0) && (x != 2.976) && (x != 2.984) && (x != 2.992)) || (x == 0.024) || (x == 1.016) || (x == 2.008) {
            status = ExchangeResultType.both
        }
        self.store.dispatch(ExchangeResultViewAction.ChangeContent(content: status))
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollTo position: CGPoint, direction: NavigationDirection, animated: Bool) {
        super.pageboyViewController(self, didScrollTo: position, direction: direction, animated: animated)
        positionChangeStatus(position.x)
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: TabmanViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(self, willScrollToPageAt: index, direction: direction, animated: animated)
        indexChangeStatus(index)
    }
    
}

//extension ResultTopVC: ResultScrollDelegate {
//    func reload() {
//        switch currentIndex! {
//        case 0:
//            (viewControllers[0] as! ResultRecommCardVC).fetchAnimeModel()
//        case 1:
//            (viewControllers[1] as! ResultMeCardVC).fetchAnimeModel()
//        case 2:
//            (viewControllers[2] as! ResultYouCardVC).fetchAnimeModel()
//        case 3:
//            (viewControllers[3] as! ResultBothCardVC).fetchAnimeModel()
//        default:
//            break
//        }
//    }
// }

extension ExchangeResultTopVC: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: ResultBarTitles.titles[index])
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

private extension RxStore where AnyStateType == ExchangeViewState {
    var state: Driver<ExchangeResultViewState> {
        return stateDriver.mapDistinct { $0.resultViewState }
    }
    
    var content: Driver<ExchangeResultType> {
        return state.mapDistinct { $0.content }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
