//
//  AnimeDetailsHeaderVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/10.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import MXParallaxHeader

class AnimeDetailsHeaderVC: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var animeImageView: UIImageView!
    @IBOutlet weak var backEffectView: UIVisualEffectView!
    @IBOutlet var animeImageTopConstraint: NSLayoutConstraint!
    
    
    let blurEffect = UIBlurEffect(style: .light)
    var newImageView = UIImageView()
    
    var statusBarHeight: CGFloat = 0
    var navBarHeight: CGFloat = 0
    
    public var imageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        
        self.imageURL = UserDefaults.standard.string(forKey: "imageURL")!
        
        parallaxHeader?.delegate = self
        parallaxHeader?.height = 242
        parallaxHeader?.mode = .fill
        parallaxHeader?.minimumHeight = statusBarHeight + navBarHeight
        
        backEffectView.effect = blurEffect
        
        setIconImageView(imageUrlString: imageURL)
        self.backImageView.contentMode = .scaleToFill
        
        animeImageTopConstraint.constant = statusBarHeight + navBarHeight
        
    }
    
    private func setIconImageView(imageUrlString: String) {
        guard let iconImageUrl = URL(string: imageUrlString) else {return}
        let session = URLSession(configuration: .default)
        
        let downloadImageTask = session.dataTask(with: iconImageUrl) {(data, response, error) in
            guard let imageData = data else {return}
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async(execute: {
                self.animeImageView.image = image
                self.backImageView.image = image
            })
            
        }
        downloadImageTask.resume()
    }
}

extension AnimeDetailsHeaderVC: MXParallaxHeaderDelegate {
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        if parallaxHeader.progress > 1.359 {
            animeImageTopConstraint.isActive = true
        } else {
            if let constraint = animeImageTopConstraint {
                constraint.isActive = false
            }
        }
    }
}
