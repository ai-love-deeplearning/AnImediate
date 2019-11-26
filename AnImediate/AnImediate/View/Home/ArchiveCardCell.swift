//
//  ArchiveCardCell.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/10/02.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import AppConfig
import AppModel
import UIKit
import FirebaseUI

final class ArchiveCardCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var seasonLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingTitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setArchive(_ archive: ArchiveModel) {
        let anime = AnimeModel.read(annictID: archive.annictID)
        titleLabel.text = anime.title
        seasonLabel.text = anime.seasonNameText
        companyLabel.text = anime.company
        ratingTitleLabel.text = (archive.evalPoint == "") ? "予測評価" : "評価"
        
        let rating = (archive.evalPoint == "") ? archive.predictPoint : archive.evalPoint
        ratingLabel.text = rating + " / 5.0"
        
        setImage("iconImages/\(anime.annictID).jpg")
        iconImageView.contentMode = .scaleAspectFill
    }
    
    private func setImage(_ imageRef: String) {
        let reference = Storage.storage().reference().child(imageRef)
        let placeholderImage = UIImage(named: "pic")
        iconImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
    }
    
}

