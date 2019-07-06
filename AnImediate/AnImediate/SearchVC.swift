//
//  SearchVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/02.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class SearchVC: TabmanViewController {
    
    // ページングメニューに対応したビューコントローラ
    private lazy var viewControllers: [UIViewController] = {
        [storyboard!.instantiateViewController(withIdentifier: "broadcast"),
         storyboard!.instantiateViewController(withIdentifier: "genre"),
         storyboard!.instantiateViewController(withIdentifier: "property"),
         storyboard!.instantiateViewController(withIdentifier: "ranking")]
    }()
    
    let barTitles = ["放送年", "ジャンル", "属性", "人気"]
    let searchController: UISearchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        self.dataSource = self
        initBars()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.title = "放送年"
        if #available(iOS 11.0, *) {
            // UISearchControllerをUINavigationItemのsearchControllerプロパティにセットする。
            navigationItem.searchController = searchController
            
            // trueだとスクロールした時にSearchBarを隠す（デフォルトはtrue）
            // falseだとスクロール位置に関係なく常にSearchBarが表示される
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // iOS 11未満は別処理が必要
            //tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    private func initBars() {
        let bar = TMBar.ButtonBar()
        bar.indicator.tintColor = .deepMagenta()
        bar.indicator.weight = .light
        bar.layout.transitionStyle = .snap
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

extension SearchVC: PageboyViewControllerDataSource, TMBarDataSource {
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

// MARK: - UISearchResultsUpdating
extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // SearchBarに入力したテキストを使って表示データをフィルタリングする。
        /*let text = searchController.searchBar.text ?? ""
        if text.isEmpty {
            filteredTitles = titles
        } else {
            filteredTitles = titles.filter { $0.contains(text) }
        }
        tableView.reloadData()*/
    }
}
