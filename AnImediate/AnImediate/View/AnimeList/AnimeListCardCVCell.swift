//
//  AnimeListCardCVCell.swift
//  AnImediate
//
//  Created by 前田陸 on 2019/07/15.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit

class AnimeListCardCVCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var registLabel: UILabel!
    
    var animeId = ""
    var imageURL = ""
    var seasonText = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func bindData(work: Work) {
        /*
        animeId = work.animeId
        imageURL = work.imageUrl
        
        titleLabel.text = work.title
        seasonLabel.text = work.seasonNameText
        registLabel.text = String(work.watchersCount)
        
        setIconImageView(imageUrlString: work.imageUrl)
        iconImageView.contentMode = .scaleAspectFill*/
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
