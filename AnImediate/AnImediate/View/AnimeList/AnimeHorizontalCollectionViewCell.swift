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
import FirebaseUI

class AnimeHorizontalCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    public var annictID = ""
    private var imageURL = ""
    private var seasonText = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.tintColor = .deepMagenta()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.cornerRadius = iconImageView.bounds.width / 2
    }
    
    public func setData(anime: AnimeModel) {
        annictID = anime.annictID
        imageURL = anime.imageUrl
        titleLabel.text = anime.title
        
        seasonText = anime.seasonNameText
    }
    
    public func setImage(_ imageRef: String) {
        let reference = Storage.storage().reference().child(imageRef)
        // TODO:- No image画像を作る
        // TODO:- 画像がない奴はこれで自動的にNo Imageになるのでは？
        let placeholderImage = UIImage(named: "pic")
        iconImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
    
}
