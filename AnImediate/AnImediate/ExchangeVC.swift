//
//  ExchangeVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/27.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class ExchangeVC: UIViewController {
    
    let gradientRingLayer = WCGraintCircleLayer(bounds: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 200)), position:CGPoint(x: 200, y: 300), fromColor: .deepMagenta(), toColor: UIColor.white, linewidth: 8.0, toValue:0)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layer.addSublayer(gradientRingLayer)
        let duration = 1.0
        gradientRingLayer.animateCircleTo(duration: duration, fromValue: 0, toValue: 0.99)
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
