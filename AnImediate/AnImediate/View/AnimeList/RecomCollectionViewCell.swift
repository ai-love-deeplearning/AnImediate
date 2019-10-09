//
//  RecomCollectionViewCell.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit

class RecomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var recomImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var annictID = ""
    private var imageURL = ""
    private var seasonText = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setData(anime: AnimeModel) {
        annictID = anime.annictID
        imageURL = anime.imageUrl
        titleLabel.text = anime.title
        seasonText = anime.seasonNameText
        
        setIconImageView(imageUrlString: anime.imageUrl)
        recomImageView.contentMode = .scaleAspectFill
    }
    
    private func setIconImageView(imageUrlString: String) {
        guard let iconImageUrl = URL(string: imageUrlString) else {return}
        let session = URLSession(configuration: .default)
        let downloadImageTask = session.dataTask(with: iconImageUrl) {(data, response, error) in
            guard let imageData = data else {return}
            let image = UIImage(data: imageData)
            DispatchQueue.main.async(execute: {
                self.recomImageView.image = image
            })
        }
        downloadImageTask.resume()
    }
}
