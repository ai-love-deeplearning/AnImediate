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

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    private let store = RxStore(store: AppStore.instance.homeStore)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
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
        
        if store.state.profileEditViewState.isFirstEdit {
            // AccountModelを参照して空だったら初回登録
            //self.performSegue(withIdentifier: "toEdit", sender: nil)
        } else {
            setViews()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        
        parallaxHeader?.minimumHeight = statusBarHeight + navBarHeight
    }
    
    private func setViews() {
        let model = AccountModel.read()
        nameLabel.text = model.name
        commentLabel.text = model.comment
        iconView.image = model.icon
        backView.image = model.background
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEdit" {
            let nc: UINavigationController = segue.destination as! UINavigationController
            let nextVC = nc.topViewController as! ProfileEditVC
            print("profile is empty")
        }
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
