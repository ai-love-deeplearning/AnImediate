//
//  ExchangeVC.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/27.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class ExchangeVC: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    
    @objc func labelAnimetion(_ label: UILabel) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let gradientRingLayer = WCGraintCircleLayer(bounds: loadingView.bounds, position: CGPoint(x: loadingView.frame.width/2, y: loadingView.frame.height/2), fromColor: .deepMagenta(), toColor: UIColor.white, linewidth: 8.0, toValue: 0)
        loadingView.layer.addSublayer(gradientRingLayer)
        
        let duration = 1.0
        gradientRingLayer.animateCircleTo(duration: duration, fromValue: 0, toValue: 0.99)
        
        Timer.scheduledTimer(
            timeInterval: 0.1, //秒
            target: self,
            selector: #selector(self.labelAnimetion(_:)), //実行するメソッド
            userInfo: 1, //何かしらのパラメータ
            repeats: true //繰り返し
        )
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
