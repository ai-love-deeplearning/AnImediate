//
//  AccordionViewModel.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class AccordionViewModel {

    var currentAnimation = UITableView.RowAnimation.fade
    
    private var sectionContents: [SectionContents] = []
    
    func addSectionContent(content: SectionContents) {
        sectionContents.append(content)
    }
    
    func sectionCount() -> Int {
        return sectionContents.count
    }
    
    func rowCount(section: Int) -> Int {
        if sectionCount() == 0 { return 0 }
        // 開いているセクションだったらgenre分の個数を返す
        if sectionContents[section].isOpen { return sectionContents[section].genreTitles?.count ?? 0 }
        // 開いてないセクションだったら0
        return 0
    }
    
    func categoryTitle(section: Int) -> String? {
        if sectionCount() == 0 { return nil }
        return sectionContents[section].categoryTitle
    }
    
    func cellTitle(indexPath: IndexPath) -> String? {
        if sectionCount() == 0 { return nil }
        if let genreTitles = sectionContents[indexPath.section].genreTitles {
            return genreTitles[indexPath.row]
        }
        return nil
    }
    
    func isOpen(in section: Int) -> Bool {
        if sectionContents.isEmpty { return false }
        return sectionContents[section].isOpen
    }
    
    func changeIsOpen(section: Int) {
        if sectionContents.isEmpty { return }
        let isOpen = sectionContents[section].isOpen
        sectionContents[section].isOpen = !isOpen
    }
}

struct SectionContents {
    var categoryTitle: String?
    var isOpen: Bool = false
    var genreTitles: [String]?
    
    init(categoryTitle: String? = nil, isOpen: Bool = false, genreTitles: [String]? = nil) {
        self.categoryTitle = categoryTitle
        self.isOpen = isOpen
        self.genreTitles = genreTitles
    }
}
