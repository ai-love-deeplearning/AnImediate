//
//  AnimeDetailsHeaderVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/10.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class AnimeDetailsHeaderVC: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var animeImageView: UIImageView!
    @IBOutlet weak var backEffectView: UIVisualEffectView!
    
    let blurEffect = UIBlurEffect(style: .light)
    
    public var imageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageURL = UserDefaults.standard.string(forKey: "imageURL")!
        
        parallaxHeader?.height = 242
        parallaxHeader?.mode = .fill
        
        backEffectView.effect = blurEffect
        
        setIconImageView(imageUrlString: imageURL)
        self.backImageView.contentMode = .scaleToFill
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        
        parallaxHeader?.minimumHeight = statusBarHeight + navBarHeight
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
