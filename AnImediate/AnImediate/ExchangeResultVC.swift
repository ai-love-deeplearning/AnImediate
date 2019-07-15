//
//  ExchangeResult.swift
//  AnImediate
//
//  Created by 田渕知明 on 2019/07/03.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class ExchangeResultVC: TabmanViewController {
    // ページングメニューに対応したビューコントローラ
    private lazy var viewControllers: [UIViewController] = {
        [
            storyboard!.instantiateViewController(withIdentifier: "recommend"),
            storyboard!.instantiateViewController(withIdentifier: "forYou"),
            storyboard!.instantiateViewController(withIdentifier: "forOpponent"),
            storyboard!.instantiateViewController(withIdentifier: "both")
        ]
    }()
    
    let barTitles = ["おすすめ ", "あなたのみ", "相手のみ", "二人とも"]
    
    var showData: [WatchData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        initBars()
        do {
            // NSData → WatchData
            let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(UserDefaults.standard.data(forKey: "data")!) as! [WatchData]
            showData = decoded
        } catch {
            fatalError("archivedData failed with error: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initBars()
        do {
            // NSData → WatchData
            let decoded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(UserDefaults.standard.data(forKey: "data")!) as! [WatchData]
            showData = decoded
        } catch {
            fatalError("archivedData failed with error: \(error)")
        }
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

extension ExchangeResultVC: PageboyViewControllerDataSource, TMBarDataSource {
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
}
