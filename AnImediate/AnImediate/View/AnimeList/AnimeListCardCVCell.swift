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
import FirebaseUI

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

    public func bindData(work: AnimeModel) {
        
        animeId = work.annictID
        imageURL = work.imageUrl
        
        titleLabel.text = work.title
        seasonLabel.text = work.seasonNameText
        registLabel.text = String(work.watchersCount)
        
        setImage(work.annictID)
        iconImageView.contentMode = .scaleAspectFill
    }
    
    private func setImage(_ imageRef: String) {
        let reference = Storage.storage().reference().child(imageRef)
        let placeholderImage = UIImage(named: "pic")
        iconImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
    
}
