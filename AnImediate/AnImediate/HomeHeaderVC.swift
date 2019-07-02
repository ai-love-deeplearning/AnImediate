//
//  HomeHeaderVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/26.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import MXParallaxHeader

class HomeHeaderVC: UIViewController {

    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var imageProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parallaxHeader?.delegate = self
        parallaxHeader?.height = 400
        parallaxHeader?.mode = .fill
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        parallaxHeader?.minimumHeight = 88
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeHeaderVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        let alpha = 1 - min(1, parallaxHeader.progress)
        visualEffectView.alpha = alpha
    }
}
