//
//  AnimeDetailsVC.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/10.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit

class AnimeDetailsVC: UIViewController {

    @IBOutlet weak var animeImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    let blurEffect = UIBlurEffect(style: .light)
    
    public var imageURL = ""
    public var titleText = ""
    public var seasonText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame.size = self.backImageView.frame.size
        self.backImageView.addSubview(visualEffectView)
        
        setIconImageView(imageUrlString: imageURL)
        self.backImageView.contentMode = .scaleToFill
        
        self.navigationItem.title = "アニメ詳細"
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContainer" {
            let containerVC: AnimeContainerVC = segue.destination as! AnimeContainerVC
            containerVC.titleText = self.titleText
            containerVC.seasonText = self.seasonText
        }
    }
}
