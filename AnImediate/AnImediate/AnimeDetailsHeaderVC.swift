//
//  AnimeDetailsHeaderVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/09.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import MXParallaxHeader

class AnimeDetailsHeaderVC: UIViewController {
    @IBOutlet weak var animeImageView: UIImageView!
    
    public var imageURL = "https://annict.imgix.net/shrine/workimage/604/image/master-0bad88db8a4e54a196b89a7ab2b59664.jpg?ixlib=rails-3.0.2&auto=format&w=270&h=360&fit=fillmax&fill=blur&s=e53bcf6d3d42be3aebcf3da767f7bb25"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        self.navigationItem.title = "アニメ詳細"
        
        parallaxHeader?.delegate = self
        parallaxHeader?.height = 269
        parallaxHeader?.mode = .fill

        setIconImageView(imageUrlString: imageURL)
        animeImageView.contentMode = .scaleAspectFill
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        parallaxHeader?.minimumHeight = 88
    }
    
    private func setIconImageView(imageUrlString: String) {
        guard let iconImageUrl = URL(string: imageUrlString) else {return}
        let session = URLSession(configuration: .default)
        
        let downloadImageTask = session.dataTask(with: iconImageUrl) {(data, response, error) in
            guard let imageData = data else {return}
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async(execute: {
                self.animeImageView.image = image
            })
            
        }
        downloadImageTask.resume()
    }
}

extension AnimeDetailsHeaderVC: MXParallaxHeaderDelegate {
}
