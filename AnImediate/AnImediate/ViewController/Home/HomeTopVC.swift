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

class HomeTopVC: TabmanViewController {
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initBars() {
        let bar = TMBar.ButtonBar()
        bar.indicator.tintColor = .deepMagenta()
        bar.indicator.weight = .light
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit
        bar.layout.view.backgroundColor = .white
        bar.buttons.customize { (button) in
            // 通常時の色
            button.tintColor = .lightGray
            button.font = UIFont(name: "Hiragino Maru Gothic ProN", size: UIFont.labelFontSize)!
            // 選択時の色
            button.selectedTintColor = .deepMagenta()
            
        }
        
        addBar(bar, dataSource: self, at: .top)
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
    /*
    func barItem(for tabViewController: TabmanViewController, at index: Int) -> TMBarItemable {
        let title = "Page \(index)"
        return TMBarItem(title: title)
    }*/
}
