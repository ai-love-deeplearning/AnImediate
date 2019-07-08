//
//  HomeHeaderVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/26.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import RealmSwift
import MXParallaxHeader

class HomeHeaderVC: UIViewController {

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parallaxHeader?.delegate = self
        parallaxHeader?.height = 400
        parallaxHeader?.mode = .fill
        
        iconView.layer.cornerRadius = iconView.frame.width * 0.5
        iconView.layer.shadowOffset = .zero
        iconView.layer.shadowColor = UIColor.black.cgColor
        iconView.layer.shadowOpacity = 0.6
        iconView.layer.shadowRadius = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let results = realm.objects(UserInfo.self)
        
        nameLabel.text = results[0].name
        commentLabel.text = results[0].comment
        iconView.image = results[0].icon
        backView.image = results[0].background
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        parallaxHeader?.minimumHeight = 88
    }
    
    @IBAction func editBtnTapped(_ sender: Any) {
        
    }
    
}

extension HomeHeaderVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        //let alpha = 1 - min(1, parallaxHeader.progress)
        let alpha = 1 - (parallaxHeader.progress - 0.27)
        visualEffectView.alpha = alpha
    }
}
