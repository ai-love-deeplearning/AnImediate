//
//  HomeVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/25.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class HomeVC: TabmanViewController {
    
    // ページングメニューに対応したビューコントローラ
    private lazy var viewControllers: [UIViewController] = {
        [
            storyboard!.instantiateViewController(withIdentifier: "willSeeSB"),
            storyboard!.instantiateViewController(withIdentifier: "seeingSB"),
            storyboard!.instantiateViewController(withIdentifier: "notSeeSB"),
            storyboard!.instantiateViewController(withIdentifier: "sawSB")
        ]
    }()
    
    let barTitles = ["見たい", "見てる", "見た", "見てない"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        initBars()
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

extension HomeVC: PageboyViewControllerDataSource, TMBarDataSource {
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
