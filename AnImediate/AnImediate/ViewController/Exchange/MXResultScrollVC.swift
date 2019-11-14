//
//  MXResultScrollVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/17.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import MXParallaxHeader

class MXResultScrollVC: MXScrollViewController {
    
    var resultVC: ResultVC = ResultVC()
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
    }*/

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultHeader" {
            let next = segue.destination as! ResultHeaderVC
            next.resultVC = self.resultVC
        }
        if segue.identifier == "toResultScroll" {
            let next = segue.destination as! ResultScrollVC
            next.resultVC = self.resultVC
        }
    }

}
