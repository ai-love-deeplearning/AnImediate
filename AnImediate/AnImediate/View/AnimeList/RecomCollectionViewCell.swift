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
import FirebaseUI

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
        
        setImage("iconImages/\(anime.annictID).jpg")
        recomImageView.contentMode = .scaleAspectFill
    }
    
    public func setImage(_ imageRef: String) {
        let reference = Storage.storage().reference().child(imageRef)
        let placeholderImage = UIImage(named: "pic")
        recomImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
    
}
