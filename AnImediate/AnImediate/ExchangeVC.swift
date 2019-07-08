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
    @IBOutlet weak var seachLLabel: UILabel!
    
    var timer: Timer!
    var count = 0
    
    @objc func labelAnimetion(_ tm: Timer) {
        switch count {
        case 0:
            seachLLabel.text = "Searching.  "
            count = 1
        case 1:
            seachLLabel.text = "Searching.. "
            count = 2
        case 2:
            seachLLabel.text = "Searching..."
            count = 0
        default:
            break;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initGradientLayer()
        /*
        DispatchQueue.global().async {
            while true {
                Thread.sleep(forTimeInterval: 1)
                DispatchQueue.main.async {
                    self.labelAnimetion()
                }
            }
        }*/
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.labelAnimetion(_:)), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        timer = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initGradientLayer()
    }
    
    func initGradientLayer() {
        let gradientRingLayer = WCGraintCircleLayer(bounds: loadingView.bounds, position: CGPoint(x: loadingView.frame.width/2, y: loadingView.frame.height/2), fromColor: .deepMagenta(), toColor: UIColor.white, linewidth: 8.0, toValue: 0)
        if loadingView.layer.sublayers != nil {
            loadingView.layer.sublayers!.forEach {
                $0.removeFromSuperlayer()
            }
        }
        loadingView.layer.addSublayer(gradientRingLayer)
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
