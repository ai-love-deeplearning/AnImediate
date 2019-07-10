//
//  InfoVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/10.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    
    let animeContainerVC = AnimeContainerVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(animeContainerVC.titleText)
        
        titleLabel.text = animeContainerVC.titleText
        seasonLabel.text = "放送年：" + animeContainerVC.seasonText
    }

}
