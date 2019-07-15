//
//  BroadcastTableVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/14.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import RealmSwift

class BroadcastTableVC: UIViewController {
    
    private var viewModel = AccordionViewModel()
    @IBOutlet weak var broadcastTable: UITableView!
    
    let realm = try! Realm()
    
    private let seasons: [String] = ["冬", "春", "夏", "秋"]
    private let seasonTexts: [String] = ["冬（1月 〜 3月）", "春（4月 〜 6月）", "夏（7月 〜 9月）", "秋（10月 〜 12月）"]
    private let old: Int = 1972
    private let latest: Int = 2019
    private var works: [Work] = []
    private var selectedSeason: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        broadcastTable.delegate = self
        broadcastTable.dataSource = self
        broadcastTable.estimatedSectionHeaderHeight = 0
        
        title = viewModel.currentAnimation.rowName()
        broadcastTable.tableFooterView = UIView(frame: .zero)
        
        addSectionContents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSectionContents() {
        for i in (old...latest).reversed() {
            viewModel.addSectionContent(content: SectionContents(categoryTitle: String(i) + "年", genreTitles: seasonTexts))
        }
    }
    
    @objc func toggleCategoryHeader(gestureRecognizer: UITapGestureRecognizer) {
        guard let header = gestureRecognizer.view as? AccordionSectionHeaderView else { return }
        // nilにしないと上下矢印が一瞬重なって見えてしまう
        header.setImage(isOpen: nil)
        viewModel.changeIsOpen(section: header.section)
        broadcastTable.beginUpdates()
        broadcastTable.reloadSections([header.section], with: viewModel.currentAnimation)
        broadcastTable.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnimeListCard" {
            let nextVC = segue.destination as! AnimeListCardVC
            nextVC.works = works
            nextVC.navigationItem.title = selectedSeason
        }
    }

}

extension BroadcastTableVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount(section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = AccordionSectionHeaderView.instance()
        header.setTitle(title: viewModel.categoryTitle(section: section))
        header.section = section
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BroadcastTableVC.toggleCategoryHeader(gestureRecognizer: ))))
        header.setImage(isOpen: viewModel.isOpen(in: section))
        header.backgroundColor = .white
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    private func cellTitleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
        return viewModel.cellTitle(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellTitleForRowAtIndexPath(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSeason = String(latest - indexPath.section) + "年" + seasons[indexPath.row]
        works = Array(realm.objects(Work.self).filter("seasonNameText == %@", selectedSeason))
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "toAnimeListCard", sender: nil)
    }
    
}

extension UITableView.RowAnimation {
    func rowName() -> String {
        switch self {
        case .fade:
            return "fade"
        case .right:
            return "right"
        case .left:
            return "left"
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .none:
            return "none"
        case .middle:
            return "middle"
        case .automatic:
            return "automatic"
        @unknown default:
            return "fade"
        }
    }
}
