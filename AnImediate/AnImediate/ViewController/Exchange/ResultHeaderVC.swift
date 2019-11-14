//
//  ResultHeaderVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import RealmSwift
import MXParallaxHeader

class ResultHeaderVC: UIViewController {

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var resultUserInfo: [PeerModel] = []
    
    private let realm = try! Realm()
    var resultVC: ResultVC = ResultVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultVC.headerDelegate = self
        
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
        
        let userInfo = realm.objects(PeerModel.self)
        let index = UserDefaults.standard.integer(forKey: "userNum")
        /*
        for user in (userInfo).reversed() {
            self.resultUserInfo.append(user)
        }
        self.resultUserInfo.removeLast()
        
        if !self.resultUserInfo.isEmpty {
            nameLabel.text = self.resultUserInfo[index].name
            commentLabel.text = self.resultUserInfo[index].comment
            iconImageView.image = self.resultUserInfo[index].icon
            backImageView.image = self.resultUserInfo[index].background
        }*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        parallaxHeader?.minimumHeight = 0
    }
}

extension ResultHeaderVC: ResultHeaderDelegate {
    func reload() {
        let index = UserDefaults.standard.integer(forKey: "userNum")
        /*
        nameLabel.text = self.resultUserInfo[index].name
        commentLabel.text = self.resultUserInfo[index].comment
        iconImageView.image = self.resultUserInfo[index].icon
        backImageView.image = self.resultUserInfo[index].background
 */
    }
}

extension ResultHeaderVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        //let alpha = 1 - min(1, parallaxHeader.progress)
        let alpha = 1 - (parallaxHeader.progress - 0.27)
        visualEffectView.alpha = alpha
    }
    
}
