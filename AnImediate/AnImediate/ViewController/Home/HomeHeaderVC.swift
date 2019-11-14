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
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    private let store = RxStore(store: AppStore.instance.homeStore)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        parallaxHeader?.delegate = self
        parallaxHeader?.height = ScreenConfig.homeParallaxHeaderHeight
        parallaxHeader?.mode = .fill
        
        iconView.layer.cornerRadius = iconView.frame.width * 0.5
        iconView.layer.shadowOffset = .zero
        iconView.layer.shadowColor = UIColor.black.cgColor
        iconView.layer.shadowOpacity = 0.6
        iconView.layer.shadowRadius = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if store.state.profileEditViewState.isFirstEdit {
            // AccountModelを参照して空だったら初回登録
            //self.performSegue(withIdentifier: "toEdit", sender: nil)
        } else {
            setViews()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        parallaxHeader?.minimumHeight = ScreenConfig.statusBarSize.height + ScreenConfig.navigationBarHeight
    }
    
    private func setViews() {
        let model = AccountModel.read()
        nameLabel.text = model.name
        commentLabel.text = model.comment
        iconView.image = model.icon
    }
    
}

extension HomeHeaderVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        //let alpha = 1 - min(1, parallaxHeader.progress)
        let alpha = 1 - (parallaxHeader.progress - 0.27)
    }
}
