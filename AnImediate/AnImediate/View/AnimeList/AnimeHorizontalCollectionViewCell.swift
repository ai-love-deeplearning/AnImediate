//
//  AnimeHorizontalCollectionViewCell.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/02.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit

class AnimeHorizontalCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    public var annictID = ""
    private var imageURL = ""
    private var seasonText = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setData(anime: AnimeModel) {
        annictID = anime.annictID
        imageURL = anime.imageUrl
        titleLabel.text = anime.title
        titleLabel.tintColor = .deepMagenta()
        seasonText = anime.seasonNameText
        
        setIconImageView(imageUrlString: anime.imageUrl)
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.cornerRadius = iconImageView.bounds.width / 2
    }
    
    private func setIconImageView(imageUrlString: String) {
        guard let iconImageUrl = URL(string: imageUrlString) else {return}
        let session = URLSession(configuration: .default)
        let downloadImageTask = session.dataTask(with: iconImageUrl) {(data, response, error) in
            guard let imageData = data else {return}
            let image = UIImage(data: imageData)
            DispatchQueue.main.async(execute: {
                self.iconImageView.image = image
            })
        }
        downloadImageTask.resume()
    }
}
