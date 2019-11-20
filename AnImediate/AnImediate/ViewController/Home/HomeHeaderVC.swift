//
//  HomeHeaderVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/26.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import RealmSwift
import MXParallaxHeader

class HomeHeaderVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    private let store = RxStore(store: AppStore.instance.homeStore)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        parallaxHeader?.delegate = self
        parallaxHeader?.height = ScreenConfig.homeParallaxHeaderHeight
        parallaxHeader?.minimumHeight = ScreenConfig.statusBarSize.height + ScreenConfig.navigationBarHeight
        parallaxHeader?.mode = .fill
        
        iconView.layer.cornerRadius = iconView.frame.width * 0.5
        iconView.layer.shadowOffset = .zero
        iconView.layer.shadowColor = UIColor.black.cgColor
        iconView.layer.shadowOpacity = 0.6
        iconView.layer.shadowRadius = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CommonStateModel.read().isRegistered {
            setViews()
        } else {
            // TODO:- CommonStateModel.isRegisteredを参照してfalseだったら初回登録
            //self.performSegue(withIdentifier: "toEdit", sender: nil)
        }
    }
    
    private func setViews() {
        let model = AccountModel.read()
        nameLabel.text = model.name
        idLabel.text = model.userID
        commentLabel.text = model.comment
        iconView.image = model.icon
        
        commentLabel.sizeToFit()
        // 44+99+22+label+22
        parallaxHeader?.height = ScreenConfig.statusBarSize.height + ScreenConfig.navigationBarHeight + 165 + commentLabel.bounds.height + 22
    }
    
}

extension HomeHeaderVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
//        if parallaxHeader.progress > 1.359 {
//            if let constraint = topConstraint {
//                constraint.isActive = true
//            }
//        } else {
//            if let constraint = topConstraint {
//                constraint.isActive = false
//            }
//        }
    }
}
