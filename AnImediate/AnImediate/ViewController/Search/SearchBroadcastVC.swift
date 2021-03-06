//
//  SearchBroadcastVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/14.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import ReSwift
import RxSwift
import RxCocoa
import RealmSwift

class SearchBroadcastVC: UIViewController {
    
    private var viewModel = AccordionViewModel()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var broadcastTable: UITableView!
    
    private var disposeBag = DisposeBag()
    
    private let store = RxStore(store: AppStore.instance.animeListStore)
    
    private let seasons: [String] = ["冬", "春", "夏", "秋"]
    private let seasonTexts: [String] = ["冬（1月 〜 3月）", "春（4月 〜 6月）", "夏（7月 〜 9月）", "秋（10月 〜 12月）"]
    private let old: Int = 1972
    private let latest: Int = 2019
    //private var works: [AnimeModel] = []
    private var selectedSeason: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        broadcastTable.delegate = self
        broadcastTable.dataSource = self
        broadcastTable.estimatedSectionHeaderHeight = 0
        
        title = viewModel.currentAnimation.rowName()
        broadcastTable.tableFooterView = UIView(frame: .zero)
        
        addSectionContents()
        
        initSearchBar()
    }
    
    private func initSearchBar() {
        searchBar.tintColor = .MainThema
        searchBar.barTintColor = .white
        searchBar.placeholder = "年代を入力"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "キャンセル"
//        searchBar.searchTextField.layer.cornerRadius = searchBar.searchTextField.bounds.height
//        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.backgroundColor = .WhiteSmoke
        searchBar.backgroundImage = UIImage()
        searchBar.isTranslucent = false
        searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
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
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnimeListTable" {
            let nextVC = segue.destination as! AnimeListTableVC
            //nextVC.works = works
            nextVC.navigationItem.title = selectedSeason
        }
    }

}

extension SearchBroadcastVC: UITableViewDelegate, UITableViewDataSource {
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
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleCategoryHeader(gestureRecognizer: ))))
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
        cell.textLabel?.textColor = .TextGray
        cell.textLabel?.text = cellTitleForRowAtIndexPath(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let config = Realm.Configuration(fileURL: Bundle.main.url(forResource: "anime", withExtension: "realm"),readOnly: true)
        let seedRealm = try! Realm(configuration: config)
        
        tableView.deselectRow(at: indexPath, animated: false)
        self.view.endEditing(true)
        
        self.store.dispatch(AnimeListTableViewAction.Initialize(contentType: .broadcast))
        selectedSeason = String(latest - indexPath.section) + "年" + seasons[indexPath.row]
        self.store.dispatch(AnimeListTableViewAction.SetSearchKey(searchKey: selectedSeason))
        performSegue(withIdentifier: "toAnimeListTable", sender: nil)
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchBroadcastVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = true
        if let year = Int(searchBar.text!) {
            broadcastTable.scrollToRow(at: IndexPath(row: NSNotFound, section: 2019 - year), at: .top, animated: false)
        } else {
            print("検索には数字を入力してください")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = ""
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

private extension RxStore where AnyStateType == AnimeListViewState {
    var state: Driver<AnimeListTableViewState> {
        return stateDriver.mapDistinct { $0.tableViewState }
    }
    
}
