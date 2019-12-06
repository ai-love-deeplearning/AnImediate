//
//  HomeTopVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/25.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import Tabman
import Pageboy
import ReSwift
import RxCocoa
import RxSwift

class HomeTopVC: TabmanViewController {
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.homeStore)
    
    private var viewState: HomeArchiveListViewState {
        return store.state.homeArchiveListViewState
    }
    
    // ページングメニューに対応したビューコントローラ
    private lazy var viewControllers: [UIViewController] = {
        [
            StoryboardScene.Home.homeArchiveListSB.instantiate(),
            StoryboardScene.Home.homeArchiveListSB.instantiate(),
            StoryboardScene.Home.homeArchiveListSB.instantiate(),
            StoryboardScene.Home.homeArchiveListSB.instantiate()
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        initBars()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if !CommonStateModel.read().isRegistered {
            performSegue(withIdentifier: "toEdit", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            button.font = UIFont(name: "Hiragino Maru Gothic ProN", size: UIFont.labelFontSize)!
            // 選択時の色
            button.selectedTintColor = .MainThema
            
        }
        
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func indexChangeStatus(_ index: Int) {
        var status = AnimeStatusType.keep
        switch index {
        case 0:
         status = AnimeStatusType.keep
        case 1:
         status = AnimeStatusType.now
        case 2:
         status = AnimeStatusType.done
        case 3:
         status = AnimeStatusType.stop
        default:
         status = AnimeStatusType.none
        }
        self.store.dispatch(HomeArchiveListViewAction.ChangeContent(content: status))
    }
    
    // TODO:- 条件が汚すぎるのをなんとかする
    private func positionChangeStatus(_ x: CGFloat) {
        var status = AnimeStatusType.keep
        if ((0.0 <= x) && (x <= 0.1) && (x != 0.008) && (x != 0.016) && (x != 0.024)) || (x == 0.992) || (x == 1.984) || (x == 2.976) {
            status = AnimeStatusType.keep
        } else if ((0.9 <= x) && (x <= 1.1) && (x != 0.992) && (x != 1.008) && (x != 1.016)) || (x == 0.008) || (x == 1.992) || (x == 2.984) {
            status = AnimeStatusType.now
        } else if ((1.9 <= x) && (x <= 2.1) && (x != 1.984) && (x != 1.992) && (x != 2.008)) || (x == 0.016) || (x == 1.008) || (x == 2.992) {
            status = AnimeStatusType.done
        } else if ((2.9 <= x) && (x <= 3.0) && (x != 2.976) && (x != 2.984) && (x != 2.992)) || (x == 0.024) || (x == 1.016) || (x == 2.008) {
            status = AnimeStatusType.stop
        }
        self.store.dispatch(HomeArchiveListViewAction.ChangeContent(content: status))
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

extension HomeTopVC: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: HomeBarTitles.titles[index])
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

private extension RxStore where AnyStateType == HomeViewState {
    var state: Driver<HomeArchiveListViewState> {
        return stateDriver.mapDistinct { $0.homeArchiveListViewState }
    }
    
    var statusType: Driver<AnimeStatusType> {
        return state.mapDistinct { $0.statusType }
    }
    
    var error: Driver<AnimediateError> {
        return state.mapDistinct { $0.error }.skipNil()
    }
    
}
