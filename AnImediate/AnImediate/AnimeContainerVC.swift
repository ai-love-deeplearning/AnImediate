//
//  AnimeContainerVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/10.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class AnimeContainerVC: TabmanViewController {

    private lazy var viewControllers: [UIViewController] = {
        [storyboard!.instantiateViewController(withIdentifier: "info"),
         storyboard!.instantiateViewController(withIdentifier: "episodes"),
         storyboard!.instantiateViewController(withIdentifier: "reviews"),
         storyboard!.instantiateViewController(withIdentifier: "rinks")]
    }()
    
    let barTitles = ["基本情報", "各話", "レビュー", "リンク"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        initBars()
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

extension AnimeContainerVC: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: barTitles[index])
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
