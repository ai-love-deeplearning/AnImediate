//
//  ArchiveCollectionViewCell.swift
//  AnImediate
//
//  Created by 川村周也 on 2020/02/13.
//  Copyright © 2020 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import Firebase
import FirebaseUI

class ArchiveCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    public var annictID = ""
    private var imageURL = ""
    private var seasonText = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setData(_ archive: ArchiveModel) {
        let anime = AnimeModel.read(annictID: archive.annictID)
        annictID = anime.annictID
        imageURL = anime.imageUrl
        seasonText = anime.seasonNameText
        titleLabel.text = anime.title
    }
    
    public func setImage(_ imageRef: String) {
        let reference = Storage.storage().reference().child(imageRef)
        let placeholderImage = UIImage(named: "pic")
        thumbnail.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
    
}
