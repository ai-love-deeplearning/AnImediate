//
//  AccordionSectionHeaderView.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/07/14.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class AccordionSectionHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var section: Int = 0
    
    class func instance() -> AccordionSectionHeaderView {
        let nib = UINib(nibName: "AccordionSectionHeaderView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? AccordionSectionHeaderView else { fatalError() }
        return view
    }
    
    func setTitle(title: String?) {
        titleLabel.text = title
    }
    
    func setImage(isOpen: Bool?) {
        guard let isOpen = isOpen else {
            imageView.image = nil
            return
        }
        imageView.image = isOpen ? UIImage(named: "up-arrow") : UIImage(named: "down-arrow")
    }

}
