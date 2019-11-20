//
//  ExchangeResultTopVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import UIKit
import Tabman
import Pageboy

class ExchangeResultTopVC: TabmanViewController {
    
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
            button.font = UIFont(name: "Hiragino Maru Gothic ProN", size: UIFont.labelFontSize)!
            // 選択時の色
            button.selectedTintColor = .MainThema
            
        }
        
        addBar(bar, dataSource: self, at: .top)
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

