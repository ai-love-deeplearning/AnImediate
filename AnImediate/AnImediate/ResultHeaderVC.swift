//
//  ResultHeaderVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import RealmSwift
import MXParallaxHeader

class ResultHeaderVC: UIViewController {

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parallaxHeader?.delegate = self
        parallaxHeader?.height = 300
        parallaxHeader?.mode = .fill
        
        iconImageView.layer.cornerRadius = iconImageView.frame.width * 0.5
        iconImageView.layer.shadowOffset = .zero
        iconImageView.layer.shadowColor = UIColor.black.cgColor
        iconImageView.layer.shadowOpacity = 0.6
        iconImageView.layer.shadowRadius = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let results = realm.objects(UserInfo.self)
        if results.count != 1 {
            nameLabel.text = results.last?.name
            commentLabel.text = results.last?.comment
            iconImageView.image = results.last?.icon
            backImageView.image = results.last?.background
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        parallaxHeader?.minimumHeight = 0
    }
}

extension ResultHeaderVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        //let alpha = 1 - min(1, parallaxHeader.progress)
        let alpha = 1 - (parallaxHeader.progress - 0.27)
        visualEffectView.alpha = alpha
    }
}
