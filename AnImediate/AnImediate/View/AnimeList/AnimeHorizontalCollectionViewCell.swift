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
import Firebase
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
        titleLabel.tintColor = .MainThema
        iconImageView.contentMode = .scaleAspectFill
//        iconImageView.cornerRadius = iconImageView.bounds.width / 2
    }
    
    public func setData(anime: AnimeModel) {
        annictID = anime.annictID
        imageURL = anime.imageUrl
        seasonText = anime.seasonNameText
        titleLabel.text = anime.title
    }
    
    public func setData(user: PeerModel) {
        titleLabel.text = user.name
        iconImageView.image = user.icon
    }
    
    public func setImage(_ imageRef: String) {
        let reference = Storage.storage().reference().child(imageRef)
        let placeholderImage = UIImage(named: "pic")
        iconImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
    
}
